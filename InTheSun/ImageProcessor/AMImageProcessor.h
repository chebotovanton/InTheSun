#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AMImageProcessor : NSObject

+ (CGFloat)getAverageLuminanceFromImage:(UIImage *)image step:(NSInteger)step;

@end
