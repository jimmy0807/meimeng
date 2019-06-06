//
//  PadProjectNaviView.m
//  Boss
//
//  Created by XiaXianBing on 15/10/12.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadProjectNaviView.h"
#import "UIImage+Resizable.h"

@interface PadProjectNaviView ()

@property (nonatomic, strong) UIImageView *remindImageView;
@property (nonatomic, strong) UILabel *remindLabel;

@property (nonatomic, strong) UIView *leftContentView;
@property (nonatomic, strong) UIButton *cardItemButton;

@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) UIScrollView *userScrollView;
@property (nonatomic, strong) UIView *selectUserView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, strong) PadProjectData *data;
@property (nonatomic, strong) NSMutableDictionary *cachePicParams;

@end

@implementation PadProjectNaviView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.cachePicParams = [[NSMutableDictionary alloc] init];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pad_navi_background"]];
        
        CGFloat leftContentViewWidth = (IC_SCREEN_WIDTH - kPadProjectSideViewWidth - kPadNaviHeight)/2.0;
        self.leftContentView = [[UIView alloc] initWithFrame:CGRectMake((IC_SCREEN_WIDTH - kPadProjectSideCellWidth - leftContentViewWidth)/2.0, 0.0, leftContentViewWidth, kPadNaviHeight)];
        self.leftContentView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.leftContentView];
        
        self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.titleButton.frame = CGRectMake(0.0, 0.0, 64.0, kPadNaviHeight);
        self.titleButton.backgroundColor = [UIColor clearColor];
        [self.titleButton addTarget:self action:@selector(didTitleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.leftContentView addSubview:self.titleButton];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, (kPadNaviHeight - 24.0)/2.0, 44.0, 24.0)];
        self.titleLabel.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = COLOR(96.0, 212.0, 212.0, 1.0);
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        self.titleLabel.font = [UIFont systemFontOfSize:18.0];
        [self.titleButton addSubview:self.titleLabel];
        
        UIImage *titleImage = [UIImage imageNamed:@"pad_title_drop_down"];
        UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(44.0, (kPadNaviHeight - titleImage.size.height)/2.0, titleImage.size.width, titleImage.size.height)];
        titleImageView.backgroundColor = [UIColor clearColor];
        titleImageView.image = titleImage;
        titleImageView.tag = 102;
        [self.titleButton addSubview:titleImageView];
        
        self.cardItemButton = [[UIButton alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH - kPadProjectSideViewWidth, 0.0, leftContentViewWidth, kPadNaviHeight)];
        self.cardItemButton.backgroundColor = [UIColor clearColor];
        UIImageView *centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1.0, kPadNaviHeight)];
        centerImageView.backgroundColor = COLOR(216.0, 230.0, 230.0, 1.0);
        [self.cardItemButton addSubview:centerImageView];
        [self.cardItemButton setTitleColor:COLOR(90.0, 211.0, 213.0, 1.0) forState:UIControlStateNormal];
        [self.cardItemButton setTitle:[NSString stringWithFormat:@"%@(%d)", LS(@"PadBornCategoryCardItem"), 0] forState:UIControlStateNormal];
        self.cardItemButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
        [self.cardItemButton addTarget:self action:@selector(didCardItemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cardItemButton];
        
        self.userScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH - kPadProjectSideViewWidth, 0.0, kPadProjectSideViewWidth, kPadNaviHeight)];
        self.userScrollView.backgroundColor = [UIColor whiteColor];
        self.userScrollView.scrollEnabled = YES;
        [self.userScrollView setShowsVerticalScrollIndicator:NO];
        [self.userScrollView setShowsHorizontalScrollIndicator:NO];
        self.userScrollView.bounces = NO;
        self.userScrollView.pagingEnabled = YES;
        self.userScrollView.contentSize = CGSizeMake(kPadProjectSideViewWidth + kPadNaviHeight, kPadNaviHeight);
        [self addSubview:self.userScrollView];
        
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadNaviHeight, kPadNaviHeight)];
        [backButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_pos_button_n"] forState:UIControlStateNormal];
        [backButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_pos_button_h"] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(didBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        
        self.remindImageView = [[UIImageView alloc] init];
        self.remindImageView.backgroundColor = [UIColor clearColor];
        self.remindImageView.image = [[UIImage imageNamed:@"pad_remind_dot_16"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
        self.remindImageView.frame = CGRectMake(kPadNaviHeight/2.0 + 12.0, kPadNaviHeight/2.0 - 28.0, 16.0, 16.0);
        self.remindImageView.hidden = NO;
        [backButton addSubview:self.remindImageView];
        
        self.remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(4.0, 0.0, 8.0, 16.0)];
        self.remindLabel.backgroundColor = [UIColor clearColor];
        self.remindLabel.textColor = [UIColor whiteColor];
        self.remindLabel.textAlignment = NSTextAlignmentCenter;
        self.remindLabel.font = [UIFont systemFontOfSize:12.0];
        [self.remindImageView addSubview:self.remindLabel];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(IC_SCREEN_WIDTH - kPadProjectSideViewWidth - 1.0, 0.0, 1.0, kPadNaviHeight)];
        lineImageView.backgroundColor = COLOR(216.0, 230.0, 230.0, 1.0);
        [self addSubview:lineImageView];
        
        UIButton *contentButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, kPadProjectSideViewWidth, kPadNaviHeight)];
        contentButton.backgroundColor = [UIColor clearColor];
        [contentButton addTarget:self action:@selector(didContentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.userScrollView addSubview:contentButton];
        
        UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(24.0, (kPadNaviHeight - 50.0)/2.0, 50.0, 50.0)];
        avatarImageView.backgroundColor = [UIColor clearColor];
        avatarImageView.tag = 101;
        [self.userScrollView addSubview:avatarImageView];
        
        UIImageView *avatarMaskView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
        avatarMaskView.backgroundColor = [UIColor clearColor];
        avatarMaskView.image = [UIImage imageNamed:@"pad_avatar_mask"];
        [avatarImageView addSubview:avatarMaskView];
        
        UIImage *deleteImage = [UIImage imageNamed:@"pad_navi_member_delete"];
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteButton.backgroundColor = [UIColor clearColor];
        self.deleteButton.frame = CGRectMake(-4.0, -4.0, deleteImage.size.width + 2 * 24.0, (kPadNaviHeight - 50.0) + deleteImage.size.height);
        [self.deleteButton setImage:deleteImage forState:UIControlStateNormal];
        [self.deleteButton setImageEdgeInsets:UIEdgeInsetsMake((kPadNaviHeight - 50.0)/2.0, 24.0, (kPadNaviHeight - 50.0)/2.0, 24.0)];
        [self.deleteButton addTarget:self action:@selector(didDeleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.userScrollView addSubview:self.deleteButton];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(24.0 + 50.0 + 16.0, kPadNaviHeight/2.0 - 20.0, kPadProjectSideViewWidth - 24.0 - 50.0 - 16.0 - 24.0 - 16.0, 20.0)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.tag = 102;
        nameLabel.font = [UIFont boldSystemFontOfSize:18.0];
        nameLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [self.userScrollView addSubview:nameLabel];
        
        UIImageView *timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(24.0 + 50.0 + 16.0, kPadNaviHeight/2.0 + 4.0, 15.0, 15.0)];
        timeImageView.backgroundColor = [UIColor clearColor];
        timeImageView.image = [UIImage imageNamed:@"pad_time_icon"];
        [self.userScrollView addSubview:timeImageView];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(24.0 + 50.0 + 16.0 + 15.0 + 8.0, kPadNaviHeight/2.0 + 4.0 - 2.5, kPadProjectSideViewWidth - 24.0 - 50.0 - 16.0 - 24.0 - 16.0 - 15.0 - 8.0, 20.0)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.tag = 103;
        timeLabel.font = [UIFont systemFontOfSize:14.0];
        timeLabel.textColor = COLOR(168.0, 168.0, 168.0, 1.0);
        [self.userScrollView addSubview:timeLabel];
        
        UIImage *arrowImage = [UIImage imageNamed:@"Pad_Home_history_arrow"];
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPadProjectSideViewWidth - 24.0 - arrowImage.size.width, (kPadNaviHeight - arrowImage.size.height)/2.0, arrowImage.size.width, arrowImage.size.height)];
        arrowImageView.backgroundColor = [UIColor clearColor];
        arrowImageView.image = arrowImage;
        [self.userScrollView addSubview:arrowImageView];
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.backgroundColor = COLOR(249.0, 86.0, 86.0, 1.0);
        confirmButton.frame = CGRectMake(kPadProjectSideViewWidth, 0.0, kPadNaviHeight, kPadNaviHeight);
        [confirmButton setTitle:LS(@"PadDeleteButton") forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
        [confirmButton addTarget:self action:@selector(didConfirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.userScrollView addSubview:confirmButton];
    }
    
    return self;
}


