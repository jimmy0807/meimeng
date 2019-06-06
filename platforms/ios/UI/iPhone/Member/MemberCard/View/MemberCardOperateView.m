//
//  MemberCardOperateView.m
//  Boss
//
//  Created by lining on 16/4/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCardOperateView.h"

int redefineType[] = {kPadMemberCardOperateRecharge,kPadMemberCardOperateBuy,kPadMemberCardOperateExchange,kPadMemberCardOperateRepayment,kPadMemberCardOperateRefund,kPadMemberCardOperateReplacement,kPadMemberCardOperateActive,kPadMemberCardOperateLost,kPadMemberCardOperateMerger,kPadMemberCardOperateUpgrade,kPadMemberCardOperateRedeem,kPadMemberCardOperateTurnStore};

@interface MemberCardOperateView ()
{
    UIView *lastView;
}
@property (nonatomic, strong) UIView *containView;
@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) NSMutableDictionary *viewItemDict;

@end

@implementation MemberCardOperateView

+ (instancetype)operateViewWithCard:(CDMemberCard *)card
{
    MemberCardOperateView *operateView = [[MemberCardOperateView alloc] init];
    operateView.card = card;
    return operateView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR(0,0,0,0);
//        self.alpha = 0.0;
        self.viewItemDict = [NSMutableDictionary dictionary];
        self.bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bgBtn.backgroundColor = [UIColor blackColor];
        self.bgBtn.alpha = 0.0;
        [self addSubview:self.bgBtn];
        [self.bgBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self.bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        self.containView = [[UIView alloc] init];
        self.containView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.containView];
        
        [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(0);
            make.trailing.offset(0);
            make.top.equalTo(self.mas_bottom).offset(0);
        }];
        
        [self initSubViews];
    }
    return self;
}


- (void)initSubViews
{
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = COLOR(245, 245, 245,1);
    [self.containView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.height.equalTo(@44);
       
    }];

    
    UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleBtn setBackgroundImage:[UIImage imageNamed:@"member_card_operate_cancel.png"] forState:UIControlStateNormal];
    [topView addSubview:deleBtn];
    
    [deleBtn addTarget:self action:@selector(deleBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [deleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.trailing.offset(-10);
    }];
    
    
    UIImage *lineImage = [UIImage imageNamed:@"member_card_operate_bg.png"];
    //三行四列
    NSInteger rowCount = 3;
    NSInteger itemCount = 4;
    for (int i = 0; i < rowCount; i++) {
        UIImageView *lineView = [[UIImageView alloc] init];
        lineView.userInteractionEnabled = true;
        lineView.image = lineImage;
        [self.containView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView == nil) {
                make.top.equalTo(topView.mas_bottom).offset(0);
                make.leading.offset(0);
                make.trailing.offset(0);
                make.width.equalTo(lineView.mas_height).multipliedBy(4.0f);
            }
            else
            {
                make.top.equalTo(lastView.mas_bottom).offset(0);
                
                make.width.equalTo(lastView.mas_width).offset(0);
                make.height.equalTo(lastView.mas_height).offset(0);
                make.leading.offset(0);
                make.trailing.offset(0);
            }
        }];
        lastView = lineView;
        if (i == rowCount - 1) {
            [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.containView).offset(0);
            }];
        }

        UIView *subLastView;
        for (int j = 0; j < itemCount; j++) {
            int idx = i * itemCount + j;
            UIView *operateView = [self itemViewWithIndex:idx];
            [self.viewItemDict setObject:operateView forKey:@(redefineType[idx])];
            [lineView addSubview:operateView];
            if (subLastView == nil) {
                [operateView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.offset(0);
                    make.leading.offset(0);
                    make.bottom.offset(0);
                }];
            }
            else
            {
                [operateView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.offset(0);
                    make.bottom.offset(0);
                    make.leading.equalTo(subLastView.mas_trailing).offset(0);
                    make.width.equalTo(subLastView.mas_width);
//                    make.height.equalTo(subLastView.mas_height);
                }];
            }
            
            subLastView = operateView;
            if (j == itemCount - 1) {
                [operateView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.trailing.offset(0);
                }];
            }
        }
    }
}


