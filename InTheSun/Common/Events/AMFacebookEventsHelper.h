#import <Foundation/Foundation.h>

@class AMEvent;

@interface AMFacebookEventsHelper : NSObject

+ (NSDictionary *)eventsListParams;
+ (NSArray *)parseRawEvents:(NSArray *)eventsRawArray;
+ (NSString *)urlStringForEvent:(AMEvent *)event;

@end
