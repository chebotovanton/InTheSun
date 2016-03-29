#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AMImageProcessor : NSObject

+ (BOOL)doesImageFitConditions:(UIImage *)image;
+ (CGPoint)circleCenter:(UIImage *)image;

@end
