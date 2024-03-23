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

#import "common.h"

#import "Game.h"

$nonnil_begin

@interface Player : OFObject<GameObject> {
    @public Camera3D camera;
}

@property(readonly) char ticker;
@property(readonly) Color colour;

- (instancetype)initWithTicker: (char)ticker colour: (Color)colour;
- (void)onSwitch;

@end

$nonnil_end
