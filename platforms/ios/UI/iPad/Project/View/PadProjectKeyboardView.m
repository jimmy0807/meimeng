//
//  PadProjectKeyboardView.m
//  Boss
//
//  Created by XiaXianBing on 15/10/14.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadProjectKeyboardView.h"
#import "UIImage+Resizable.h"

#define kPadKeyboardItemWidth   172.0
#define kPadKeyboardItemHeight  132.0

@interface PadProjectKeyboardView ()
{
    BOOL isPointExist;
}

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *screenView;
@property (nonatomic, strong) UILabel *screenLabel;
@property (nonatomic, assign) id<PadProjectKeyboardViewDelegate> delegate;

@end

@implementation PadProjectKeyboardView

- (id)initWithFrame:(CGRect)frame delegate:(id<PadProjectKeyboardViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.delegate = delegate;
        self.currentstr = [NSMutableString string];
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - (4 * kPadKeyboardItemWidth - 1.0))/2.0 - 1.5, (self.frame.size.height - (5 * kPadKeyboardItemHeight - 1.0))/2.0 - 0.5, 4 * kPadKeyboardItemWidth - 1.0 + 3.0, 5 * kPadKeyboardItemHeight - 1.0 + 3.5)];
        background.backgroundColor = [UIColor clearColor];
        background.image = [[UIImage imageNamed:@"pad_keyboard_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(24.0, 24.0, 24.0, 24.0)];
        background.userInteractionEnabled = YES;
        [self addSubview:background];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(1.5, 0.5, background.frame.size.width - 3.0 , background.frame.size.height - 3.5)];
        self.contentView.backgroundColor = [UIColor clearColor];
        [background addSubview:self.contentView];
        
        self.screenView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.contentView.frame.size.width, kPadKeyboardItemHeight)];
        self.screenView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.screenView];
        
        UIImage *symbolImage = [UIImage imageNamed:@"pad_money_symbol"];
        UIImageView *symbolImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, (self.screenView.frame.size.height - symbolImage.size.height)/2.0, symbolImage.size.width, symbolImage.size.height)];
        symbolImageView.backgroundColor = [UIColor clearColor];
        symbolImageView.image = symbolImage;
        [self.screenView addSubview:symbolImageView];
        
        self.screenLabel = [[UILabel alloc] initWithFrame:CGRectMake(symbolImage.size.width + 20.0, 0.0, self.screenView.frame.size.width - symbolImage.size.width - 20.0, self.screenView.frame.size.height)];
        self.screenLabel.backgroundColor = [UIColor clearColor];
        self.screenLabel.font = [UIFont systemFontOfSize:60.0];
        self.screenLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
        [self.screenView addSubview:self.screenLabel];
        
        CGFloat originY = kPadKeyboardItemHeight - 1.0;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, originY, self.contentView.frame.size.width, 1.0)];
        lineView.backgroundColor = COLOR(220.0, 224.0, 224.0, 1.0);
        [self.contentView addSubview:lineView];
        originY += kPadKeyboardItemHeight;
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, originY, 4 * kPadKeyboardItemWidth, 1.0)];
        lineView.backgroundColor = COLOR(220.0, 224.0, 224.0, 1.0);
        [self.contentView addSubview:lineView];
        originY += kPadKeyboardItemHeight;
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, originY, 3 * kPadKeyboardItemWidth, 1.0)];
        lineView.backgroundColor = COLOR(220.0, 224.0, 224.0, 1.0);
        [self.contentView addSubview:lineView];
        originY += kPadKeyboardItemHeight;
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, originY, 4 * kPadKeyboardItemWidth, 1.0)];
        lineView.backgroundColor = COLOR(220.0, 224.0, 224.0, 1.0);
        [self.contentView addSubview:lineView];
        originY += kPadKeyboardItemHeight;
        
        originY = kPadKeyboardItemHeight;
        CGFloat originX = kPadKeyboardItemWidth - 1.0;
        lineView = [[UIView alloc] initWithFrame:CGRectMake(originX, originY, 1.0, 3 * kPadKeyboardItemHeight)];
        lineView.backgroundColor = COLOR(220.0, 224.0, 224.0, 1.0);
        [self.contentView addSubview:lineView];
        originX += kPadKeyboardItemWidth;
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(originX, originY, 1.0, self.contentView.frame.size.height - kPadKeyboardItemHeight)];
        lineView.backgroundColor = COLOR(220.0, 224.0, 224.0, 1.0);
        [self.contentView addSubview:lineView];
        originX += kPadKeyboardItemWidth;
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(originX, originY, 1.0, self.contentView.frame.size.height - kPadKeyboardItemHeight)];
        lineView.backgroundColor = COLOR(220.0, 224.0, 224.0, 1.0);
        [self.contentView addSubview:lineView];
        
        UIButton *button;
        for (int i = 0; i < 3; i++)
        {
            originY = (i + 1) * kPadKeyboardItemHeight;
            for (int j = 0; j < 3; j++)
            {
                originX = j * kPadKeyboardItemWidth;
                button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(originX, originY, kPadKeyboardItemWidth - 1.0, kPadKeyboardItemHeight - 1.0);
                button.backgroundColor = [UIColor clearColor];
                button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [button setBackgroundImage:[UIImage imageNamed:@"pad_keyboard_button_n"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"pad_keyboard_button_h"] forState:UIControlStateHighlighted];
                [button.titleLabel setFont:[UIFont systemFontOfSize:44.0]];
                [button setTitleColor:COLOR(136.0, 136.0, 136.0, 1.0) forState:UIControlStateNormal];
                [button setTitle:[NSString stringWithFormat:@"%d", i * 3 + j + 1] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(didKeyboardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = i * 3 + j + 1;
                [self.contentView addSubview:button];
            }
        }
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0, 4 * kPadKeyboardItemHeight, kPadKeyboardItemWidth * 2 - 1.0, kPadKeyboardItemHeight - 1.0);
        button.backgroundColor = [UIColor clearColor];
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [button setBackgroundImage:[UIImage imageNamed:@"pad_keyboard_button_n"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"pad_keyboard_button_h"] forState:UIControlStateHighlighted];
        [button.titleLabel setFont:[UIFont systemFontOfSize:44.0]];
        [button setTitleColor:COLOR(136.0, 136.0, 136.0, 1.0) forState:UIControlStateNormal];
        [button setTitle:@"0" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didKeyboardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 0;
        [self.contentView addSubview:button];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(2 * kPadKeyboardItemWidth, 4 * kPadKeyboardItemHeight, kPadKeyboardItemWidth - 1.0, kPadKeyboardItemHeight - 1.0);
        button.backgroundColor = [UIColor clearColor];
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [button setBackgroundImage:[UIImage imageNamed:@"pad_keyboard_button_n"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"pad_keyboard_button_h"] forState:UIControlStateHighlighted];
        [button.titleLabel setFont:[UIFont systemFontOfSize:44.0]];
        [button setTitleColor:COLOR(136.0, 136.0, 136.0, 1.0) forState:UIControlStateNormal];
        [button setTitle:@"." forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didKeyboardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10;
        [self.contentView addSubview:button];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(3 * kPadKeyboardItemWidth, kPadKeyboardItemHeight, kPadKeyboardItemWidth - 1.0, kPadKeyboardItemHeight - 1.0);
        button.backgroundColor = [UIColor clearColor];
        [button setBackgroundImage:[UIImage imageNamed:@"pad_keyboard_button_n"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"pad_keyboard_button_h"] forState:UIControlStateHighlighted];
        [button.titleLabel setFont:IOS7FONT(24.0)];
        [button setTitle:LS(@"PadKeyboardDeleteButton") forState:UIControlStateNormal];
        [button setTitleColor:COLOR(136.0, 136.0, 136.0, 1.0) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didKeyboardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 11;
        [self.contentView addSubview:button];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(3 * kPadKeyboardItemWidth, 2 * kPadKeyboardItemHeight, kPadKeyboardItemWidth - 1.0, 2 * kPadKeyboardItemHeight - 1.0);
        button.backgroundColor = [UIColor clearColor];
        [button.titleLabel setFont:IOS7FONT(24.0)];
        [button setTitle:LS(@"PadKeyboardAddButton") forState:UIControlStateNormal];
        [button setTitleColor:COLOR(90.0, 211.0, 213.0, 1.0) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didKeyboardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"pad_keyboard_button_n"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"pad_keyboard_button_h"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(didKeyboardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 12;
        [self.contentView addSubview:button];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(3 * kPadKeyboardItemWidth, 4 * kPadKeyboardItemHeight, kPadKeyboardItemWidth - 1.0, kPadKeyboardItemHeight - 1.0);
        button.backgroundColor = [UIColor clearColor];
        [button setBackgroundImage:[UIImage imageNamed:@"pad_keyboard_button_n"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"pad_keyboard_button_h"] forState:UIControlStateHighlighted];
        [button.titleLabel setFont:IOS7FONT(24.0)];
        [button setTitle:LS(@"PadKeyboardCloseButton") forState:UIControlStateNormal];
        [button setTitleColor:COLOR(255.0, 110.0, 100.0, 1.0) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didKeyboardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 13;
        [self.contentView addSubview:button];
        
        [self reloadKeyboardScreenLabel];
    }
    
    return self;
}

- (void)reloadKeyboardScreenLabel
{
    self.screenLabel.text = self.currentstr;
    CGSize minSize = [self.screenLabel.text sizeWithFont:self.screenLabel.font forWidth:(self.contentView.frame.size.width - 64.0) lineBreakMode:NSLineBreakByCharWrapping];
    self.screenLabel.frame = CGRectMake(self.screenLabel.frame.origin.x, self.screenLabel.frame.origin.y, (minSize.width <= self.contentView.frame.size.width - 64.0 - self.screenLabel.frame.origin.x) ? minSize.width : (self.contentView.frame.size.width - 64.0 - self.screenLabel.frame.origin.x), self.screenLabel.frame.size.height);
    self.screenView.frame = CGRectMake(self.contentView.frame.size.width - 32.0 - self.screenLabel.frame.size.width - self.screenLabel.frame.origin.x, self.screenView.frame.origin.y, self.screenLabel.frame.origin.x + self.screenLabel.frame.size.width, self.screenView.frame.size.height);
}

- (void)didKeyboardButtonClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    switch (button.tag)
    {
        case 0:
        {
            if ([self.currentstr isEqualToString:@""])
            {
                self.currentstr = [NSMutableString stringWithFormat:@"%d", button.tag];
                [self reloadKeyboardScreenLabel];
            }
            else if ([self.currentstr isEqualToString:@"0"])
            {
                ;
            }
            else
            {
                if (isPointExist)
                {
                    if (self.currentstr.length < 4)
                    {
                        [self.currentstr appendFormat:@"%d", button.tag];
                        [self reloadKeyboardScreenLabel];
                    }
                    else
                    {
                        NSRange range = [self.currentstr rangeOfString:@"."];
                        if (range.location > self.currentstr.length - 1 - 2)
                        {
                            [self.currentstr appendFormat:@"%d", button.tag];
                            [self reloadKeyboardScreenLabel];
                        }
                    }
            
                }
                else
                {
                    [self.currentstr appendFormat:@"%d", button.tag];
                    [self reloadKeyboardScreenLabel];
                }
            }
        }
            break;
            
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        {
            if ([self.currentstr isEqualToString:@"0"])
            {
                self.currentstr = [NSMutableString stringWithFormat:@"%d", button.tag];
                [self reloadKeyboardScreenLabel];
            }
            else
            {
                if (isPointExist)
                {
                    if (self.currentstr.length < 4)
                    {
                        [self.currentstr appendFormat:@"%d", button.tag];
                        [self reloadKeyboardScreenLabel];
                    }
                    else
                    {
                        NSRange range = [self.currentstr rangeOfString:@"."];
                        if (range.location > self.currentstr.length - 1 - 2)
                        {
                            [self.currentstr appendFormat:@"%d", button.tag];
                            [self reloadKeyboardScreenLabel];
                        }
                    }
                    
                }
                else
                {
                    [self.currentstr appendFormat:@"%d", button.tag];
                    [self reloadKeyboardScreenLabel];
                }
            }
        }
            break;
            
        case 10:
        {
            if (!isPointExist)
            {
                isPointExist = YES;
                [self.currentstr appendString:@"."];
                [self reloadKeyboardScreenLabel];
            }
        }
            break;
            
        case 11:
        {
            if (self.currentstr.length > 1)
            {
                if ([[self.currentstr substringFromIndex:self.currentstr.length - 1] isEqualToString:@"."])
                {
                    isPointExist = NO;
                }
                NSString *substr = [self.currentstr substringToIndex:self.currentstr.length - 1];
                self.currentstr = [NSMutableString stringWithString:substr];
            }
            else
            {
                self.currentstr = [NSMutableString string];
            }
            [self reloadKeyboardScreenLabel];
        }
            break;
            
        case 12:
        {
            isPointExist = NO;
            if (self.currentstr.floatValue != 0 && self.delegate && [self.delegate respondsToSelector:@selector(addServiceWithAmount:)])
            {
                [self.delegate addServiceWithAmount:self.currentstr.floatValue];
            }
            self.currentstr = [NSMutableString stringWithString:@"0"];
            [self reloadKeyboardScreenLabel];
        }
            break;
            
        case 13:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didKeyboardViewClose:)])
            {
                [self.delegate didKeyboardViewClose:self];
            }
        }
            break;
            
        default:
            break;
    }
}

@end
