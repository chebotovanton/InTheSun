#import "AMImageProcessor.h"

@implementation AMImageProcessor

+ (CGFloat)getAverageLuminanceFromImage:(UIImage *)image step:(NSInteger)step
{
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    CGFloat luminanceSum = 0.0;
    NSInteger luminanceTakes = 0;

    for (NSInteger x = 0; x < width; x = x + step) {
        for (NSInteger y = 0; y < height; y = y + step) {
            NSUInteger byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
            CGFloat alpha = ((CGFloat) rawData[byteIndex + 3] ) / 255.0f;
            CGFloat red   = ((CGFloat) rawData[byteIndex]     ) / alpha;
            CGFloat green = ((CGFloat) rawData[byteIndex + 1] ) / alpha;
            CGFloat blue  = ((CGFloat) rawData[byteIndex + 2] ) / alpha;
            
            luminanceSum += red*0.299 + green*0.587 + blue*0.114;
            luminanceTakes ++;
        }
    }
    
    free(rawData);
    
    return luminanceSum / luminanceTakes;
}

+ (CGFloat)getCenterLuminanceFromImage:(UIImage *)image step:(NSInteger)step
{
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    CGFloat luminanceSum = 0.0;
    NSInteger luminanceTakes = 0;
    
    NSInteger centerX = width / 2;
    NSInteger centerY = height / 2;
    NSInteger radius = width / 8;
    
    for (NSInteger x = 0; x < width; x = x + step) {
        for (NSInteger y = 0; y < height; y = y + step) {
            
            if (sqrtf(powf((x-centerX), 2) + powf((y-centerY), 2)) < radius) {
                NSUInteger byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
                CGFloat alpha = ((CGFloat) rawData[byteIndex + 3] ) / 255.0f;
                CGFloat red   = ((CGFloat) rawData[byteIndex]     ) / alpha;
                CGFloat green = ((CGFloat) rawData[byteIndex + 1] ) / alpha;
                CGFloat blue  = ((CGFloat) rawData[byteIndex + 2] ) / alpha;
                
                luminanceSum += red*0.299 + green*0.587 + blue*0.114;
                luminanceTakes ++;
            }
        }
    }
    
    free(rawData);
    
    return luminanceSum / luminanceTakes;
}

+ (CGFloat)getWhitePointsCount:(UIImage *)image step:(NSInteger)step
{
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    CGFloat luminanceSum = 0.0;
    NSInteger luminanceTakes = 0;
    
    NSInteger centerX = width / 2;
    NSInteger centerY = height / 2;
    NSInteger radius = 150.0;
    
    for (NSInteger x = 0; x < width; x = x + step) {
        for (NSInteger y = 0; y < height; y = y + step) {
            if (sqrtf(powf((x-centerX), 2) + powf((y-centerY), 2)) < radius) {
                NSUInteger byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
                CGFloat alpha = ((CGFloat) rawData[byteIndex + 3] ) / 255.0f;
                CGFloat red   = ((CGFloat) rawData[byteIndex]     ) / alpha;
                CGFloat green = ((CGFloat) rawData[byteIndex + 1] ) / alpha;
                CGFloat blue  = ((CGFloat) rawData[byteIndex + 2] ) / alpha;
                
                CGFloat lum = red*0.299 + green*0.587 + blue*0.114;
                if (lum > 0.9 * 255) {
                    luminanceSum ++;
                }
            }
        }
    }
    
    free(rawData);
    
    return luminanceSum;
}

@end