#pragma mark -
#pragma mark public Methods

- (void)reloadRemindInfoWithCount:(NSInteger)count
{
    if (count == 0)
    {
        self.remindLabel.text = @"";
        self.remindImageView.hidden = YES;
    }
    else
    {
        self.remindImageView.hidden = NO;
        self.remindLabel.text = [NSString stringWithFormat:@"%d", count];
        CGSize minSize = [self.remindLabel.text sizeWithFont:self.remindLabel.font constrainedToSize:CGSizeMake(1024.0, self.remindLabel.frame.size.height) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat width = minSize.width;
        if (width < self.remindImageView.frame.size.height - 2 * self.remindLabel.frame.origin.x)
        {
            width = self.remindImageView.frame.size.height - 2 * self.remindLabel.frame.origin.x;
        }
        else if (width > kPadNaviHeight - self.remindImageView.frame.origin.x - 2 * self.remindLabel.frame.origin.x)
        {
            width = kPadNaviHeight - self.remindImageView.frame.origin.x - 2 * self.remindLabel.frame.origin.x;
        }
        self.remindLabel.frame = CGRectMake(self.remindLabel.frame.origin.x, self.remindLabel.frame.origin.y, width, self.remindLabel.frame.size.height);
        self.remindImageView.frame = CGRectMake(self.remindImageView.frame.origin.x, self.remindImageView.frame.origin.y, 2 * self.remindLabel.frame.origin.x + self.remindLabel.frame.size.width, self.remindImageView.frame.size.height);
    }
}

- (void)reloadTitleWithData:(PadProjectData *)data
{
    self.data = data;
    UIImageView *titleImageView = (UIImageView *)[self.titleButton viewWithTag:102];
    
    if (self.data.isCustomPrice)
    {
        self.titleLabel.text = LS(@"PadBornCategoryCustomPrice");
    }
    else if (self.data.currentCategory == nil)
    {
        if ( self.data.isOnlyParent )
        {
            //self.titleLabel.text = [NSString stringWithFormat:@"%@ 其他(%d)", self.data.bornCategory.bornCategoryName, self.data.projectArray.count];
            self.titleLabel.text = [NSString stringWithFormat:@"%@ 其他", self.data.bornCategory.bornCategoryName];
        }
        else
        {
            //self.titleLabel.text = [NSString stringWithFormat:@"%@(%d)", self.data.bornCategory.bornCategoryName, self.data.bornCategory.totalCount.integerValue];
            //self.titleLabel.text = [NSString stringWithFormat:@"%@", self.data.bornCategory.bornCategoryName];
            self.titleLabel.text = [NSString stringWithFormat:@"请选择"];
        }
    }
    else
    {
        if ( self.data.isOnlyParent )
        {
            //self.titleLabel.text = [NSString stringWithFormat:@"%@ 其他(%d)", self.data.currentCategory.categoryName, self.data.projectArray.count];
            self.titleLabel.text = [NSString stringWithFormat:@"%@ 其他", self.data.currentCategory.categoryName];
        }
        else
        {
            //self.titleLabel.text = [NSString stringWithFormat:@"%@(%d)", self.data.currentCategory.categoryName, self.data.currentCategory.itemCount.integerValue];
            self.titleLabel.text = [NSString stringWithFormat:@"%@", self.data.currentCategory.categoryName];
        }
    }
    
    CGSize minSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(self.leftContentView.frame.size.width, self.titleLabel.frame.size.height) lineBreakMode:NSLineBreakByCharWrapping];
    CGFloat minWidth = minSize.width;
    if (minSize.width > self.leftContentView.frame.size.width - titleImageView.frame.size.width - 2 * 12.0)
    {
        minWidth = self.leftContentView.frame.size.width - kPadNaviHeight - titleImageView.frame.size.width - 2 * 12.0;
    }
    self.titleLabel.frame = CGRectMake(12.0, self.titleLabel.frame.origin.y, minWidth, self.titleLabel.frame.size.height);
    titleImageView.frame = CGRectMake(12.0 + self.titleLabel.frame.size.width + 12.0, titleImageView.frame.origin.y, titleImageView.frame.size.width, titleImageView.frame.size.height);
    self.titleButton.frame = CGRectMake((self.leftContentView.frame.size.width - minWidth - titleImageView.frame.size.width - 3 * 12.0)/2.0 + 12.0, 0.0, minWidth + titleImageView.frame.size.width + 3 * 12.0, kPadNaviHeight);
    self.titleButton.backgroundColor = [UIColor clearColor];
    
    [self.cardItemButton setTitle:[NSString stringWithFormat:@"%@(%d)", LS(@"PadBornCategoryCardItem"), self.data.cardItemCount] forState:UIControlStateNormal];
}

