#import <UIKit/UIKit.h>

#define LS(str) NSLocalizedString(str, nil)

@interface UIView (IBInspectableAdd)

@property (nonatomic, strong) IBInspectable NSString * LSKey;

@end
