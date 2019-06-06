//
//  UIImageScale.m
//  mojito
//
//  Created by vincent on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Scale.h"  

@implementation UIImage (scale)  

-(UIImage*)scaleToSize:(CGSize)size  
{
    @autoreleasepool {
        UIGraphicsBeginImageContextWithOptions(size,NO,0);
        [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scaledImage;
    }
}  

@end  
