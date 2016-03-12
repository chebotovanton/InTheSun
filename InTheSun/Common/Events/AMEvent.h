#import <Foundation/Foundation.h>

@interface AMEvent : NSObject

@property (nonatomic, copy) NSString *eventId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *placeName;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSString *imageUrl;

@end