- (void)reloadUserInfoWithData:(PadProjectData *)data
{
    UIImageView *avatarImageView = (UIImageView *)[self.userScrollView viewWithTag:101];
    UILabel *nameLabel = (UILabel *)[self.userScrollView viewWithTag:102];
    UILabel *timeLabel = (UILabel *)[self.userScrollView viewWithTag:103];
    
    self.data = data;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:self.data.posOperate.operate_date];
    dateFormatter.dateFormat = @"HH:mm";
    timeLabel.text = [dateFormatter stringFromDate:date];
    if (self.data.posOperate.member.isDefaultCustomer.boolValue)
    {
        self.deleteButton.hidden = YES;
        self.userScrollView.scrollEnabled = NO;
        avatarImageView.image = [UIImage imageNamed:@"pad_avatar_default"];
        nameLabel.text = [NSString stringWithFormat:LS(@"PadDefaultCustomer")];
        if (self.data.posOperate.book)
        {
            nameLabel.text = [NSString stringWithFormat:LS(@"PadBookedCustomer"), self.data.posOperate.book.booker_name];
        }
    }
    else
    {
        self.deleteButton.hidden = NO;
        self.userScrollView.scrollEnabled = YES;
        nameLabel.text = self.data.posOperate.member.memberName;
        [avatarImageView setImageWithName:self.data.posOperate.member.imageName tableName:@"born.member" filter:self.data.posOperate.member.memberID fieldName:@"image" writeDate:self.data.posOperate.member.lastUpdate placeholderString:@"pad_avatar_default" cacheDictionary:self.cachePicParams];
    }
}


