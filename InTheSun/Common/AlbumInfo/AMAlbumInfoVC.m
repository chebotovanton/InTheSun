#import "AMAlbumInfoVC.h"
#import "YTPlayerView.h"
#import "AMTabMenuVC.h"
#import "AMInfoItemCell.h"
#import "AMAlbumInfoItem.h"
#import "AMAlbumInfoItemsManager.h"

@interface AMAlbumInfoVC () <YTPlayerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet YTPlayerView *playerView;
@property (nonatomic, weak) IBOutlet UIView *videoPlaceholder;
@property (nonatomic, weak) IBOutlet UICollectionView *photoCollectionView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *videoHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *photosHeight;

@property (nonatomic, strong) NSString *kCellIdentifier;
@property (nonatomic, strong) NSArray <AMAlbumInfoItem *> *items;

@end

@implementation AMAlbumInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setConstraints];
    self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 50.0, 0.0);
    self.items = [AMAlbumInfoItemsManager createItems];
    self.pageControl.numberOfPages = self.items.count;
    
    self.kCellIdentifier = @"AMInfoItemCell";
    UINib *nib = [UINib nibWithNibName:@"AMInfoItemCell" bundle:nil];
    [self.photoCollectionView registerNib:nib forCellWithReuseIdentifier:self.kCellIdentifier];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0.0;
    layout.minimumLineSpacing = 0.0;
    layout.headerReferenceSize = CGSizeZero;
    layout.sectionInset = UIEdgeInsetsZero;
    self.photoCollectionView.collectionViewLayout = layout;
    
    self.playerView.delegate = self;
}

- (void)setConstraints
{
    if (is_iPhone6()) {
        self.videoHeight.constant = 270.0;
        self.photosHeight.constant = 270.0;
    }
    if (is_iPhone6Plus()) {
        self.videoHeight.constant = 320.0;
        self.photosHeight.constant = 320.0;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.playerView loadWithVideoId:@"UP7yivCcABM"];
}

- (void)stopMusicPlayer
{
    [(AMTabMenuVC *)self.tabBarController stopMusicPlayer];
}

- (IBAction)selectPage:(UIPageControl *)pageControl
{
    CGPoint newOffset = CGPointMake(pageControl.currentPage * self.scrollView.frame.size.width, 0.0);
    [self.photoCollectionView setContentOffset:newOffset animated:YES];
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

- (void)playerViewDidBecomeReady:(nonnull YTPlayerView *)playerView
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.videoPlaceholder.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [self.videoPlaceholder removeFromSuperview];
                     }];
    
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.photoCollectionView.frame.size.width;
    float fractionalPage = self.photoCollectionView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
}

@end
