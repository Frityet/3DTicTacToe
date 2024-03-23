#import "Game.h"
#include <raylib.h>

#import "Grid.h"
#import "Player.h"

$nonnil_begin

@implementation Game {
    Grid *grid;
    GridBox *hoveringOver;
    OFMutableArray<Player *> *players;
    __weak Player *currentPlayer;
}

// + (OFString *)title
// { return @"3D Tic Tac Toe"; }

// + (OFPoint)screenSize
// { return (OFPoint) { 1680, 1050 }; }

// + (int)targetFPS
// { return 60; }
- (instancetype)init
{
    self = [super init];

    self->_title = @"3D Tic Tac Toe";
    self->_screenSize = (OFPoint) { 1680, 1050 };
    self->_targetFPS = 60;

    return self;
}

- (void)start
{
    [OFStdOut writeLine: @"Starting game..."];

    grid = [[Grid alloc] initAt: (Vector3) { -1, -1, -1 } width: 3 height: 3 depth: 3];

    players = [@[
        [[Player alloc] initWithTicker: 'X' colour: RED],
        [[Player alloc] initWithTicker: 'O' colour: BLUE]
    ] mutableCopy];

    currentPlayer = players[0];

    DisableCursor();
}


- (void)draw
{
    ClearBackground(RAYWHITE);

    BeginMode3D(currentPlayer->camera);
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

    DrawText(self.title.UTF8String, 10, 10, 20, DARKGRAY);
    DrawFPS(10, 30);
    DrawText([OFString stringWithFormat: @"Player %d info: (position: (%.2f, %.2f, %.2f))",
                    [players indexOfObject: currentPlayer],
                    currentPlayer->camera.position.x, currentPlayer->camera.position.y, currentPlayer->camera.position.z].UTF8String,
                    10, 50,
                    20, DARKGRAY);
    DrawText([OFString stringWithFormat: @"Touching something: %@", hoveringOver ?: @"nil"].UTF8String,
        10, 70,
        20, DARKGRAY);
}

- (void)update
{
    [currentPlayer update];
    hoveringOver = [grid detectInteraction: currentPlayer->camera];
    if (hoveringOver) {
        if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON)) {
            [hoveringOver hide];
        } else if (IsMouseButtonPressed(MOUSE_RIGHT_BUTTON)) {
            hoveringOver.colour = (Color) { GetRandomValue(0, 255), GetRandomValue(0, 255), GetRandomValue(0, 255), 255 };
        }
    }

    if (IsKeyPressed(KEY_SPACE)) {
        [self switchPlayer];
    }
}

- (void)switchPlayer
{
    currentPlayer = players[([players indexOfObject: currentPlayer] + 1) % players.count];
}

@end

$nonnil_end
