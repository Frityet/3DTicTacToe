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

@implementation GridBox

- (instancetype)initAt: (Vector3)position colour: (Color)colour
{
    self = [super init];

    _position = position;
    _colour = colour;

    return self;
}

- (void)draw
{
    DrawCubeV(_position, (Vector3){1, 1, 1}, _colour);
    DrawCubeWiresV(_position, (Vector3){1, 1, 1}, BLACK);
}

- (bool)detectInteraction:(Camera3D)camera
{
    auto ray = GetMouseRay(GetMousePosition(), camera);
    auto collision = GetRayCollisionBox(ray, (BoundingBox){
        .min = {
            _position.x - 0.5,
            _position.y - 0.5,
            _position.z - 0.5
        },

        .max = {
            _position.x + 0.5,
            _position.y + 0.5,
            _position.z + 0.5
        }
    });
    return collision.hit;
}

@end

@implementation Grid

- (instancetype)initAt: (Vector3)position boxColours: (Color[3][3][3])colour
{
    self = [super init];

    _position = position;

    _boxes = (__strong GridBox *(*)[3][3][3])malloc(sizeof(*_boxes));

    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            for (int k = 0; k < 3; k++) {
                (*_boxes)[i][j][k] = [[GridBox alloc] initAt: (Vector3) {
                    position.x + i,
                    position.y + j,
                    position.z + k
                } colour: colour[i][j][k]];
            }
        }
    }

    return self;
}

- (void)draw
{
    for (GridBox *box in self)
        [box draw];
}

- (bool)detectInteraction:(Camera3D)camera
{
    bool hadInteraction = false;
    for (GridBox *box in self) {
        if ([box detectInteraction: camera])
            hadInteraction = true;
    }

    return hadInteraction;
}

- (int)countByEnumeratingWithState:(nonnull OFFastEnumerationState *)state objects:(__unsafe_unretained id  _Nonnull * _Nonnull)objects count:(int)count
{
    static int i = 0;
    if (i >= 27)
        return 0;

    *objects = (*_boxes)[i / 9][(i / 3) % 3][i % 3];
    i++;
    return 1;
}

@end
