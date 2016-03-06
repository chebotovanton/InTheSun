#import "AMTabMenuVC.h"
#import "InTheSun-Swift.h"
#import "SecondViewController.h"

@implementation AMTabMenuVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray *vcs = [self createControllers];
    [self setViewControllers:vcs animated:YES];
}

- (NSArray *)createControllers
{
    AMMusicViewController *musicVC = [[AMMusicViewController alloc] initWithNibName:@"AMMusicViewController" bundle:nil];
    UITabBarItem * musicBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"musicMenuIcon"] tag:0];
    musicBarItem.imageInsets = UIEdgeInsetsMake(6.0, 0.0, -6.0, 0.0);
    musicBarItem.title = @"Music";
    musicVC.tabBarItem = musicBarItem;


    SecondViewController *secondVC = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
    UITabBarItem * secondBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"secondMenuIcon"] tag:0];
    secondBarItem.imageInsets = UIEdgeInsetsMake(6.0, 0.0, -6.0, 0.0);
    secondBarItem.title = @"Second";
    secondVC.tabBarItem = secondBarItem;
    
    return @[musicVC, secondVC];
}

@end
