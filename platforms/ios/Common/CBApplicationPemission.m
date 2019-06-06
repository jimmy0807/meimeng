//
//  CBApplicationPemission.m
//  CardBag
//
//  Created by lining on 15/6/19.
//  Copyright (c) 2015年 Everydaysale. All rights reserved.
//

#import "CBApplicationPemission.h"
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation CBApplicationPemission

+(id)sharePermission
{
    static CBApplicationPemission *applicationPermission = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        applicationPermission = [[CBApplicationPemission alloc] init];
    });
    return applicationPermission;
}

-(BOOL)canLocation
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        if (IS_SDK8)
        {
            [[[UIAlertView alloc] initWithTitle:@"" message:LS(@"PleaseStartLocationServices") delegate:self cancelButtonTitle:LS(@"取消") otherButtonTitles:LS(@"立即开启"), nil] show];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"" message:LS(@"PleaseStartLocationServices") delegate:nil cancelButtonTitle:LS(@"知道了") otherButtonTitles:nil] show];
        }
        
        return FALSE;
    }
    
    return TRUE;
}


-(BOOL)canLoadCamera
{
    if (IS_SDK7) {
        if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied)
        {
            if (IS_SDK8)
            {
                [[[UIAlertView alloc] initWithTitle:@"" message:LS(@"该应用无法访问你的摄像头\n请在设置里开启") delegate:self cancelButtonTitle:LS(@"取消") otherButtonTitles:LS(@"立即开启"), nil] show];
            }
            else
            {
                [[[UIAlertView alloc] initWithTitle:@"" message:LS(@"该应用无法访问你的摄像头\n请在设置里开启") delegate:nil cancelButtonTitle:LS(@"知道了") otherButtonTitles:nil] show];
            }
            
            return FALSE;
        }
    }
    
    return TRUE;
}

-(BOOL)canLoadPhotoLibrary
{
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied)
    {
        if (IS_SDK8)
        {
            [[[UIAlertView alloc] initWithTitle:@"" message:LS(@"该应用无法访问你的相册\n请在设置里开启") delegate:self cancelButtonTitle:LS(@"取消") otherButtonTitles:LS(@"立即开启"), nil] show];
            
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"" message:LS(@"该应用无法访问你的相册\n请在设置里开启") delegate:nil cancelButtonTitle:LS(@"知道了") otherButtonTitles:nil] show];
        }
        
        return FALSE;
    }
    
    return TRUE;
}

-(BOOL)canLoadContact
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0 && ABAddressBookGetAuthorizationStatus()==kABAuthorizationStatusDenied)
    {
        if (IS_SDK8)
        {
            [[[UIAlertView alloc] initWithTitle:@"" message:LS(@"该应用无法访问你的通讯录\n请在设置里开启") delegate:self cancelButtonTitle:LS(@"取消") otherButtonTitles:LS(@"立即开启"), nil] show];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"" message:LS(@"该应用无法访问你的通讯录\n请在设置里开启") delegate:nil cancelButtonTitle:LS(@"知道了") otherButtonTitles:nil] show];
        }
        
        return FALSE;
    }
    
    return TRUE;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (IS_SDK8)
        {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
}

- (void)dealloc
{
    NSLog(@"CBApplicationPermiss dealloc");
}

@end
