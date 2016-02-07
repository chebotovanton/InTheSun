//
//  AMImageProcessor.h
//  InTheSun
//
//  Created by Anton Chebotov on 07/02/16.
//  Copyright © 2016 Anton Chebotov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AMImageProcessor : NSObject

+ (BOOL)doesImageFitConditions:(UIImage *)image;

@end
