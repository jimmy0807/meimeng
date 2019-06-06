//
//  ICColoredImage.h
//  PaintingTycoon
//
//  Created by jimmy on 12-12-24.
//  Copyright (c) 2012年 InnovClub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ICColoredImage : NSObject

+(UIImage*)createEllipseImage:(CGSize)size withColor:(UIColor*)color;
+(UIImage*)createRectImage:(CGSize)size withColor:(UIColor*)color;

@end
