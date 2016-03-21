#import "SecondViewController.h"
#import "AppDelegate.h"

@implementation SecondViewController

- (IBAction)showBlockingScreen
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate showBlockingScreenAnimated:YES];
}
@end
