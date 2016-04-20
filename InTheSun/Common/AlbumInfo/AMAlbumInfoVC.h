#import <UIKit/UIKit.h>
#import "AMPlayerStatusProtocol.h"

@interface AMAlbumInfoVC : UIViewController

@property (nonatomic, weak) id <AMPlayerStatusProtocol> delegate;

@end
