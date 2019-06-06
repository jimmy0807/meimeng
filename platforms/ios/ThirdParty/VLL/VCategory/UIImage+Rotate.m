//
//  UIImage+Rotate.m
//  CardBag
//
//  Created by XiaXianBing on 14/11/19.
//  Copyright (c) 2014年 Everydaysale. All rights reserved.
//

#import "UIImage+Rotate.h"

@implementation UIImage (Rotate)

- (UIImage *)imageRotateWithDegree:(CGFloat)degree
{
    CGSize rotateSize;
    rotateSize.width = CGImageGetWidth(self.CGImage);
    rotateSize.height = CGImageGetHeight(self.CGImage);
    
    UIGraphicsBeginImageContext(rotateSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotateSize.width/2, rotateSize.height/2);
    CGContextRotateCTM(bitmap, degree * M_PI/180);
    CGContextRotateCTM(bitmap, M_PI);
    CGContextScaleCTM(bitmap, -1.0, 1.0);
    CGContextDrawImage(bitmap, CGRectMake(-rotateSize.width/2, -rotateSize.height/2, rotateSize.width, rotateSize.height), self.CGImage);
    UIImage *rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return rotatedImage;
}

@end
