#import "OpenCVWrapper.h"
#import "UIImage+OpenCV.h"

@implementation OpenCVWrapper

+ (BOOL) imageHasCircle:(UIImage*)image
{    
    cv::Mat imageMatrix = [image CVMat];
    
    if(imageMatrix.empty()) {
        return NO;
    }
    
    cv::Mat cimg;
    if ( imageMatrix.type()==CV_8UC1 ) {
        cvtColor(imageMatrix, cimg, CV_GRAY2RGB);
    } else {
        cimg = imageMatrix;
        cvtColor(imageMatrix, imageMatrix, CV_RGB2GRAY);
    }
    medianBlur(imageMatrix, imageMatrix, 5);
    
    std::vector<cv::Vec3f> circles;
#warning We need to have more tests here ;)
    HoughCircles(imageMatrix, circles, CV_HOUGH_GRADIENT, 1, 1000, 100, 30, 150, 400);
    
    return circles.size() > 0;
}

+ (CGPoint)circleCenterAtImage:(UIImage *)image
{
    cv::Mat imageMatrix = [image CVMat];
    
    if(imageMatrix.empty()) {
        return CGPointZero;
    }
    
    cv::Mat cimg;
    if ( imageMatrix.type()==CV_8UC1 ) {
        cvtColor(imageMatrix, cimg, CV_GRAY2RGB);
    } else {
        cimg = imageMatrix;
        cvtColor(imageMatrix, imageMatrix, CV_RGB2GRAY);
    }
    medianBlur(imageMatrix, imageMatrix, 5);
    
    std::vector<cv::Vec3f> circles;
#warning We need to have more tests here ;)
    HoughCircles(imageMatrix, circles, CV_HOUGH_GRADIENT, 1, 70, 100, 30, 50, 500);
//              image,        circles, method,         dp, dist, p1, p2, minR maxR
    
    
    NSLog(@"circles count %lu", circles.size());
    CGPoint result = CGPointZero;
    int maxRadius = 0;
    for (int i = 0; i < circles.size(); i++) {
        cv::Vec3f circle = circles[0];
        if (circle[2] > maxRadius) {
            maxRadius = circle[2];
            result = CGPointMake(circle[1], circle[0]);
        }
    }
    return result;
}

@end
