//
//  BSSearchView.h
//  Boss
//
//  Created by lining on 16/10/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BSSearchViewDelegate <NSObject>

@optional
- (void)didSearchWithText:(NSString *)text;
- (void)didCancelSearch;
- (void)didLeftBtnPressed:(UIButton *)leftBtn;
- (void)didRightBtnPressed:(UIButton *)rightBtn;

@end

@interface BSSearchView : UIView<UITextFieldDelegate>

+ (instancetype)createView;

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) id<BSSearchViewDelegate>delegate;

@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) NSString *placeHolder;
@property (strong, nonatomic) NSString *leftImgName;
@property (strong, nonatomic) NSString *rightImgName;
@property (strong, nonatomic) NSString *otherImgName;

@end
