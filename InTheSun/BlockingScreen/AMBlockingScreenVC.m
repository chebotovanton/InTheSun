#import "AMBlockingScreenVC.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "AMImageProcessor.h"
#import "AMTabMenuVC.h"

static CGFloat kSongStartLuminanceLimit = 20000.0;
static CGFloat kModeSwitchLuminanceLimit = 30000.0;

@interface AMBlockingScreenVC () <UINavigationControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>


@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, assign) CGFloat luminanceSum;
@property (nonatomic, assign) BOOL shouldCheckLuminance;

@property (nonatomic, weak) IBOutlet UIImageView *yellowCircle;
@property (nonatomic, weak) IBOutlet UIImageView *whiteCircle;

@property (nonatomic, weak) IBOutlet UIButton *goToAlbumButton;

@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *actionLabel;
@property (nonatomic, weak) IBOutlet UIImageView *albumNameView;
@property (nonatomic, weak) IBOutlet UIImageView *groupNameView;
@property (nonatomic, weak) IBOutlet UIImageView *circleAlbumName;
@end

@implementation AMBlockingScreenVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateCirclesWithAlpha:0.0];
    [self switchToInitialState];
}

- (IBAction)goToAlbum
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate hideBlockingScreenAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!isSimulator()) {
        [self setupCaptureSession];
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)setControlsToPlayMode
{
    CGFloat duration = 0.3;
    [UIView animateWithDuration:duration
                     animations:^{
                         self.goToAlbumButton.alpha = 0.0;
                         self.descriptionLabel.alpha = 0.0;
                         self.actionLabel.alpha = 0.0;
                         self.albumNameView.alpha = 0.0;
                         self.groupNameView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:duration
                                          animations:^{
                                              self.goToAlbumButton.alpha = 1.0;
                                              self.circleAlbumName.alpha = 1.0;
                                          }];
                     }];
}

- (void)setControlsToCameraMode
{
    CGFloat duration = 0.3;
    [UIView animateWithDuration:duration
                     animations:^{
                         self.descriptionLabel.alpha = 1.0;
                         self.actionLabel.alpha = 1.0;
                        [self updateCirclesWithAlpha:0.0];
                     } completion:nil];
    
}

- (void)setControlsToInitialMode
{
    self.goToAlbumButton.alpha = 0.0;
    self.descriptionLabel.alpha = 0.0;
    self.actionLabel.alpha = 0.0;
    self.whiteCircle.alpha = 0.0;
    self.yellowCircle.alpha = 0.0;
    self.circleAlbumName.alpha = 0.0;
}

- (void)updateCirclesWithAlpha:(CGFloat)alpha
{
    self.whiteCircle.alpha = 1 - alpha;
    self.yellowCircle.alpha = alpha;
}

- (void)playSong
{
    [self.delegate playInitialSong];
}

#pragma mark - Switch States

- (void)switchToPlayState
{
    [self setControlsToPlayMode];
}

- (void)switchToCameraState
{
    [self setControlsToCameraMode];
    self.shouldCheckLuminance = YES;
    self.luminanceSum = 0.0;
}

- (void)switchToInitialState
{
    [self setControlsToInitialMode];
}

#pragma mark - Camera

- (void)setupCaptureSession
{
    NSError *error = nil;
    
    // Create the session
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    // Configure the session to produce lower resolution video frames, if your
    // processing algorithm can cope. We'll specify medium quality for the
    // chosen device.
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    // Find a suitable AVCaptureDevice
    AVCaptureDevice *device = [AVCaptureDevice
                               defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Create a device input with the device and add it to the session.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                                        error:&error];
    if (!input) {
        // Handling the error appropriately.
    }
    [session addInput:input];
    
    // Create a VideoDataOutput and add it to the session
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [session addOutput:output];
    
    // Configure your output.
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [output setSampleBufferDelegate:self queue:queue];
    
    // Specify the pixel format
    output.videoSettings =
    [NSDictionary dictionaryWithObject:
     [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    // Start the session running to start the flow of data
    [self startCapturingWithSession:session];
    
    // Assign session to an ivar.
    [self setSession:session];
}

- (void)setVideoOrientation
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    switch (deviceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            [self.previewLayer.connection setVideoOrientation:AVCaptureVideoOrientationPortraitUpsideDown];
            break;
        case UIInterfaceOrientationLandscapeLeft:
            [self.previewLayer.connection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
            break;
        case UIInterfaceOrientationLandscapeRight:
            [self.previewLayer.connection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
            break;
        default:
            [self.previewLayer.connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
            break;
    }
}

- (void)startCapturingWithSession: (AVCaptureSession *) captureSession
{
    [self setPreviewLayer:[[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession]];
    
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self setVideoOrientation];
    
    //----- DISPLAY THE PREVIEW LAYER -----
    //Display it full screen under our view controller existing controls
    
    CGRect layerRect = [UIScreen mainScreen].bounds;
    [self.previewLayer setBounds:layerRect];
    [self.previewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),
                                               CGRectGetMidY(layerRect))];
    //[[[self view] layer] addSublayer:[[self CaptureManager] self.previewLayer]];
    //We use this instead so it goes on a layer behind our UI controls (avoids us having to manually bring each control to the front):
    UIView *CameraView = [[UIView alloc] init];
    [[self view] addSubview:CameraView];
    [self.view sendSubviewToBack:CameraView];
    
    [[CameraView layer] addSublayer:self.previewLayer];
    
    //----- START THE CAPTURE SESSION RUNNING -----
    [captureSession startRunning];
}

// Delegate routine that is called when a sample buffer was written
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    // Create a UIImage from the sample buffer data
    [connection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
    
    if (self.shouldCheckLuminance) {
        UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
        
        CGFloat newLuminance = [AMImageProcessor getAverageLuminanceFromImage:image step:10];
        self.luminanceSum += newLuminance;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat alpha = self.luminanceSum/kModeSwitchLuminanceLimit;
            [self updateCirclesWithAlpha:alpha];
            if ([self.delegate isPlaying] == NO && self.luminanceSum > kSongStartLuminanceLimit) {
                [self playSong];
            }
            if (self.luminanceSum > kModeSwitchLuminanceLimit) {
                self.shouldCheckLuminance = NO;
                [self switchToPlayState];
            }
        });
    }
}

// Create a UIImage from sample buffer data
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}


@end
