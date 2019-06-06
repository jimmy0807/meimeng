//
//  BSImagePickerManager.m
//  Boss
//
//  Created by lining on 15/7/3.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSImagePickerManager.h"

@interface BSImagePickerManager ()
@property(nonatomic, assign) BOOL allowEidt;

@end

@implementation BSImagePickerManager

+ (instancetype)shareManager
{
    static BSImagePickerManager *pickerManager = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        pickerManager = [[BSImagePickerManager alloc] init];
    });
    return pickerManager;
}

- (void)startImagePickerWithType:(UIImagePickerControllerSourceType)sourceType delegate:(id<BSImagePickerManagerDelegate>)delegate allowEdit:(BOOL)edit
{
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            NSLog(@"没有摄像头");
            return;
        }
    }
    
    self.delegate = delegate;
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = sourceType;
    
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = edit;
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVC presentViewController:imagePickerController animated:YES completion:NULL];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //key:UIImagePickerControllerOriginalImage 取原始图片
    //key:UIImagePickerControllerEditedImage 取编辑后的图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    if (picker.allowsEditing) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    if ([self.delegate respondsToSelector:@selector(didSelectedImage:)]) {
        [self.delegate didSelectedImage:image];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSLog(@"!!!!!!!!!!!!!!!!!!!");
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
