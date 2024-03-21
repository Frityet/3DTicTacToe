#import "Game.h"
#include <raylib.h>

#import "Grid.h"

$nonnil_begin

@implementation Game {
    Camera3D camera;
    Grid *grid;
    CameraMode cameraMode;
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
        .position = { 10, 10, 10 },
        .up = { 0, 1, 0 },
        .fovy = 45,
        .projection = CAMERA_PERSPECTIVE
    };
    cameraMode = CAMERA_FREE;

    grid = [[Grid alloc] initAt: (Vector3){ -1, -1, -1 }
                           rows: 3 columns: 3 depth: 3
                         colour: RED];

    DisableCursor();
}

- (void)draw
{
    ClearBackground(RAYWHITE);
    DrawText(Game.title.UTF8String, 10, 10, 20, DARKGRAY);
    DrawFPS(10, 50);

    //switch the camera mode
    if (IsKeyPressed('N')) {
        cameraMode += 1;
        if (cameraMode > CAMERA_THIRD_PERSON) cameraMode = CAMERA_CUSTOM;
    }

    DrawText([OFString stringWithFormat: @"Camera mode %d: %s", cameraMode, (const char *[]){
        "Custom",
        "Free",
        "Orbital",
        "First person",
        "Third person"
    }[cameraMode]].UTF8String, 10, 70, 20, DARKGRAY);;

    UpdateCamera(&camera, cameraMode);

    BeginMode3D(camera);
    {
        for (GridBox *box in grid) {
            [box draw];
        }
    }
    EndMode3D();
}

@end

$nonnil_end
