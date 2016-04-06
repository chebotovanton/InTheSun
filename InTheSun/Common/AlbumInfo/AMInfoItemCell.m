#import "AMInfoItemCell.h"
#import "AMAlbumInfoItem.h"

@interface AMInfoItemCell()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation AMInfoItemCell

- (void)setupWithItem:(AMAlbumInfoItem *)item
{
    self.titleLabel.text = item.title;
    self.subtitleLabel.text = item.subtitle;
    self.imageView.image = item.image;
}
@end
