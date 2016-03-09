#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "AMBlockingScreenVC.h"
#import "AMTabMenuVC.h"
#import "InTheSun-Swift.h"

static NSString * kLaunchCountKey = @"launchCountKey";

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [SoundCloudFacade registerUser];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];    
    self.window.rootViewController = [[AMTabMenuVC alloc] initWithNibName:@"AMTabMenuVC" bundle:nil];
    [self.window makeKeyAndVisible];
    
    [self showBlockingScreenIfNeeded];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSDKAppEvents activateApp];
}

#pragma mark - Private

- (void)showBlockingScreenIfNeeded
{
    NSInteger launchCount = [[NSUserDefaults standardUserDefaults] integerForKey:kLaunchCountKey];
    if (launchCount == 0) {
        [self showBlockingScreenAnimated:NO];
    }
    launchCount ++;
    [[NSUserDefaults standardUserDefaults] setInteger:launchCount forKey:kLaunchCountKey];
}

#pragma mark - Public

- (void)showBlockingScreenAnimated:(BOOL)animated
{
    AMBlockingScreenVC *blockingScreen = [[AMBlockingScreenVC alloc] initWithNibName:@"AMBlockingScreenVC" bundle:nil];
    [self.window.rootViewController presentViewController:blockingScreen animated:animated completion:nil];
}

- (void)hideBlockingScreenAnimated:(BOOL)animated
{
    [self.window.rootViewController dismissViewControllerAnimated:animated completion:nil];
}

@end
