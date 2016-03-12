#import "AMEventCell.h"
#import "AMEvent.h"

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

@end
