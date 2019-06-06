//
//  DrwableButton.h
//  Boss
//
//  Created by lining on 16/6/24.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrwableButton : UIButton
- (instancetype)initWithTitle:(NSString *)title;
- (instancetype)initWithTitle:(NSString *)title font:(UIFont *)font;
- (instancetype)initWithTitle:(NSString *)title font:(UIFont *)font imageName:(NSString *)name selectedImageName:(NSString *)selectedName;
@end
