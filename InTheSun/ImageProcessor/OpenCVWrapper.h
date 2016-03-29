#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OpenCVWrapper : NSObject

+ (BOOL)imageHasCircle:(UIImage *)image;
+ (CGPoint)circleCenterAtImage:(UIImage *)image;

@end
