#import "Game.h"
#include <raylib.h>

#import "Grid.h"

$nonnil_begin

@implementation Game {
    Camera3D camera;
    Grid *grid;
}

+ (OFString *)title
{ return @"3D Tic Tac Toe"; }

+ (OFPoint)screenSize
{ return (OFPoint) { 800, 600 }; }

+ (int)targetFPS
{ return 60; }

- (void)start
{
    [OFStdOut writeLine: @"Starting game..."];

    camera = (Camera3D) {
        .position = { 5, 5, 5 },
        .up = { 0, 1, 0 },
        .fovy = 45,
        .projection = CAMERA_PERSPECTIVE
    };

    grid = [[Grid alloc] initAt: (Vector3){ -1, -1, -1 } boxColours: (Color[3][3][3]){
        {
            { RED, GREEN, BLUE },
            { YELLOW, ORANGE, PINK },
            { VIOLET, MAGENTA, SKYBLUE }
        },
        {
            { RED, GREEN, BLUE },
            { YELLOW, ORANGE, PINK },
            { VIOLET, MAGENTA, SKYBLUE }
        },
        {
            { RED, GREEN, BLUE },
            { YELLOW, ORANGE, PINK },
            { VIOLET, MAGENTA, SKYBLUE }
        }
    }];

}

- (void)draw
{
    ClearBackground(RAYWHITE);
    DrawText(Game.title.UTF8String, 10, 10, 20, DARKGRAY);
    DrawFPS(10, 30);

    UpdateCamera(&camera, CAMERA_ORBITAL);

    BeginMode3D(camera);
    {
        [grid draw];
    }
    EndMode3D();
}

- (void)update
{
    if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON)) {
        
    }
}

@end

$nonnil_end
