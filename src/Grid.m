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

- (instancetype)initAt: (Vector3)position size: (Vector3)size
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

- (instancetype)initAt:(Vector3)position size: (size_t)size
{
    self = [super init];

    _position = position;

    auto boxes = [OFMutableArray<OFArray<OFArray<GridBox *> *> *> arrayWithCapacity: size];

    for (auto x = 0u; x < size; x++) {
        auto row = [OFMutableArray<OFArray<GridBox *> *> arrayWithCapacity: size];
        for (auto y = 0u; y < size; y++) {
            auto col = [OFMutableArray<GridBox *> arrayWithCapacity: size];
            for (auto z = 0u; z < size; z++) {
                [col addObject: [[GridBox alloc] initAt: (Vector3) {
                    (position.x + x * 2)-1,
                    (position.y + y * 2)-1,
                    (position.z + z * 2)-1
                } size: (Vector3){1, 1, 1}]];
            }
            [col makeImmutable];
            [row addObject: col];
        }
        [row makeImmutable];
        [boxes addObject: row];
    }

    [boxes makeImmutable];
    _boxes = boxes;

    _size = size;

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
    //for math later on this has to be signed, yes it's a downcast but theres no way your grid will be larger than SSIZE_T_MAX I hope
    auto n = (ssize_t)_size;
    static const int DIRECTIONS[][3] = {
        {1, 0, 0}, {0, 1, 0}, {0, 0, 1},  //x, y, z directions
        {1, 1, 0}, {1, 0, 1}, {0, 1, 1},  //2D diagonals
        {1, 1, 1}, {-1, 1, 1},            //3D diagonals
        {1, 1, -1}, {-1, 1, -1},          // Diagonals on bottom face
        {1, -1, 1}, {-1, -1, 1}           // Diagonals on top face
    };

    for (auto x = 0; x < n; x++) {
        for (auto y = 0; y < n; y++) {
            for (auto z = 0; z < n; z++) {
                auto box = _boxes[x][y][z];
                if (box.occupier == nilptr) {
                    continue;
                }

                for (auto i = 0u; i < sizeof(DIRECTIONS) / sizeof(DIRECTIONS[0]); i++) {
                    int dx = DIRECTIONS[i][0], dy = DIRECTIONS[i][1], dz = DIRECTIONS[i][2];

                    //`dx` could be negative, so this must be an int so that `dx * count` results in an int
                    int count = 0;
                    while (true) {
                        auto nx = x + dx * count, ny = y + dy * count, nz = z + dz * count;
                        if (nx < 0  or nx >= n
                         or ny < 0  or ny >= n
                         or nz < 0  or nz >= n
                         or not [_boxes[nx][ny][nz].occupier isEqual: box.occupier]) {
                            break;
                        }

                        count++;
                    }

                    if (count == n) {
                        return box.occupier;
                    }
                }
            }
        }
    }

    return nilptr;
}

- (OFString *)description
{
    return [OFString stringWithFormat: @"Grid at (%.2f, %.2f, %.2f)", _position.x, _position.y, _position.z];
}

@end

$nonnil_end
