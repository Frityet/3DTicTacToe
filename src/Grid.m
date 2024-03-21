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

- (bool)wasInteractedWith: (Camera3D)camera
{
    if (!IsMouseButtonPressed(MOUSE_LEFT_BUTTON)) return false;
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


- (instancetype)initAt: (Vector3)position rows: (int)r columns: (int)c depth: (int)d colour: (Color)colour
{
    self = [super init];

    _position = position;

    OFMutableArray<OFArray<OFArray<GridBox *> *> *> *boxes = [OFMutableArray array];
    for (int i = 0; i < r; i++) {
        OFMutableArray<OFArray<GridBox *> *> *row = [OFMutableArray array];
        for (int j = 0; j < c; j++) {
            OFMutableArray<GridBox *> *column = [OFMutableArray array];
            for (int k = 0; k < d; k++) {
                GridBox *box = [[GridBox alloc] initAt: (Vector3){position.x + i, position.y + j, position.z + k} colour: colour];
                [column addObject: box];
            }
            [column makeImmutable];
            [row addObject: column];
        }
        [row makeImmutable];
        [boxes addObject: row];
    }
    [boxes makeImmutable];
    _boxes = boxes;

    return self;
}

- (OFArray<OFArray<GridBox *> *> *)objectAtIndexedSubscript: (size_t)index
{
    return _boxes[index];
}

//should iterate over every box in the grid
- (int)countByEnumeratingWithState:(OFFastEnumerationState *)state objects: (__unsafe_unretained id nonnil *)objects count:(int)count
{

}

- (void)draw
{
    for (OFArray<OFArray<GridBox *> *> *row in _boxes)
    for (OFArray<GridBox *> *column in row)
    for (GridBox *box in column)
        [box draw];



}

@end
