//
//  UIImage+OpenCV.m
//  InTheSun
//
//  Created by Nikita.Kardakov on 10/03/2016.
//  Copyright © 2016 Anton Chebotov. All rights reserved.
//

#import "UIImage+OpenCV.h"

@implementation UIImage(OpenCV)

-(cv::Mat)CVMat
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(self.CGImage);
    CGFloat cols;
    CGFloat rows;
    if  (self.imageOrientation == UIImageOrientationLeft
         || self.imageOrientation == UIImageOrientationRight) {
        cols = self.size.height;
        rows = self.size.width;
    } else {
        cols = self.size.width;
        rows = self.size.height;
    }
    
    cv::Mat cvMat(rows, cols, CV_8UC4);
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data, cols,                                                    rows, 8, cvMat.step[0], colorSpace, kCGImageAlphaNoneSkipLast |                                                    kCGBitmapByteOrderDefault);
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), self.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

@end
