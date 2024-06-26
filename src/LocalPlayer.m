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
// along with 3DTicTacToe.  If not, see <https://www.gnu.org/licenses/>.

#include "LocalPlayer.h"

$nonnil_begin

@implementation LocalPlayer {
    bool firstSwitch;
}

- (instancetype)initWithTicker: (char)ticker colour: (Color)colour
{
    self = [super initWithTicker: ticker colour: colour];

    _camera = (Camera3D) {
        .position = { 7.5, 7.5, 7.5 },
        .up = { 0, 1, 0 },
        .fovy = 45,
        .projection = CAMERA_PERSPECTIVE
    };

    firstSwitch = true;

    return self;
}

- (void)onSwitchIn
{
    [super onSwitchIn];
    if (firstSwitch)
        firstSwitch = false;
}

//internal raylibs function we are just gonna use cause im lazy
RLAPI void CameraYaw(Camera *camera, float angle, bool rotateAroundTarget);
RLAPI void CameraPitch(Camera *camera, float angle, bool lockView, bool rotateAroundTarget, bool rotateUp);
RLAPI void CameraRoll(Camera *camera, float direction);

constexpr auto CAMERA_ROTATION_SPEED = 0.03f;

- (void)update
{
    if (IsKeyDown(KEY_DOWN) || IsKeyDown(KEY_S))
        CameraPitch(&_camera, -CAMERA_ROTATION_SPEED, true /*view must be locked*/, true /*rotating around the target*/, false);
    if (IsKeyDown(KEY_UP) || IsKeyDown(KEY_W))
        CameraPitch(&_camera, CAMERA_ROTATION_SPEED, true, true, false);
    if (IsKeyDown(KEY_RIGHT) || IsKeyDown(KEY_D))
        CameraYaw(&_camera, CAMERA_ROTATION_SPEED, true);
    if (IsKeyDown(KEY_LEFT) || IsKeyDown(KEY_A))
        CameraYaw(&_camera, -CAMERA_ROTATION_SPEED, true);

    //zoom in and out with keys Q and E
    if (IsKeyDown(KEY_Q))
        CameraRoll(&_camera, CAMERA_ROTATION_SPEED);
    if (IsKeyDown(KEY_E))
        CameraRoll(&_camera, -CAMERA_ROTATION_SPEED);

    self->_position = _camera.position;
}

- (const Camera3D *)camera
{ return &_camera; }

- (void)draw {
    if (not firstSwitch)
        [super draw];
}

@end

$nonnil_end
