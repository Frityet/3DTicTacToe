#import "Game.h"
#include <raylib.h>

#import "Grid.h"
#import "LocalPlayer.h"

$nonnil_begin

@implementation Game {
    Grid *nonnil grid;
    GridBox *nillable hoveringOver;
    OFMutableArray<Player *> *nonnil players;
    __weak Player *nonnil currentPlayer;
    const Camera3D *nonnil cameraRef;
}

- (instancetype)init
{
    self = [super init];

    self->_title = @"3D Tic Tac Toe";
    self->_screenSize = (OFPoint) { 1680, 1050 };
    self->_targetFPS = 60;

    grid = [[Grid alloc] initAt: (Vector3) { -1, -1, -1 } width: 3 height: 3 depth: 3];

    players = [@[
        [[LocalPlayer alloc] initWithTicker: 'X' colour: RED],
        [[LocalPlayer alloc] initWithTicker: 'O' colour: BLUE]
    ] mutableCopy];

    currentPlayer = players[0];
    cameraRef = ((LocalPlayer *)currentPlayer).camera;

    return self;
}

- (void)start
{
    DisableCursor();
}


- (void)draw
{
    ClearBackground(RAYWHITE);

    BeginMode3D(*cameraRef);
    {
        [grid draw];
        for (Player *player in players)
            [player draw];

        if (hoveringOver)
            [hoveringOver drawSelectedOutline];
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
    DrawText(currentPlayer.description.UTF8String, 10, 50, 20, DARKGRAY);
    DrawText([OFString stringWithFormat: @"Touching something: %@", hoveringOver ?: @"nil"].UTF8String,
        10, 70,
        20, DARKGRAY);
}

- (void)update
{
    [currentPlayer update];
    hoveringOver = [grid detectInteraction: *cameraRef];
    if (hoveringOver) {
        if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON) and !hoveringOver.occupier) {
            hoveringOver.occupier = currentPlayer;

            Player *nillable winner = [grid checkWin];
            if (winner) {
                [winner onWin];

                [OFStdOut writeFormat: @"Player %c wins!\n", winner.ticker];
                for (OFArray<OFArray<GridBox *> *> *row in grid.boxes) {
                    for (OFArray<GridBox *> *col in row) {
                        for (GridBox *box in col) {
                            box.occupier = nil;
                        }
                    }
                }

                currentPlayer = players[0];
                return;
            }

            [self switchPlayer];
        }
    }

    if (IsKeyPressed('R')) {
        for (Player *player in players) {
            if ([player isKindOfClass: LocalPlayer.class]) {
                players[[players indexOfObject: player]] = [player initWithTicker: player.ticker colour: player.colour];
            }
        }
    }
}

- (void)switchPlayer
{
    [currentPlayer onSwitchOut];
    currentPlayer = players[([players indexOfObject: currentPlayer] + 1) % players.count];
    [currentPlayer onSwitchIn];
    if ([currentPlayer isKindOfClass: LocalPlayer.class]) {
        cameraRef = ((LocalPlayer *)currentPlayer).camera;
    }
}

@end

$nonnil_end
