//
//  MemberCardOperateView.h
//  Boss
//
//  Created by lining on 16/4/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef enum OperateCardType
//{
//    OperateCardType_ChongZhi,
//    OperateCardType_GouMai,
//    OperateCardType_TuiXiangMu,
//    OperateCardType_HuanKuan,
//    OperateCardType_TuiKuan,
//    OperateCardType_HuanKa,
//    OperateCardType_JiHuo,
//    OperateCardType_GuaShi,
//    OperateCardType_BingKa,
//    OperateCardType_KaShengJi,
//    OperateCardType_JiFen,
//    OperateCardType_ZhuanDian
//    
//}OperateCardType;


@protocol CardOperateViewDelegate <NSObject>
- (void)didOperateItemPressedWithType:(kPadMemberCardOperateType)type;
@end

@interface MemberCardOperateView : UIView

+ (instancetype)operateViewWithCard:(CDMemberCard *)card;

@property (nonatomic, weak) id<CardOperateViewDelegate>delegate;
@property (nonatomic, strong) CDMemberCard *card;

- (void)showInView:(UIView *)view;
- (void)show;
- (void)hide;
@end

@interface OperateItemView : UIView

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, assign) BOOL enable;

@end
