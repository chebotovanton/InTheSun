#import "EventsVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AMEvent: NSObject

@property (nonatomic, strong) NSString *name;

@end

@implementation AMEvent

@end

@interface EventsVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) IBOutlet UITableView * tableView;

@end

@implementation EventsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/auktyon/events?access_token=CAACEdEose0cBAMNVyt1CeSDbT41XNMQSKBdXDHVQHwogZAe5bdK5gr0eo4Hjh0XELWVAIlxXrbbFKzU8BIzsibP3N8SiHNQi4ltKYnFj1ZCAZBZCYCWy2MEp8dZBdZARPOnZAy7pG5wOQsgu5FkYmAqyp1nUjmZAAuwxthkALUhc0RLnJCflOnMZBjkU0S1ZB4QN7ajLLyUIsPJAZDZD"
                                  parameters:nil
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        
        NSArray *eventsRawArray = result[@"data"];
        self.items = [self parseRawEvents:eventsRawArray];
        [self.tableView reloadData];
    }];
}

#pragma mark - Private

- (NSArray *)parseRawEvents:(NSArray *)eventsRawArray
{
    NSMutableArray *events = [NSMutableArray new];
    for (NSDictionary * rawEvent in eventsRawArray) {
        AMEvent * event = [AMEvent new];
        event.name = rawEvent[@"name"];
        [events addObject:event];
    }
    return events;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMEvent *event = self.items[indexPath.row];
    UITableViewCell * cell = [UITableViewCell new];
    cell.textLabel.text = event.name;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
