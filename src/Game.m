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

#include "Game.h"

$nonnil_begin

@implementation Application

- (instancetype)initWithGame: (id<GameDelegate>)game
{
    self = [super init];

    self->_game = game;

    return self;
}

- (void)applicationDidFinishLaunching:_
{
    OFLog(@"Starting game %@ (%@)", self.game.title, self.game.title);
    InitWindow(self.game.screenSize.width, self.game.screenSize.height, self.game.title.UTF8String);
    SetTargetFPS(self.game.targetFPS);

    [OFTimer scheduledTimerWithTimeInterval: 0 target: self.game selector: @selector(start) repeats: false];
    [OFTimer scheduledTimerWithTimeInterval: 0 repeats: true block: ^(OFTimer *) {
        [self.game update];

        BeginDrawing();
        [self.game draw];
        EndDrawing();

        if (WindowShouldClose()) {
            CloseWindow();
            [OFApplication terminate];
        }

        if (IsKeyPressed(KEY_F12)) {
            TakeScreenshot("screenshot.png");
        }

        if (IsKeyPressed(KEY_F11)) {
            ToggleFullscreen();
        }
    }];
}

@end

$nonnil_end
