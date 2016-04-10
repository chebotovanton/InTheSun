#import <UIKit/UIKit.h>

@protocol AMMusicFooterViewDelegate <NSObject>
- (void)share:(UIButton *)sender;
@end

@interface AMMusicFooterView : UIView

@property (nonatomic, weak) id <AMMusicFooterViewDelegate> delegate;

@end
