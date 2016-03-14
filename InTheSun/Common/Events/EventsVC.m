#import "EventsVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "AMEventCell.h"
#import "AMEvent.h"
#import "AMFacebookEventsHelper.h"

@interface EventsVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSString *cellReuseIdentifier;

@end

@implementation EventsVC

- (void)viewDidLoad
{
    self.cellReuseIdentifier = @"AMEventCell";
    [self.tableView registerNib:[UINib nibWithNibName:self.cellReuseIdentifier bundle:nil] forCellReuseIdentifier:self.cellReuseIdentifier];
    
    [super viewDidLoad];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/auktyon/events"
                                  parameters:[AMFacebookEventsHelper eventsListParams]
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        
        NSArray *eventsRawArray = result[@"data"];
        self.items = [AMFacebookEventsHelper parseRawEvents:eventsRawArray];
        [self.tableView reloadData];
    }];
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
    AMEventCell *cell = (AMEventCell *)[tableView dequeueReusableCellWithIdentifier:self.cellReuseIdentifier];
    [cell setupWithEvent:event];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130.0;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
