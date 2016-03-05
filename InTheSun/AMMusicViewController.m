#import "AMMusicViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "InTheSun-Swift.h"

static NSString * kSongCellIdentifier = @"songCell";

@interface AMMusicViewController () <UITableViewDataSource, UITableViewDelegate, SoundCloudDelegate>

@property (nonatomic, weak) IBOutlet UITableView *contentTableView;
@property (nonatomic, weak) IBOutlet UIImageView *albumArtwork;
@property (nonatomic, strong) SoundCloudFacade *soundcloudFacade;
@property (nonatomic, strong) AVPlayer * player;

@end

@implementation AMMusicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.soundcloudFacade = [SoundCloudFacade new];
    self.soundcloudFacade.delegate = self;
    [self.soundcloudFacade loadAlbum:41780534];
    
    [self.contentTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSongCellIdentifier];
}


- (void)playItem:(NSInteger)index
{
    [self.soundcloudFacade play:index];
}


#pragma mark - IBActions

- (IBAction)play
{
    [self playItem:0];
//    if (self.playerController.nowPlayingItem == nil) {
//        if (self.items.count > 0) {
//            MPMediaItem * item = self.items[0];
//            [self playItem:item];
//        }
//    } else {
//        [self.playerController play];
//    }
}

- (IBAction)pause
{
//    [self.playerController pause];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.soundcloudFacade.songsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kSongCellIdentifier];
    cell.textLabel.text = [self.soundcloudFacade songTitle:indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self playItem:indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SoundCloudDelegate Methods

- (void)didLoadAlbum
{
    [self.contentTableView reloadData];
    [self.soundcloudFacade loadAlbumImage];
}
- (void)albumLoadingFailed
{
    [[[UIAlertView alloc] initWithTitle:@"Error"
                               message:@"Could not load album data"
                              delegate:nil
                     cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)didLoadAlbumImage:(UIImage *)image
{
    self.albumArtwork.image = image;
}

@end