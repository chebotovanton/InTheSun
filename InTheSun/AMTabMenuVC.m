#import "AMTabMenuVC.h"
#import "InTheSun-Swift.h"
#import "SecondViewController.h"
#import "AMAlbumInfoVC.h"
#import "EventsVC.h"
#import <AVFoundation/AVFoundation.h>

@interface AMTabMenuVC ()
@property (nonatomic, strong) AVPlayer *player;
@end

@implementation AMTabMenuVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBar.tintColor = [UIColor colorWithRed:252.0/255.0 green:213.0/255.0 blue:0.0/255.0 alpha:1.0];
    self.tabBar.backgroundColor = [UIColor colorWithRed:44.0/255.0 green:44.0/255.0 blue:44.0/255.0 alpha:1.0];
    self.tabBar.barStyle = UIBarStyleBlack;

    NSArray *vcs = [self createControllers];
    [self setViewControllers:vcs animated:YES];
}


- (NSArray *)createControllers
{
    AMMusicViewController *musicVC = [[AMMusicViewController alloc] initWithNibName:@"AMMusicViewController" bundle:nil];
    UITabBarItem * musicBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"musicMenuIcon"] tag:0];
    musicBarItem.title = LS(@"LOC_TAB_BAR_MUSIC");
    musicVC.tabBarItem = musicBarItem;

    AMAlbumInfoVC *albumInfoVC = [[AMAlbumInfoVC alloc] initWithNibName:@"AMAlbumInfoVC" bundle:nil];
    UITabBarItem * albumBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"albumMenuIcon"] tag:0];
    albumBarItem.title = LS(@"LOC_TAB_BAR_ALBUM");
    albumInfoVC.tabBarItem = albumBarItem;
    
    EventsVC *eventsVC = [[EventsVC alloc] initWithNibName:@"EventsVC" bundle:nil];
    UITabBarItem * eventsBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"eventsMenuIcon"] tag:0];
    eventsBarItem.title = LS(@"LOC_TAB_BAR_EVENTS");
    eventsVC.tabBarItem = eventsBarItem;

    SecondViewController *secondVC = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
    UITabBarItem * secondBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"friendsMenuIcon"] tag:0];
    secondBarItem.title = @"DevSettings";
    secondVC.tabBarItem = secondBarItem;
    
    return @[musicVC, albumInfoVC, eventsVC, secondVC];
}

- (void)stopMusicPlayer
{
    [(AMMusicViewController *)self.viewControllers[0] stopMusicPlayer];
}

- (void)playInitialSong
{
#warning move to singleton?
    [(AMMusicViewController *)self.viewControllers[0] playInitialSong];
}


@end
