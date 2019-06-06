//
//  BSCropScrollView.h
//  Boss
//
//  Created by XiaXianBing on 15/7/6.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSCropScrollView : UIScrollView <UIScrollViewDelegate>

- (id)initWithImage:(UIImage *)image;
- (UIImage *)didImageViewCroppedFinish;

@end
