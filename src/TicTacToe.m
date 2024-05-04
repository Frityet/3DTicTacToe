#import "Game.h"
#import "Grid.h"
#import "LocalPlayer.h"

$nonnil_begin

@interface TicTacToe : OFObject<GameDelegate> @end

@implementation TicTacToe {
    OFINIFile *configFile;

    Grid *grid;

    //What the current player (the camera) is hovering  over
    GridBox *nillable hoveringOver;
    OFMutableArray<Player *> *players;
    __weak Player *currentPlayer;

    //Reference to the currentPlayer's camera if it is a LocalPlayer
    const Camera3D *cameraRef;
}

- (OFString *)title
{ return @"3D Tic Tac Toe";  }

- (instancetype)init
{
    self = [super init];

    grid = [[Grid alloc] initAt: (Vector3) { -1, -1, -1 } size: 4];

    players = [@[
        [[LocalPlayer alloc] initWithTicker: 'X' colour: RED],
        [[LocalPlayer alloc] initWithTicker: 'O' colour: BLUE],
        [[LocalPlayer alloc] initWithTicker: 'Y' colour: GREEN],
        [[LocalPlayer alloc] initWithTicker: 'Z' colour: YELLOW]
    ] mutableCopy];

    currentPlayer = players[0];
    cameraRef = ((LocalPlayer *)currentPlayer).camera;

    auto path = [OFIRI fileIRIWithPath: @"3DTicTacToe.Config.ini"];
    if (not [OFFileManager.defaultManager fileExistsAtIRI: path]) {
        auto f = [OFIRIHandler openItemAtIRI: path mode: @"w"];
        [f writeString: @"[Video Settings]\nWidth=1680\nHeight=1050\nMax FPS=60\n"];
        [f close];
    }
    configFile = [OFINIFile fileWithIRI: path];

    return self;
}

- (struct ScreenSize)screenSize
{
    OFINICategory *videoSettings = [configFile categoryForName: @"Video Settings"];
    return (struct ScreenSize) {
        .width = [videoSettings longLongValueForKey: @"Width" defaultValue: 1680],
        .height = [videoSettings longLongValueForKey: @"Height" defaultValue: 1050]
    };
}

- (size_t)targetFPS
{
    return [[configFile categoryForName: @"Video Settings"] longLongValueForKey: @"Max FPS" defaultValue: 60];
}

//run once just before the `draw` and `update` will start running
- (void)start
{

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

    DrawText(self.title.UTF8String, 10, 10, 20, DARKGRAY);
    DrawFPS(10, 30);
    //the current player and their wins
    DrawText([OFString stringWithFormat: @"Wins: %u\n", currentPlayer.wins].UTF8String, 10, 50, 32, currentPlayer.colour);
    DrawText((char []){currentPlayer.ticker, 0}, GetScreenWidth() - 128, 10, 128, currentPlayer.colour);

    //Leaderboard
    DrawRectangle(GetScreenWidth() - 128 - 8, 128 - 8, 96, 48 * players.count, Fade(BLACK, 0.5f));
    for (Player *player in players) {
        DrawText([OFString stringWithFormat: @"%c: %u\n", player.ticker, player.wins].UTF8String, GetScreenWidth() - 128, 128 + 50 * [players indexOfObject: player], 32, player.colour);
    }
}

- (void)update
{
    [currentPlayer update];

    //checks what cube the cursor is hovering over
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

        grid = [grid initAt: grid.position size: grid.size];
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

$game(TicTacToe);

$nonnil_end
