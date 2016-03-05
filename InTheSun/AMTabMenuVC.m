#import "AMTabMenuVC.h"

@interface AMMenuItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *vcClassName;
@property (nonatomic, copy) NSString *xibName;
@property (nonatomic, strong) UIImage *icon;

+(id)itemWithTitle:(NSString *)title vcClassName:(NSString *)name xibName:(NSString *)xibName icon:(UIImage *)icon;

@end

@implementation AMMenuItem

+(id)itemWithTitle:(NSString *)title vcClassName:(NSString *)name xibName:(NSString *)xibName icon:(UIImage *)icon
{
    AMMenuItem *item = [AMMenuItem new];
    if (item) {
        item.title = title;
        item.vcClassName = name;
        item.xibName = xibName;
        item.icon = icon;
    }
    return item;
}

@end


@interface AMTabMenuVC ()

@end

@implementation AMTabMenuVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray *menuItems = [self defaultItems];
    
    NSArray *vcs = [self createControllersWithMenuItems:menuItems];
    [self setViewControllers:vcs animated:YES];
}

- (NSArray *)createControllersWithMenuItems:(NSArray *) menuItems
{
    NSMutableArray * viewControllers = [NSMutableArray new];
    for (NSInteger i = 0; i < menuItems.count; i++) {
        AMMenuItem * menuItem = menuItems[i];
        UITabBarItem * barItem = [[UITabBarItem alloc] initWithTitle:nil image:menuItem.icon tag:0];
#warning imageInsets
        barItem.imageInsets = UIEdgeInsetsMake(6.0, 0.0, -6.0, 0.0);
        barItem.tag = i;
        barItem.title = menuItem.title;
        
        UIViewController * viewController = [self loadViewControllerForItem:menuItem];
        viewController.tabBarItem = barItem;
        [viewControllers addObject:viewController];
    }
    self.viewControllers = viewControllers;
    
    return viewControllers;
}

- (NSArray *)defaultItems
{
    NSMutableArray *result = [NSMutableArray new];
    [result addObject:[AMMenuItem itemWithTitle:@"Music"
                                    vcClassName:@"AMMusicViewController"
                                        xibName:@"AMMusicViewController"
                                           icon:[UIImage imageNamed:@"musicMenuIcon"]]];

    [result addObject:[AMMenuItem itemWithTitle:@"Second"
                                    vcClassName:@"SecondViewController"
                                        xibName:@"SecondViewController"
                                           icon:[UIImage imageNamed:@"secondMenuIcon"]]];

    return result;
}

- (UIViewController *)loadViewControllerForItem:(AMMenuItem *)item
{
    Class vcClass = NSClassFromString(item.vcClassName);
    UIViewController *vc = [[vcClass alloc] initWithNibName:item.xibName bundle:nil];
    return vc;
}

@end