#pragma mark -
#pragma mark Required Methods

- (void)didBackButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didNaviBackButtonClick:)])
    {
        [self.delegate didNaviBackButtonClick:sender];
    }
}

- (void)didTitleButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didNaviTitleButtonClick:)])
    {
        [self.delegate didNaviTitleButtonClick:sender];
    }
}

- (void)didKeyboardButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didNaviKeyboardButtonClick:)])
    {
        [self.delegate didNaviKeyboardButtonClick:sender];
    }
}

- (void)didCardItemButtonClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didNaviCardItemButtonClick:)])
    {
        [self.delegate didNaviCardItemButtonClick:sender];
    }
}

- (void)didContentButtonClick:(id)sender
{
    if (self.userScrollView.contentOffset.x != 0)
    {
        [self.userScrollView scrollRectToVisible:CGRectMake(0.0, 0.0, self.userScrollView.frame.size.width, self.userScrollView.frame.size.height) animated:YES];
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didNaviUserInfoButtonClick:)])
    {
        [self.delegate didNaviUserInfoButtonClick:sender];
    }
}

- (void)didDeleteButtonClick:(id)sender
{
    if (self.userScrollView.contentOffset.x != kPadNaviHeight)
    {
        [self.userScrollView scrollRectToVisible:CGRectMake(kPadNaviHeight, 0.0, self.userScrollView.frame.size.width, self.userScrollView.frame.size.height) animated:YES];
    }
}

