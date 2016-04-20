#import <UIKit/UIKit.h>
#import "AMPlayerStatusProtocol.h"

@interface AMBlockingScreenVC : UIViewController

@property (nonatomic, weak) id <AMPlayerStatusProtocol> delegate;

- (void)switchToCameraState;

@end
