#import "AMMusicFooterView.h"

@implementation AMMusicFooterView

- (IBAction)share:(UIButton *)sender
{
    [self.delegate share:sender];
}

@end
