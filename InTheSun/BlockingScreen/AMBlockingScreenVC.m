//
//  AMBlockingScreenVC.m
//  InTheSun
//
//  Created by Anton Chebotov on 06/02/16.
//  Copyright © 2016 Anton Chebotov. All rights reserved.
//

#import "AMBlockingScreenVC.h"
#import "AppDelegate.h"

@interface AMBlockingScreenVC () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation AMBlockingScreenVC

- (IBAction)startCamera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (BOOL)doesImageFitConditions:(UIImage *)image
{
    return YES;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    if ([self doesImageFitConditions:chosenImage]) {
        AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate hideBlockingScreenAnimated:YES];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
