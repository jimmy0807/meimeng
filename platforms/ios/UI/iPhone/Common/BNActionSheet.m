//
//  BNActionSheet.m
//  Boss
//
//  Created by XiaXianBing on 15/6/10.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BNActionSheet.h"

#define kBNActionSheetTitleHeight       60.0
#define kBNActionSheetItemHeight        50.0
#define kBNActionSheetCancelMargin      5.0

@interface BNActionSheet ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSString *cancelTitle;
@property (nonatomic, assign) id<BNActionSheetDelegate> delegate;

@property (nonatomic, strong) UIButton *contentButton;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation BNActionSheet

- (id)initWithItems:(NSArray *)items delegate:(id<BNActionSheetDelegate>)delegate
{
    return [self initWithTitle:nil items:items cancelTitle:nil delegate:delegate];
}

- (id)initWithItems:(NSArray *)items cancelTitle:(NSString *)cancelTitle delegate:(id<BNActionSheetDelegate>)delegate
{
    return [self initWithTitle:nil items:items cancelTitle:cancelTitle delegate:delegate];
}

- (id)initWithTitle:(NSString *)title items:(NSArray *)items delegate:(id<BNActionSheetDelegate>)delegate
{
    return [self initWithTitle:title items:items cancelTitle:nil delegate:delegate];
}

- (id)initWithTitle:(NSString *)title items:(NSArray *)items cancelTitle:(NSString *)cancelTitle delegate:(id<BNActionSheetDelegate>)delegate
{
    self = [super initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT)];
    if (self != nil)
    {
        self.title = title;
        self.items = items;
        self.cancelTitle = cancelTitle;
        self.delegate = delegate;
        self.backgroundColor = [UIColor clearColor];
        
        self.contentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.contentButton.frame = self.bounds;
        self.contentButton.backgroundColor = [UIColor blackColor];
        [self.contentButton addTarget:self action:@selector(didContentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.contentButton.alpha = 0.0;
        [self addSubview:self.contentButton];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, IC_SCREEN_HEIGHT, IC_SCREEN_WIDTH, (self.title.length == 0 ? 0 : 1) * kBNActionSheetTitleHeight + (kBNActionSheetItemHeight + 0.5) * self.items.count + (self.cancelTitle.length == 0 ? 0 : (kBNActionSheetCancelMargin + kBNActionSheetItemHeight)))];
        self.contentView.backgroundColor = COLOR(226.0, 226.0, 226.0, 1.0);
        self.contentView.userInteractionEnabled = YES;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:self.contentView];
        
        CGFloat originY = 0.0;
        if (self.title.length > 0)
        {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, kBNActionSheetTitleHeight)];
            titleLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bn_actionsheet_n"]];
            titleLabel.text = self.title;
            titleLabel.font = [UIFont systemFontOfSize:14.0];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = COLOR(128.0, 128.0, 128.0, 1.0);
            titleLabel.numberOfLines = 2;
            [self.contentView addSubview:titleLabel];
            
            originY += kBNActionSheetTitleHeight;
        }
        
        for (int i = 0; i < self.items.count; i++)
        {
            UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, originY + i * (kBNActionSheetItemHeight + 0.5), IC_SCREEN_WIDTH, 0.5)];
            lineImageView.backgroundColor = [UIColor clearColor];
            lineImageView.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
            [self.contentView addSubview:lineImageView];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor clearColor];
            button.frame = CGRectMake(0.0, originY + i * (kBNActionSheetItemHeight + 0.5) + 0.5, IC_SCREEN_WIDTH, kBNActionSheetItemHeight);
            button.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
            [button setTitleColor:COLOR(72.0, 72.0, 72.0, 1.0) forState:UIControlStateNormal];
            [button setTitle:[self.items objectAtIndex:i] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"bn_actionsheet_n"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"bn_actionsheet_h"] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(didActionSheetItemClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 100 + i;
            [self.contentView addSubview:button];
        }
        originY += self.items.count * (kBNActionSheetItemHeight + 0.5);
        
        if (self.cancelTitle.length > 0)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor clearColor];
            button.frame = CGRectMake(0.0, originY + kBNActionSheetCancelMargin, IC_SCREEN_WIDTH, kBNActionSheetItemHeight);
            button.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
            [button setTitleColor:COLOR(72.0, 72.0, 72.0, 1.0) forState:UIControlStateNormal];
            [button setTitle:self.cancelTitle forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"bn_actionsheet_n"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"bn_actionsheet_h"] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(didContentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
        }
    }
    
    return self;
}

- (void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.contentButton.alpha = 0.5;
        self.contentView.frame = CGRectMake(0.0, IC_SCREEN_HEIGHT - self.contentView.frame.size.height, self.contentView.frame.size.width, self.contentView.frame.size.height);
    } completion:^(BOOL finished) {
        ;
    }];
}

- (void)hidden
{
    [UIView animateWithDuration:0.25 animations:^{
        self.contentButton.alpha = 0.0;
        self.contentView.frame = CGRectMake(0.0, IC_SCREEN_HEIGHT, self.contentView.frame.size.width, self.contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)didContentButtonClick:(id)sender
{
    [self hidden];
}

- (void)didActionSheetItemClick:(id)sender
{
    [self hidden];
    if (self.delegate && [self.delegate respondsToSelector:@selector(bnActionSheet:clickedButtonAtIndex:)])
    {
        UIButton *button = (UIButton *)sender;
        NSInteger index = button.tag - 100;
        [self.delegate bnActionSheet:self clickedButtonAtIndex:index];
    }
}


@end
