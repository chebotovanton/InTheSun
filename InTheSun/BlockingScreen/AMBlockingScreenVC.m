#import "AMBlockingScreenVC.h"
#import "AppDelegate.h"
#import "AMImageProcessor.h"
#import <AVFoundation/AVFoundation.h>

@interface AMBlockingScreenVC () <UINavigationControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, assign) BOOL shouldCheckImage;

@property (nonatomic, weak) IBOutlet UIButton *cameraButton;
@property (nonatomic, weak) IBOutlet UIButton *goToAlbumButton;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

@end

@implementation AMBlockingScreenVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.shouldCheckImage = YES;
}

- (IBAction)startCamera
{
    [self hideControls];
    [self setupCaptureSession];
}

- (IBAction)goToAlbum
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate hideBlockingScreenAnimated:YES];
}

- (void)hideControls
{
    self.descriptionLabel.hidden = YES;
    self.cameraButton.hidden = YES;
}

- (void)showAlbumButton
{
    self.goToAlbumButton.hidden = NO;
    [self.view bringSubviewToFront:self.goToAlbumButton];
}

- (void)playSong
{
#warning Switched off
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"song" ofType:@"mp3"];
//    NSURL *url = [[NSURL alloc] initFileURLWithPath: path];
//    AVAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
//    AVPlayerItem *anItem = [AVPlayerItem playerItemWithAsset:asset];
//    
//    self.player = [AVPlayer playerWithPlayerItem:anItem];
//    [self.player play];
}

#pragma mark -

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

- (void)startCapturingWithSession: (AVCaptureSession *) captureSession
{
    NSLog(@"Adding video preview layer");
    [self setPreviewLayer:[[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession]];
    
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    
    //----- DISPLAY THE PREVIEW LAYER -----
    //Display it full screen under our view controller existing controls
    NSLog(@"Display the preview layer");
    CGRect layerRect = [[[self view] layer] bounds];
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
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    
    if (self.shouldCheckImage && [AMImageProcessor doesImageFitConditions:image]) {
        self.shouldCheckImage = NO;
        [self showAlbumButton];
        [self playSong];
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
