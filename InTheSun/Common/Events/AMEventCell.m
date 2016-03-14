#import "AMEventCell.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "AMEvent.h"
#import "AMFacebookEventsHelper.h"

@interface AMEventCell()

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *placeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *eventImage;

@property (nonatomic, strong) AMEvent *event;

@end

@implementation AMEventCell

- (void)setupWithEvent:(AMEvent *)event
{
    self.event = event;
    self.nameLabel.text = event.name;
    self.dateLabel.text = [self dayFromDate:event.startDate];
    self.timeLabel.text = [self timeFromDate:event.startDate];
    self.placeLabel.text = event.placeName;
    [self loadEventImage:event];
}

- (NSString *)timeFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateStyle = kCFDateFormatterNoStyle;
    formatter.timeStyle = kCFDateFormatterShortStyle;
    return [formatter stringFromDate:date];
}

- (NSString *)dayFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateStyle = kCFDateFormatterShortStyle;
    formatter.timeStyle = kCFDateFormatterNoStyle;
    return [formatter stringFromDate:date];
}

- (void)loadEventImage:(AMEvent *)event
{
    NSURL *url = [NSURL URLWithString:event.imageUrl];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    self.eventImage.image = image;
}

@end