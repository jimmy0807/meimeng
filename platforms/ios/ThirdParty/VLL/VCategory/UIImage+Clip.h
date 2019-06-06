//
//  UIImageClip.h
//  mojito
//
//  Created by jimmy on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (clip)  
- (UIImage *)clipToAspectRatio:(CGFloat)ratio;
@end  



@interface MJTImageUtil : NSObject 
{
}

+ (UIImage *)rotateImage:(UIImage *)aImage;
@end