#import <UIKit/UIKit.h>

@protocol AMMusicFooterViewDelegate <NSObject>
- (void)share;
@end

@interface AMMusicFooterView : UIView

@property (nonatomic, weak) id <AMMusicFooterViewDelegate> delegate;

@end