- (void)didConfirmButtonClick:(id)sender
{
    [self.userScrollView scrollRectToVisible:CGRectMake(0.0, 0.0, self.userScrollView.frame.size.width, self.userScrollView.frame.size.height) animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didNaviDeleteMemberInfoButtonClick:)])
    {
        [self.delegate didNaviDeleteMemberInfoButtonClick:sender];
    }
}



#pragma mark -
#pragma mark Animation Methods

- (void)didShowCardItemButton
{
    [UIView animateWithDuration:0.32 animations:^{
        self.leftContentView.frame = CGRectMake(kPadNaviHeight, self.leftContentView.frame.origin.y, self.leftContentView.frame.size.width, self.leftContentView.frame.size.height);
        self.cardItemButton.frame = CGRectMake(IC_SCREEN_WIDTH - kPadProjectSideViewWidth - self.cardItemButton.frame.size.width, self.cardItemButton.frame.origin.y, self.cardItemButton.frame.size.width, self.cardItemButton.frame.size.height);
    } completion:^(BOOL finished) {
        ;
    }];
}

- (void)didHideCardItemButton
{
    [UIView animateWithDuration:0.32 animations:^{
        self.leftContentView.frame = CGRectMake((IC_SCREEN_WIDTH - kPadProjectSideViewWidth - self.leftContentView.frame.size.width)/2.0, self.leftContentView.frame.origin.y, self.leftContentView.frame.size.width, self.leftContentView.frame.size.height);
        self.cardItemButton.frame = CGRectMake(IC_SCREEN_WIDTH - kPadProjectSideViewWidth, self.cardItemButton.frame.origin.y, self.cardItemButton.frame.size.width, self.cardItemButton.frame.size.height);
    } completion:^(BOOL finished) {
        ;
    }];
}


/*
- (void)preAnimation
{
    self.backTitleLabel.hidden = NO;
    self.backTitleLabel.text = self.titleLabel.text;
    self.backTitleLabel.frame = self.titleLabel.frame;
}

- (void)didAnimation
{
    CGFloat duration = 0.8;
    CABasicAnimation* frontRotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    frontRotateAnimation.duration = duration;
    frontRotateAnimation.beginTime = 0.0;
    frontRotateAnimation.fillMode = kCAFillModeForwards;
    frontRotateAnimation.fromValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(0)];
    frontRotateAnimation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(180)];
    frontRotateAnimation.removedOnCompletion = YES;
    frontRotateAnimation.delegate = self;
    [self.backTitleLabel.layer addAnimation:frontRotateAnimation forKey:@"FilpFront"];
    
    CABasicAnimation *frontPositionAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [frontPositionAnimation setToValue:@(-kPadNaviHeight)];
    frontPositionAnimation.duration = duration;
    frontPositionAnimation.removedOnCompletion = NO;
    [self.backTitleLabel.layer addAnimation:frontPositionAnimation forKey:@"PostionFront"];
    
    CABasicAnimation* backRotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    backRotateAnimation.duration = duration;
    backRotateAnimation.beginTime = 0.0;
    backRotateAnimation.fillMode = kCAFillModeForwards;
    backRotateAnimation.fromValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(90)];
    backRotateAnimation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(0)];
    backRotateAnimation.removedOnCompletion = YES;
    [self.titleLabel.layer addAnimation:backRotateAnimation forKey:@"FilpBack"];
    
    CABasicAnimation* backPositionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    backPositionAnimation.fromValue =[NSValue valueWithCGPoint:CGPointMake(self.titleLabel.center.x, self.titleLabel.center.y + 36)];
    backPositionAnimation.toValue =[NSValue valueWithCGPoint:CGPointMake(self.titleLabel.center.x, self.titleLabel.center.y)];
    backPositionAnimation.duration = duration;
    backPositionAnimation.removedOnCompletion = YES;
    [self.titleLabel.layer addAnimation:backPositionAnimation forKey:@"PostionBack"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.backTitleLabel.hidden = YES;
    self.backTitleLabel.text = self.titleLabel.text;
    self.backTitleLabel.frame = self.titleLabel.frame;
}
 */

@end
