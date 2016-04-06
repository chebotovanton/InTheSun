#import "AMAlbumInfoVC.h"
#import "YTPlayerView.h"
#import "AMTabMenuVC.h"
#import "AMInfoItemCell.h"


@interface AMAlbumInfoVC () <YTPlayerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet YTPlayerView *playerView;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSString *kCellIdentifier;

@end

@implementation AMAlbumInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.kCellIdentifier = @"AMInfoItemCell";
    UINib *nib = [UINib nibWithNibName:@"AMInfoItemCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:self.kCellIdentifier];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0.0;
    layout.minimumLineSpacing = 0.0;
    layout.headerReferenceSize = CGSizeZero;
    layout.sectionInset = UIEdgeInsetsZero;
    self.collectionView.collectionViewLayout = layout;
    
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

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.frame.size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.kCellIdentifier forIndexPath:indexPath];
    return cell;
}

@end
