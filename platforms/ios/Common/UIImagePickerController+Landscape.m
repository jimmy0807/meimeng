//
//  UIImagePickerController+Landscape.m
//  Boss
//
//  Created by XiaXianBing on 15/10/29.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "UIImagePickerController+Landscape.h"

@implementation UIImagePickerController (Landscape)

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (DEVICE_IS_IPAD)
    {
        return UIInterfaceOrientationMaskLandscape;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (DEVICE_IS_IPAD)
    {
        return ((interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (interfaceOrientation == UIDeviceOrientationLandscapeRight));
    }
    else
    {
        return (interfaceOrientation == UIDeviceOrientationPortrait);
    }
}

@end
