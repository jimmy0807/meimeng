//
//  MemberFunctionHeadView.h
//  Boss
//
//  Created by lining on 16/5/11.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MemberFunctionHeadViewDelagate<NSObject>
@optional
- (void) didEditBtnPressed;
@end

@interface MemberFunctionHeadView : UIView

+ (instancetype)createView;

@property (strong, nonatomic) IBOutlet UIImageView *headImgView;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UIImageView *tipImgView;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) id<MemberFunctionHeadViewDelagate> delegate;
- (IBAction)editBtnPressed:(id)sender;

@end
