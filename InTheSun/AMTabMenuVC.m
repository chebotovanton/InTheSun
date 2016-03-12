#import "AMTabMenuVC.h"
#import "InTheSun-Swift.h"
#import "SecondViewController.h"
#import "AMAlbumInfoVC.h"
#import "EventsVC.h"

@implementation AMTabMenuVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBar.tintColor = [UIColor yellowColor];
    self.tabBar.backgroundColor = [UIColor colorWithRed:44.0/255.0 green:44.0/255.0 blue:44.0/255.0 alpha:1.0];
    self.tabBar.barStyle = UIBarStyleBlack;

    NSArray *vcs = [self createControllers];
    [self setViewControllers:vcs animated:YES];
}

- (NSArray *)createControllers
{
    AMMusicViewController *musicVC = [[AMMusicViewController alloc] initWithNibName:@"AMMusicViewController" bundle:nil];
    UITabBarItem * musicBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"musicMenuIcon"] tag:0];
    musicBarItem.title = @"Music";
    musicVC.tabBarItem = musicBarItem;

    AMAlbumInfoVC *albumInfoVC = [[AMAlbumInfoVC alloc] initWithNibName:@"AMAlbumInfoVC" bundle:nil];
    UITabBarItem * albumBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"albumMenuIcon"] tag:0];
    albumBarItem.title = @"Album Info";
    albumInfoVC.tabBarItem = albumBarItem;
    
    EventsVC *eventsVC = [[EventsVC alloc] initWithNibName:@"EventsVC" bundle:nil];
    UITabBarItem * eventsBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"eventsMenuIcon"] tag:0];
    eventsBarItem.title = @"Events";
    eventsVC.tabBarItem = eventsBarItem;

    SecondViewController *secondVC = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
    UITabBarItem * secondBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"friendsMenuIcon"] tag:0];
    secondBarItem.title = @"Second";
    secondVC.tabBarItem = secondBarItem;
    
    return @[musicVC, albumInfoVC, eventsVC, secondVC];
}

@end
