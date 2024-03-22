#import "Game.h"
#include <raylib.h>

#import "Grid.h"

$nonnil_begin

@implementation Game {
    Camera3D camera;
    Grid *grid;
    bool touchedSomething;
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

    grid = [[Grid alloc] initAt: (Vector3){ -1, -1, -1 } boxColours: &(Color[3][3][3]){
        [0 ... 2] = {
            { RED, GREEN, BLUE },
            { YELLOW, ORANGE, PINK },
            { VIOLET, MAGENTA, SKYBLUE }
        },
    }];

    DisableCursor();
}

- (void)draw
{
    UpdateCamera(&camera, CAMERA_THIRD_PERSON);

    ClearBackground(RAYWHITE);
    DrawText(Game.title.UTF8String, 10, 10, 20, DARKGRAY);
    DrawFPS(10, 30);
    DrawText([OFString stringWithFormat: @"Player info: (position: (%.2f, %.2f, %.2f))", camera.position.x, camera.position.y, camera.position.z].UTF8String, 10, 50, 20, DARKGRAY);
    DrawText([OFString stringWithFormat: @"Touching something: %@", touchedSomething ? @"yes" : @"no"].UTF8String, 10, 70, 20, DARKGRAY);

    BeginMode3D(camera);
    {
        [grid draw];
    }
    EndMode3D();

    auto mpos = GetMousePosition();
        //restrict the mouse to the window
    if (IsWindowFocused()) {
        DisableCursor();
        if (mpos.x < 0)
            mpos.x = 0;
        if (mpos.y < 0)
            mpos.y = 0;
        if (mpos.x > GetScreenWidth())
            mpos.x = GetScreenWidth();
        if (mpos.y > GetScreenHeight())
            mpos.y = GetScreenHeight();

        SetMousePosition(mpos.x, mpos.y);
        DrawCircle(mpos.x, mpos.y, 10, BLACK);
    } else EnableCursor();
}

- (void)update
{
    for (GridBox *box in grid.asArray) {
        if ([box detectInteraction: camera]) {
            touchedSomething = true;
            if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON)) {
                [box hide];
            } else if (IsMouseButtonPressed(MOUSE_RIGHT_BUTTON)) {
                box.colour = (Color) { GetRandomValue(0, 255), GetRandomValue(0, 255), GetRandomValue(0, 255), 255 };
            }
            break;
        } else touchedSomething = false;
    }
}

@end

$nonnil_end
