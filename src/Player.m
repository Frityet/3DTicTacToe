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

$nonnil_begin

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

- (void)onWin
{
    self->_wins++;
}

- (void)draw
{
    DrawCubeV(self.position, (Vector3) { 2, 2, 2 }, _colour);
}

- (OFString *)description
{
    return [OFString stringWithFormat: @"Player %c at (%.2f, %.2f, %.2f) colour: (#%02X%02X%02X%02X) wins: %u",
                                        _ticker, self.position.x, self.position.y, self.position.z,
                                        (int)_colour.r, (int)_colour.g, (int)_colour.b, (int)_colour.a,
                                        _wins];
}

@end

$nonnil_end
