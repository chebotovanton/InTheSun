//
//  AMBlockingScreenVC.m
//  InTheSun
//
//  Created by Anton Chebotov on 06/02/16.
//  Copyright © 2016 Anton Chebotov. All rights reserved.
//

#import "AMBlockingScreenVC.h"
#import "AppDelegate.h"
#import "AMImageProcessor.h"

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

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    if ([AMImageProcessor doesImageFitConditions:chosenImage]) {
        AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate hideBlockingScreenAnimated:YES];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Not quite right"
                                   message:@"No sun in the frame"
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
