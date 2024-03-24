// Copyright (C) 2024 Amrit Bhogal
//
// This file is part of 3DTicTacToe.
//
// 3DTicTacToe is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// 3DTicTacToe is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with 3DTicTacToe.  If not, see <http://www.gnu.org/licenses/>.

#include "Grid.h"
#include <float.h>

$nonnil_begin

@implementation GridBox

- (instancetype)initAt: (Vector3)position size: (Vector3)size colour: (Color)colour
{
    self = [super init];

    _position = position;
    _size = size;

    return self;
}

- (void)draw
{
    DrawCubeV(_position, _size, _occupier ? _occupier.colour : BLANK);
    DrawCubeWiresV(_position, _size, BLACK);
}

- (void)drawSelectedOutline
{
    DrawCubeWiresV(_position, (Vector3) { _size.x + 0.1, _size.y + 0.1, _size.z + 0.1 }, MAROON);
}

- (OFString *)description
{
    return [OFString stringWithFormat: @"GridBox at (%.2f, %.2f, %.2f) colour: (#%02X%02X%02X%02X)",
                                                    _position.x, _position.y, _position.z,
                                                    (int)_occupier.colour.r, (int)_occupier.colour.g, (int)_occupier.colour.b, (int)_occupier.colour.a];
}

@end

@implementation Grid

- (instancetype)initAt:(Vector3)position width: (unsigned int)width height: (unsigned int)height depth: (unsigned int)depth
{
    self = [super init];

    _position = position;

    auto boxes = [OFMutableArray<OFArray<OFArray<GridBox *> *> *> arrayWithCapacity: width];

    for (auto x = 0u; x < width; x++) {
        auto row = [OFMutableArray<OFArray<GridBox *> *> arrayWithCapacity: height];
        for (auto y = 0u; y < height; y++) {
            auto col = [OFMutableArray<GridBox *> arrayWithCapacity: depth];
            for (auto z = 0u; z < depth; z++) {
                [col addObject: [[GridBox alloc] initAt: (Vector3) {
                    (position.x + x * 2)-1,
                    (position.y + y * 2)-1,
                    (position.z + z * 2)-1
                } size: (Vector3){1, 1, 1} colour: (Color[]){ RED, BLUE, GREEN, YELLOW, ORANGE, PINK, PURPLE }[(x * 3 + y) % 7]]];
            }
            [col makeImmutable];
            [row addObject: col];
        }
        [row makeImmutable];
        [boxes addObject: row];
    }

    [boxes makeImmutable];
    _boxes = boxes;

    _size = (Vector3) {width, height, depth};

    return self;
}

- (void)draw
{
    for (OFArray<OFArray<GridBox *> *> *row in _boxes) {
        for (OFArray<GridBox *> *col in row) {
            for (GridBox *box in col) {
                [box draw];
            }
        }
    }
}

- (GridBox *nillable)detectInteraction:(Camera3D)camera
{
    auto ray = GetMouseRay(GetMousePosition(), camera);
    GridBox *nillable closestBox = nilptr;
    float closestDistance = FLT_MAX;
    for (OFArray<OFArray<GridBox *> *> *row in _boxes) {
        for (OFArray<GridBox *> *col in row) {
            for (GridBox *box in col) {
                auto collision = GetRayCollisionBox(ray, (BoundingBox) {
                    (Vector3) { box.position.x - 0.5f, box.position.y - 0.5f, box.position.z - 0.5f },
                    (Vector3) { box.position.x + 0.5f, box.position.y + 0.5f, box.position.z + 0.5f }
                });

                if (collision.hit) {
                    if (collision.distance < closestDistance) {
                        closestDistance = collision.distance;
                        closestBox = box;
                    }
                }
            }
        }
    }

    return closestBox;
}

- (Player *nillable)checkWin
{
    // Check rows
    for (OFArray<OFArray<GridBox *> *> *row in _boxes) {
        for (OFArray<GridBox *> *col in row) {
            Player *nillable first = col[0].occupier;
            if (first == nilptr)
                continue;

            auto win = true;
            for (GridBox *box in col) {
                if (box.occupier != first) {
                    win = false;
                    break;
                }
            }

            if (win)
                return first;
        }
    }

    // Check columns
    for (auto x = 0ul; x < _boxes.count; x++) {
        for (auto z = 0ul; z < _boxes[0][0].count; z++) {
            auto first = _boxes[x][0][z].occupier;
            if (first == nilptr)
                continue;

            auto win = true;
            for (auto y = 0ul; y < _boxes[0].count; y++) {
                if (_boxes[x][y][z].occupier != first) {
                    win = false;
                    break;
                }
            }

            if (win)
                return first;
        }
    }

    // Check diagonals
    auto first = _boxes[0][0][0].occupier;
    if (first != nilptr) {
        auto win = true;
        for (auto i = 0ul; i < _boxes.count; i++) {
            if (_boxes[i][i][i].occupier != first) {
                win = false;
                break;
            }
        }

        if (win)
            return first;
    }

    first = _boxes[0][_boxes[0].count - 1][0].occupier;
    if (first != nilptr) {
        auto win = true;
        for (auto i = 0ul; i < _boxes.count; i++) {
            if (_boxes[i][_boxes[0].count - 1 - i][i].occupier != first) {
                win = false;
                break;
            }
        }

        if (win)
            return first;
    }

    return nilptr;
}

- (OFString *)description
{
    return [OFString stringWithFormat: @"Grid at (%.2f, %.2f, %.2f)", _position.x, _position.y, _position.z];
}

@end

$nonnil_end
