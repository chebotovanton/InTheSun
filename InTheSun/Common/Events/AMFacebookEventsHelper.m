#import "AMFacebookEventsHelper.h"
#import "AMEvent.h"

@implementation AMFacebookEventsHelper

+ (NSDictionary *)eventsListParams
{
    return @{@"fields" : @"name, place, start_time, type, category, picture.type(large)",
             @"access_token" : [self accessToken]};
}

+ (NSDictionary *)photoLoadingParams
{
    return @{@"access_token" : [self accessToken],
             @"fields" : @"picture.width(320).height(150)"};
}

+ (NSString *)accessToken
{
    return @"1696621093884195|dd2b1b044ab94adfd38f1273f6627e5e";
}

+ (NSArray *)parseRawEvents:(NSArray *)eventsRawArray
{
    NSMutableArray *events = [NSMutableArray new];
    for (NSDictionary * rawEvent in eventsRawArray) {
        AMEvent * event = [AMEvent new];

        event.eventId = rawEvent[@"id"];
        event.name = rawEvent[@"name"];
        NSString *dateString = rawEvent[@"start_time"];
        event.startDate = [self dateFromFacebookString:dateString];
        
        NSDictionary *placeDict = rawEvent[@"place"];
        NSString *placeName = placeDict[@"name"];
        event.placeName = placeName;
        
        NSDictionary *imageDict = rawEvent[@"picture"];
        imageDict = imageDict[@"data"];
        event.imageUrl = imageDict[@"url"];
        
        [events addObject:event];
    }
    return events;
}

+ (NSDate *)dateFromFacebookString:(NSString *)string
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH:mm:ssZ"];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}


@end
