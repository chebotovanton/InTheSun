#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AMImageProcessor : NSObject

+ (BOOL)doesImageFitConditions:(UIImage *)image;
+ (CGPoint)circleCenter:(UIImage *)image;


+ (CGFloat)getAverageLuminanceFromImage:(UIImage *)image step:(NSInteger)step;
@end
