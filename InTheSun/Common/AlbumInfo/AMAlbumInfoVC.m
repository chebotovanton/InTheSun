#import "AMAlbumInfoVC.h"
#import "YTPlayerView.h"
#import "AMTabMenuVC.h"
#import "AMInfoItemCell.h"
#import "AMAlbumInfoItem.h"

@interface AMAlbumInfoVC () <YTPlayerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet YTPlayerView *playerView;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) NSString *kCellIdentifier;
@property (nonatomic, strong) NSArray <AMAlbumInfoItem *> *items;

@end

@implementation AMAlbumInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.items = [self createItems];
    
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

#pragma mark - Private

- (NSArray <AMAlbumInfoItem *> *)createItems
{
    AMAlbumInfoItem *item = [AMAlbumInfoItem new];
    item.title = @"title1";
    item.subtitle = @"subtitle1";
    
    AMAlbumInfoItem *item2 = [AMAlbumInfoItem new];
    item2.title = @"title2";
    item2.subtitle = @"subtitle2";
    
    AMAlbumInfoItem *item3 = [AMAlbumInfoItem new];
    item3.title = @"title3";
    item3.subtitle = @"subtitle";
    
    return @[item, item2, item3];
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
    return self.items.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.frame.size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AMInfoItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.kCellIdentifier forIndexPath:indexPath];
    AMAlbumInfoItem *item = self.items[indexPath.item];
    [cell setupWithItem:item];
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.collectionView.frame.size.width;
    float fractionalPage = self.collectionView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
}

@end
