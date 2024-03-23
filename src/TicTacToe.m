#import "Game.h"
#include <raylib.h>

#import "Grid.h"
#import "Player.h"

$nonnil_begin

@implementation Game {
    Camera3D camera;
    Grid *grid;
    GridBox *hoveringOver;
    OFMutableArray<Player *> *players;
}

+ (OFString *)title
{ return @"3D Tic Tac Toe"; }

+ (OFPoint)screenSize
{ return (OFPoint) { 1680, 1050 }; }

+ (int)targetFPS
{ return 60; }

- (void)start
{
    [OFStdOut writeLine: @"Starting game..."];

    camera = (Camera3D) {
        .position = { 7.5, 7.5, 7.5 },
        .up = { 0, 1, 0 },
        .fovy = 45,
        .projection = CAMERA_PERSPECTIVE
    };

    grid = [[Grid alloc] initAt: (Vector3){ -1, -1, -1 } width: 3 height: 3 depth: 3];

    players = [@[
        [[Player alloc] initWithTicker: 'X' colour: RED],
        [[Player alloc] initWithTicker: 'O' colour: BLUE]
    ] mutableCopy];

    DisableCursor();
}


//internal raylibs function we are just gonna use cause im lazy
RLAPI void CameraYaw(Camera *camera, float angle, bool rotateAroundTarget);
RLAPI void CameraPitch(Camera *camera, float angle, bool lockView, bool rotateAroundTarget, bool rotateUp);

constexpr float CAMERA_ROTATION_SPEED = 0.03;

//3rd person movement just orbiting around (0, 0, 0)
- (void)updateCamera
{
    if (IsKeyDown(KEY_DOWN) || IsKeyDown(KEY_S))
        CameraPitch(&camera, -CAMERA_ROTATION_SPEED, true /*view must be locked*/, true /*rotating around the target*/, false);
    if (IsKeyDown(KEY_UP) || IsKeyDown(KEY_W))
        CameraPitch(&camera, CAMERA_ROTATION_SPEED, true, true, false);
    if (IsKeyDown(KEY_RIGHT) || IsKeyDown(KEY_D))
        CameraYaw(&camera, CAMERA_ROTATION_SPEED, true);
    if (IsKeyDown(KEY_LEFT) || IsKeyDown(KEY_A))
        CameraYaw(&camera, -CAMERA_ROTATION_SPEED, true);
}

- (void)draw
{
    ClearBackground(RAYWHITE);

    BeginMode3D(camera);
    {
        [grid draw];
    }
    EndMode3D();

    Vector2 mpos = GetMousePosition();
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

    DrawText(Game.title.UTF8String, 10, 10, 20, DARKGRAY);
    DrawFPS(10, 30);
    DrawText([OFString stringWithFormat: @"Player info: (position: (%.2f, %.2f, %.2f))", camera.position.x, camera.position.y, camera.position.z].UTF8String, 10, 50, 20, DARKGRAY);
    DrawText([OFString stringWithFormat: @"Touching something: %@", hoveringOver ?: @"nil"].UTF8String, 10, 70, 20, DARKGRAY);
}

- (void)update
{
    [self updateCamera];
    hoveringOver = [grid detectInteraction: camera];
    if (hoveringOver) {
        if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON)) {
            [hoveringOver hide];
        } else if (IsMouseButtonPressed(MOUSE_RIGHT_BUTTON)) {
            hoveringOver.colour = (Color) { GetRandomValue(0, 255), GetRandomValue(0, 255), GetRandomValue(0, 255), 255 };
        }
    }
}

@end

$nonnil_end
