#import "OpenCVWrapper.h"
#import "UIImage+OpenCV.h"

@implementation OpenCVWrapper

+ (BOOL) imageHasCircle:(UIImage*)image
{
    std::vector<cv::Vec3f> circles = [self circlesFromImage:image];
    return circles.size() > 0;
}

+ (CGPoint)circleCenterAtImage:(UIImage *)image
{
    std::vector<cv::Vec3f> circles = [self circlesFromImage:image];
    
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

+ (std::vector<cv::Vec3f>)circlesFromImage:(UIImage *)image
{
    std::vector<cv::Vec3f> circles;
    
    cv::Mat imageMatrix = [image CVMat];
    
    if(imageMatrix.empty()) {
        return circles;
    }
    
    cv::Mat cimg;
    if ( imageMatrix.type()==CV_8UC1 ) {
        cvtColor(imageMatrix, cimg, CV_GRAY2RGB);
    } else {
        cimg = imageMatrix;
        cvtColor(imageMatrix, imageMatrix, CV_RGB2GRAY);
    }
    medianBlur(imageMatrix, imageMatrix, 5);
    
    HoughCircles(imageMatrix, circles, CV_HOUGH_GRADIENT, 1, 70, 100, 70, 50, 300);
    //              image,        circles, method,       dp dist  p1  p2 minR maxR
    return circles;
}

@end
