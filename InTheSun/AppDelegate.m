#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "AMBlockingScreenVC.h"
#import "AMTabMenuVC.h"
#import "InTheSun-Swift.h"

static NSString * kLaunchCountKey = @"launchCountKey";

@interface AppDelegate ()
@property (nonatomic, strong) AMBlockingScreenVC *blockingScreen;
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
    
    [self fadeSplashScreen];
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
    #warning Debug
    launchCount = 0;
    if (launchCount == 0 && ![self isSimulator]) {
        [self showBlockingScreenAnimated:NO];
    }
    launchCount++;
    [[NSUserDefaults standardUserDefaults] setInteger:launchCount forKey:kLaunchCountKey];
}

- (BOOL)isSimulator
{
    NSString *name = [UIDevice currentDevice].name;
    return [name rangeOfString:@"Simulator"].location != NSNotFound;
}

- (void)fadeSplashScreen
{
    NSArray *allPngImageNames = [[NSBundle mainBundle] pathsForResourcesOfType:@"png"
                                                                   inDirectory:nil];
    UIImage *splashImage = nil;
    for (NSString *imgName in allPngImageNames){
        if ([imgName rangeOfString:@"SplashScreen"].location != NSNotFound){
            UIImage *img = [UIImage imageWithContentsOfFile:imgName];
            if (img.scale == [UIScreen mainScreen].scale && CGSizeEqualToSize(img.size, [UIScreen mainScreen].bounds.size)) {
                splashImage = img;
            }
        }
    }
    UIView * splash = [[UIImageView alloc] initWithImage:splashImage];
    [self.window addSubview:splash];
    
    [UIView animateWithDuration:3.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         splash.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [splash removeFromSuperview];
                         [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                         [self.blockingScreen switchToCameraState];
                     }];
    
    
}


#pragma mark - Public

- (void)showBlockingScreenAnimated:(BOOL)animated
{
    self.blockingScreen = [[AMBlockingScreenVC alloc] initWithNibName:@"AMBlockingScreenVC" bundle:nil];
    [self.window.rootViewController presentViewController:self.blockingScreen animated:animated completion:nil];
}

- (void)hideBlockingScreenAnimated:(BOOL)animated
{
    [self.window.rootViewController dismissViewControllerAnimated:animated completion:nil];
    self.blockingScreen = nil;
}

@end
