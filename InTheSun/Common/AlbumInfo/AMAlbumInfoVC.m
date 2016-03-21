#import "AMAlbumInfoVC.h"
#import "YTPlayerView.h"
#import "AMTabMenuVC.h"

@interface AMAlbumInfoVC () <YTPlayerViewDelegate>

@property(nonatomic, strong) IBOutlet YTPlayerView *playerView;

@end

@implementation AMAlbumInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.playerView.delegate = self;
    [self.playerView loadWithVideoId:@"Wsjka9Ran7A"];
}

- (void)stopMusicPlayer
{
    [(AMTabMenuVC *)self.tabBarController stopMusicPlayer];
}

#pragma mark - YTPlayerViewDelegate

- (void)playerView:(nonnull YTPlayerView *)playerView didChangeToState:(YTPlayerState)state
{
    switch (state) {
        case kYTPlayerStatePlaying:
        case kYTPlayerStateBuffering:
            [self stopMusicPlayer];
            break;
        default:
            break;
    }
}

@end
