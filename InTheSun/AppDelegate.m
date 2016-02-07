//
//  AppDelegate.m
//  InTheSun
//
//  Created by Anton Chebotov on 06/02/16.
//  Copyright © 2016 Anton Chebotov. All rights reserved.
//

#import "AppDelegate.h"
#import "AMBlockingScreenVC.h"

static NSString * kLaunchCountKey = @"launchCountKey";

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self.window makeKeyAndVisible];
    [self showBlockingScreenIfNeeded];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
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
