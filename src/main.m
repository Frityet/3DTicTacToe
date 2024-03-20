#import <ObjFW/ObjFW.h>

@interface Application : OFObject<OFApplicationDelegate> @end

@implementation Application

- (void)applicationDidFinishLaunching: (OFNotification *)notification
{

    [OFApplication terminate];
}

@end

#if defined(OF_WINDOWS)
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
    extern int __argc;
    extern char **__argv;
    return OFApplicationMain(&__argc, &__argv, [[Application alloc] init]);
}
#else
int main(int argc, char *argv[])
{
    return OFApplicationMain(&argc, &argv, [[Application alloc] init]);
}
#endif
