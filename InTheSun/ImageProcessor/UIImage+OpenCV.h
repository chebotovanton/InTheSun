//
//  UIImage+OpenCV.h
//  InTheSun
//
//  Created by Nikita.Kardakov on 10/03/2016.
//  Copyright © 2016 Anton Chebotov. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#endif
#import <UIKit/UIKit.h>

@interface UIImage(OpenCV)

- (cv::Mat)CVMat;

@end
