//
//  OpenCVWrapper.m
//  InTheSun
//
//  Created by Nikita.Kardakov on 10/03/2016.
//  Copyright © 2016 Anton Chebotov. All rights reserved.
//

#import "OpenCVWrapper.h"
#import "UIImage+OpenCV.h"

@implementation OpenCVWrapper

+ (BOOL) imageHasCircle:(UIImage*)image {
    
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
    // We need to have more tests here ;)
    HoughCircles(imageMatrix, circles, CV_HOUGH_GRADIENT, 1, 1000, 100, 30, 150, 400);
    
    return circles.size() > 0;
}

@end
