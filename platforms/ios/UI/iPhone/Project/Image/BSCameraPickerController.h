//
//  BSCameraPickerController.h
//  Camera
//
//  Created by XiaXianBing on 15/7/10.
//  Copyright (c) 2015年 XiaXianBing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@protocol BSCameraPickerControllerDelegate <NSObject>

- (void)didCameraImagePickerFinished:(UIImage *)image;

@end

@interface BSCameraPickerController : UIImagePickerController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (id)initWithBSDelegate:(id<BSCameraPickerControllerDelegate>)bsdelegate;


@end
