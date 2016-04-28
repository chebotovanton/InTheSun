#import "EventsVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "AMEventCell.h"
#import "AMEvent.h"
#import "AMFacebookEventsHelper.h"
#import "AMEventsHeader.h"

@interface AMEventSection : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray <AMEvent *> *events;
@property (nonatomic, assign) BOOL shouldShowHeader;
@end

@implementation AMEventSection
@end

@interface EventsVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *loadingView;
@property (nonatomic, weak) IBOutlet UIView *errorView;

@property (nonatomic, strong) NSString *cellReuseIdentifier;
@property (nonatomic, strong) NSArray <AMEventSection *> *sections;

@end

@implementation EventsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.loadingView.layer.cornerRadius = 10.0;
    self.errorView.layer.cornerRadius = 10.0;
    
    UIView *footer = [UIView new];
    footer.frame = CGRectMake(0.0, 0.0, 10.0, 50.0);
    self.tableView.tableFooterView = footer;
    
    self.cellReuseIdentifier = @"AMEventCell";
    [self.tableView registerNib:[UINib nibWithNibName:self.cellReuseIdentifier bundle:nil] forCellReuseIdentifier:self.cellReuseIdentifier];
    
    [self loadData];
}

- (NSArray *)splitEvents:(NSArray <AMEvent *> *)events
{
    NSMutableArray *pastEvents = [NSMutableArray new];
    NSMutableArray *futureEvents = [NSMutableArray new];
    
    for (AMEvent *event in events) {
        if ([self isDateInFuture:event.startDate]) {
            [futureEvents addObject:event];
        } else {
            [pastEvents addObject:event];
        }
    }
    
    NSMutableArray *result = [NSMutableArray new];
    if (futureEvents.count > 0) {
        AMEventSection *section = [AMEventSection new];
        section.name = LS(@"LOC_EVENTS_FUTURE_EVENTS");
        section.events = [self sortEventsByDate:futureEvents];
        section.shouldShowHeader = NO;
        [result addObject:section];
    }
    
    if (pastEvents.count > 0) {
        AMEventSection *section = [AMEventSection new];
        section.name = LS(@"LOC_EVENTS_PAST_EVENTS");
        section.events = pastEvents;
        section.shouldShowHeader = YES;
        [result addObject:section];
    }
    
    return result;
}

- (void)loadData
{
    self.tableView.hidden = YES;
    self.errorView.hidden = YES;
    self.loadingView.hidden = NO;
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/auktyon/events"
                                  parameters:[AMFacebookEventsHelper eventsListParams]
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        NSArray *eventsRawArray = result[@"data"];
        NSArray *events = [AMFacebookEventsHelper parseRawEvents:eventsRawArray];
        self.sections = [self splitEvents:events];
        if (self.sections.count > 0) {
            self.loadingView.hidden = YES;
            self.errorView.hidden = YES;
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        } else {
            self.loadingView.hidden = YES;
            self.errorView.hidden = NO;
            self.tableView.hidden = YES;
        }
    }];
}

#pragma mark - Private

- (NSArray <AMEvent *> *)sortEventsByDate:(NSArray <AMEvent *> *)events
{
    return [events sortedArrayUsingComparator:^NSComparisonResult(AMEvent * _Nonnull event1, AMEvent * _Nonnull event2) {
        return [event1.startDate compare:event2.startDate];
    }];
}


- (BOOL)isDateInFuture:(NSDate *)date
{
    return [date timeIntervalSinceNow] > 0;
}

#pragma mark - Actions

- (IBAction)retryLoading
{
    [self loadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AMEventSection *eventsSection = self.sections[section];
    return eventsSection.events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMEventSection *eventsSection = self.sections[indexPath.section];
    AMEvent *event = eventsSection.events[indexPath.row];
    AMEventCell *cell = (AMEventCell *)[tableView dequeueReusableCellWithIdentifier:self.cellReuseIdentifier];
    [cell setupWithEvent:event];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    AMEventSection *eventsSection = self.sections[section];
    if (eventsSection.shouldShowHeader) {
        AMEventsHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"AMEventsHeader" owner:nil options:nil] objectAtIndex:0];
        header.titleLabel.text = eventsSection.name.uppercaseString;
        return header;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return is_iPad() ? 350.0 : 200.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    AMEventSection *eventsSection = self.sections[section];
    return eventsSection.shouldShowHeader ? 36.0 : 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMEventSection *eventsSection = self.sections[indexPath.section];
    AMEvent *event = eventsSection.events[indexPath.row];
    NSString * urlString = [AMFacebookEventsHelper urlStringForEvent:event];
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
