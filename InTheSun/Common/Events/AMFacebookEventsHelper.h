#import <Foundation/Foundation.h>

@class AMEvent;

@interface AMFacebookEventsHelper : NSObject

+ (NSDictionary *)eventsListParams;
+ (NSDictionary *)photoLoadingParams;
+ (NSArray *)parseRawEvents:(NSArray *)eventsRawArray;

@end
