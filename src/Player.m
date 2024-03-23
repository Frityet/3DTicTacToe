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

#include "Player.h"

@implementation Player

- (instancetype)initWithTicker: (char)ticker colour: (Color)colour
{
    self = [super init];

    _ticker = ticker;
    _colour = colour;

    return self;
}

- (void)onSwitchIn
{
    [OFStdOut writeFormat: @"Switched to player %c\n", _ticker];
    _isTurn = true;
}

- (void)onSwitchOut
{
    _isTurn = false;
}

- (void)update
{
    @throw [OFNotImplementedException exceptionWithSelector: @selector(update) object: self];
}

- (void)draw
{
    DrawCubeV(self.position, (Vector3) { 2, 2, 2 }, _colour);
}

@end
