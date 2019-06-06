//
//  FilterItemView.h
//  Boss
//
//  Created by lining on 16/5/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RightDrawableBtn;
@class FilterItemView;

@protocol FilterItemViewDelegate <NSObject>
@optional 
- (void)didArrowBtnPressed:(FilterItemView *)itemView;
- (void)didCancelSelectedBtnPressed:(FilterItemView *)itemView;
@end

@interface FilterItemView : UIView
- (instancetype)initWithTitle:(NSString *)title;
- (instancetype)initWithTitle:(NSString *)title imgName:(NSString *)imgName selectedImgName:(NSString *)selectedImgName;

@property (nonatomic, strong) NSString *tagString;
@property (nonatomic, weak) id<FilterItemViewDelegate>delegate;

@property (nonatomic, strong) RightDrawableBtn *normalBtn;
@property (nonatomic, strong) NSString *normalTitle;

@property (nonatomic, strong) NSString *selectedTitle;
@property (nonatomic, strong) UIButton *selectedBtn;


@end

@interface RightDrawableBtn : UIButton
- (instancetype)initWithTitle:(NSString *)title;
- (instancetype)initWithTitle:(NSString *)title font:(UIFont *)font;
- (instancetype)initWithTitle:(NSString *)title font:(UIFont *)font imageName:(NSString *)name selectedImageName:(NSString *)selectedName;

@end
