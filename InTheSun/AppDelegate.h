//
//  AppDelegate.h
//  InTheSun
//
//  Created by Anton Chebotov on 06/02/16.
//  Copyright © 2016 Anton Chebotov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)showBlockingScreenAnimated:(BOOL)animated;
- (void)hideBlockingScreenAnimated:(BOOL)animated;

@end

