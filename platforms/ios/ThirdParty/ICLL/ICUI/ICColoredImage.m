//
//  ICColoredImage.m
//  PaintingTycoon
//
//  Created by jimmy on 12-12-24.
//  Copyright (c) 2012年 InnovClub. All rights reserved.
//

#import "ICColoredImage.h"

@implementation ICColoredImage

+(UIImage*)createEllipseImage:(CGSize)size withColor:(UIColor*)color
{
    int w = size.width * 2;
    int h = size.height * 2;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextAddEllipseInRect(context, rect);
    CGContextFillPath(context);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage* image = [UIImage imageWithCGImage:imageMasked];
    CGImageRelease(imageMasked);
    return image;
}

+(UIImage*)createRectImage:(CGSize)size withColor:(UIColor*)color
{
    int w = size.width * 2;
    int h = size.height * 2;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big);

    CGRect rect = CGRectMake(0, 0, w, h);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextAddRect(context, rect);
    CGContextFillPath(context);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage* image = [UIImage imageWithCGImage:imageMasked];
    CGImageRelease(imageMasked);
    return image;
}

@end
