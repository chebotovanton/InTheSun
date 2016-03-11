//
//  AMImageProcessorTests.m
//  InTheSun
//
//  Created by Anton Chebotov on 08/02/16.
//  Copyright © 2016 Anton Chebotov. All rights reserved.
#import <XCTest/XCTest.h>
#import "AMImageProcessor.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface AMImageProcessorTests : XCTestCase

@end

@implementation AMImageProcessorTests

- (void)testSunnyImage1
{
    UIImage *image = [self imageNamed:@"sunny1.jpeg"];
    XCTAssertTrue([AMImageProcessor doesImageFitConditions:image]);
}

- (void)testSunnyImage2
{
    UIImage *image = [self imageNamed:@"sunny2.jpeg"];
    XCTAssertTrue([AMImageProcessor doesImageFitConditions:image]);
}

- (void)testSunnyImage3
{
    UIImage *image = [self imageNamed:@"sunny3.jpg"];
    XCTAssertTrue([AMImageProcessor doesImageFitConditions:image]);
}

- (void)testDarkImage1
{
    UIImage *image = [self imageNamed:@"dark1.jpeg"];
    XCTAssertFalse([AMImageProcessor doesImageFitConditions:image]);
}

- (void)testDarkImage2
{
    UIImage *image = [self imageNamed:@"dark2.jpeg"];
    XCTAssertFalse([AMImageProcessor doesImageFitConditions:image]);
}

- (UIImage *)imageNamed:(NSString *)name
{
    NSString *imagePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:name];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

@end
