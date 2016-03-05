#import "AMMusicViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "InTheSun-Swift.h"

static NSString * kSongCellIdentifier = @"songCell";

@interface AMMusicViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) IBOutlet UITableView *contentTableView;
@property (nonatomic, strong) MPMusicPlayerController *playerController;

@property (nonatomic, strong) AVPlayer * player;

@end

@implementation AMMusicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.items = [self createItems];
    [self.contentTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSongCellIdentifier];
    self.playerController = [MPMusicPlayerController new];
}

- (NSArray *)createItems
{
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
    NSArray *songs = [songsQuery items];
    return songs;
}

- (void)playItem:(MPMediaItem *)item
{
    NSString* urlString = [@"https://api.soundcloud.com/tracks/169494324/stream?client_id=8867dd81941c97cd17a7b2553b76a3b1" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:urlString];
        
    AVPlayerItem * playerItem = [AVPlayerItem playerItemWithURL:url];
    self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    [self.player play];

}


#pragma mark - IBActions

- (IBAction)play
{
    if (self.playerController.nowPlayingItem == nil) {
        if (self.items.count > 0) {
            MPMediaItem * item = self.items[0];
            [self playItem:item];
        }
    } else {
        [self.playerController play];
    }
}

- (IBAction)pause
{
    [self.playerController pause];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kSongCellIdentifier];
    MPMediaItem *rowItem = [self.items objectAtIndex:indexPath.row];
    cell.textLabel.text = rowItem.title;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPMediaItem *rowItem = self.items[indexPath.row];
    [self playItem:rowItem];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end