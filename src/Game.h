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

#import "common.h"

$nonnil_begin

@protocol Renderable
- (void)draw;
@end

@protocol Interactable
- (nillable Any)detectInteraction: (Camera3D)camera;
@end

@protocol Updatable
- (void)update;
@end

@protocol GameDelegate<OFObject, Updatable, Renderable>

@property(readonly) OFString *title;
@property Vector2 screenSize;
@property size_t targetFPS;

@optional

- (void)finish;

@end

@interface Application : OFObject<OFApplicationDelegate>
@property(readonly) id<GameDelegate> game;

- (instancetype)initWithGame: (id<GameDelegate>)game;

@end

#if defined(OF_WINDOWS)
#   define $game(T)\
    int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)\
    {\
        extern int __argc;\
        extern char *nonnil *nonnil __argv;\
        return OFApplicationMain(&__argc, &__argv, [[Application alloc] initWithGame: [[T alloc] init]]);\
    }
#else
#   define $game(T)\
    int main(int argc, char *nonnil argv[nonnil static argc])\
    {\
        return OFApplicationMain(&argc, &argv, [[Application alloc] initWithGame: [[T alloc] init]]);\
    }
#endif


$nonnil_end