- (UIView *)itemViewWithIndex:(NSInteger)idx
{
    OperateItemView *view = [[OperateItemView alloc] init];
    view.tag = 1000 + redefineType[idx];
    view.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [view.button setBackgroundImage:[UIImage imageNamed:@"HomeTableviewItems_H.png"] forState:UIControlStateHighlighted];
    view.button.tag = 100+redefineType[idx];
    [view.button addTarget:self action:@selector(didItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:view.button];
    
    [view.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    NSString *image_name = [NSString stringWithFormat:@"card_operate_item_%02d",idx + 1];
    NSString *highlight = [NSString stringWithFormat:@"card_operate_item_disable_%02d",idx + 1];
    view.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image_name] highlightedImage:[UIImage imageNamed:highlight]];
//    imgView.highlighted = true;
    view.imgView.tag = 200 + redefineType[idx];
    [view addSubview:view.imgView];
    [view.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.centerOffset(CGPointMake(0, 0));
        
    }];
    
    return view;
}


- (void)setCard:(CDMemberCard *)card
{
    _card = card;
    PersonalProfile *profile = [PersonalProfile currentProfile];
    if (self.card) {
        NSLog(@"%.2f",self.card.amount.floatValue - 0.01);
        if ([self.card.state integerValue] == kPadMemberCardStateActive) {
            if (!profile.isAllowItem)
            {   
                [self itemDisableWithType:kPadMemberCardOperateExchange];
            }
            if (!profile.isAllowArrears || self.card.arrearsAmount.floatValue + self.card.courseArrearsAmount.floatValue <= 0)
            {
                [self itemDisableWithType:kPadMemberCardOperateRepayment];
            }
            if (self.card.amount.floatValue - 0.01 < 0)
            {
                [self itemDisableWithType:kPadMemberCardOperateRefund];
            }
            [self itemDisableWithType:kPadMemberCardOperateActive];
        }
        else
        {
            for (OperateItemView *view in self.viewItemDict.allValues)
            {
                view.enable = false;
            }
            
            if ( self.card.state.integerValue == kPadMemberCardStateLost || self.card.state.integerValue == kPadMemberCardStateDraft )
            {
                OperateItemView *view = [self.viewItemDict objectForKey:@(kPadMemberCardOperateActive)];
                view.enable = true;
            }
        }
    }
    else
    {
        for (OperateItemView *view in self.viewItemDict.allValues) {
            view.enable = false;
        }
    }
}


- (void)itemDisableWithType:(NSInteger)type
{
    if (type < 0) {
        return;
    }
    OperateItemView *view = [self.viewItemDict objectForKey:@(type)];
    view.enable = false;
}

- (void)deleBtnPressed:(UIButton *)btn
{
    NSLog(@"deleteBtn pressed");
    [self hide];
}

- (void)didItemPressed:(UIButton *)button
{
    [self hide];
    int idx = button.tag - 100;
    NSLog(@"idx: %d",idx);
    if ([self.delegate respondsToSelector:@selector(didOperateItemPressedWithType:)]) {
        [self.delegate didOperateItemPressedWithType:idx];
    }
}


- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self showInView:window];
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
//    [self performSelector:@selector(animation) withObject:nil afterDelay:0.1];
    [self layoutIfNeeded];
    [self animation];
}

- (void)animation
{
    
    [self.containView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(0);
        make.trailing.offset(0);
        make.bottom.offset(0);
    }];
    [UIView animateWithDuration:0.35 animations:^{
        [self.containView layoutIfNeeded];
        self.bgBtn.alpha = 0.6;
    }];
}

- (void)hide
{
    [self.containView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.offset(0);
        make.trailing.offset(0);
        make.top.equalTo(self.mas_bottom);
        
    }];
    
    [UIView animateWithDuration:0.35 animations:^{
        [self.containView layoutIfNeeded];
        self.bgBtn.alpha = 0.0;
        
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
     }];
}

@end

@implementation OperateItemView
- (void)setEnable:(BOOL)enable
{
    _enable = enable;
    self.button.enabled = enable;
    self.imgView.highlighted = !enable;
}
@end
