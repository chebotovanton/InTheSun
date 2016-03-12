#import <Foundation/Foundation.h>

@interface AMEvent : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *placeName;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSDate *startDate;

@end
