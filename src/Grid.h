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
#import "Player.h"

@interface GridBox : OFObject<Renderable>

@property Vector3 position, size;
@property Color colour;
@property(weak, nullable) Player *occupier;

- (instancetype)initAt: (Vector3)position size: (Vector3)size colour: (Color)colour;
- (void)hide;

- (void)drawSelectedOutline;

@end

@interface Grid : OFObject<Renderable, Interactable>

@property Vector3 position;
@property OFArray<OFArray<OFArray<GridBox *> *> *> *boxes;

- (instancetype)initAt: (Vector3)position width: (int)width height: (int)height depth: (int)depth;

@end

