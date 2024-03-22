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

#import "Game.h"

@interface GridBox : OFObject<Renderable, Interactable>

@property Vector3 position;
@property Color colour;

- (instancetype)initAt: (Vector3)position colour: (Color)colour;

@end

@interface Grid : OFObject<Renderable, Interactable>

@property Vector3 position;
@property __strong GridBox *(*boxes)[3][3][3];

@property(readonly, getter=boxesToArray) OFArray<GridBox *> *asArray;

- (instancetype)initAt: (Vector3)position boxColours: (Color(*)[3][3][3])colour;

@end
