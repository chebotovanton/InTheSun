#import "UIView+IBInspectable.h"
#import <objc/runtime.h>

@implementation UIView (IBInspectableAdd)

@dynamic LSKey;

- (void)setLSKey:(NSString *)LSKey
{
    NSString *localizedString = LS(LSKey);
    if ([self isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)self;
        [label setText:localizedString];
    } else if ([self isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)self;
        [button setTitle:localizedString forState:UIControlStateNormal];
    }
}

@end
