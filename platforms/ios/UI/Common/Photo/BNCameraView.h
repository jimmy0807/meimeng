//
//  BNCameraView.h
//  meim
//
//  Created by jimmy on 2017/9/17.
//
//

#import <Foundation/Foundation.h>

typedef void (^takePhotoBlock)(UIImage* image);

@interface BNCameraView : UIView

+(BNCameraView*)showinView:(UIView*)v takPhoto:(takePhotoBlock)block;
-(void)focusAtCenter;

@end
