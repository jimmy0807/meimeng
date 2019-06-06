//
//  PeopleBottomSelectedView.h
//  Boss
//
//  Created by lining on 16/5/26.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomSelectedViewDelegate <NSObject>
@optional
- (void)didAllSelectedBtnPressed:(BOOL)selected;
- (void)didSureBtnPressed;

@end

@interface PeopleBottomSelectedView : UIView
+ (instancetype)createView;

@property (nonatomic, weak)id<BottomSelectedViewDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIImageView *selectedImgView;
@property (strong, nonatomic) IBOutlet UILabel *selectedLabel;
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;
- (IBAction)allSelectedBtnPressed:(id)sender;
- (IBAction)sureBtnPressed:(id)sender;
@end
