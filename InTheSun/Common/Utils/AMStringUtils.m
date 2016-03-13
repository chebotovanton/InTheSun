#import "AMStringUtils.h"

@implementation AMStringUtils

+ (NSString *)durationString:(NSTimeInterval)duration;
{
    NSDateComponentsFormatter *formatter = [NSDateComponentsFormatter new];
    duration = duration / 1000.0;
    return [formatter stringFromTimeInterval:duration];
}

@end