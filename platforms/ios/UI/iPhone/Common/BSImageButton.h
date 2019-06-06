//
//  BSImageButton.h
//  Boss
//
//  Created by lining on 16/10/10.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef enum ImageStyle
{
    ImageStyle_Default,//左边默认
    ImageStyle_Right,
    ImageStyle_Top,
    ImageStyle_Bottom
}ImageStyle;

@interface BSImageButton : UIButton

@property (nonatomic, assign) ImageStyle imageStyle;
@property (nonatomic, assign) float padding; //图片与文字间的距离，默认为2
- (instancetype)initWithTitle:(NSString *)title normalImageName:(NSString *)imageName;
- (instancetype)initWithTitle:(NSString *)title normalImageName:(NSString *)normalImageName highlightImageName:(NSString *)highlightImageName;
- (instancetype)initWithTitle:(NSString *)title normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName;
- (instancetype)initWithTitle:(NSString *)title normalImageName:(NSString *)normalImageName highlightImageName:(NSString *)highlightImageName selectedImageName:(NSString *)selectedImageName;

@end

