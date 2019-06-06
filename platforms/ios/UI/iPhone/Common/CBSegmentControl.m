//
//  CBSegmentControl.m
//  Boss
//
//  Created by lining on 15/6/15.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "CBSegmentControl.h"
#import "UIImage+Resizable.h"

#define kStart_Tag  101

#define NORMAL_COLOR    COLOR(11.0, 169.0, 250.0, 1.0)
#define SELECTED_COLOR  [UIColor whiteColor]


@interface CBButton : UIButton
@end
@implementation CBButton
-(void)setHighlighted:(BOOL)highlighted{}
@end


@implementation CBSegmentControl

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        
        int count = titles.count;
        
        CGFloat itemWidth = floor(frame.size.width / count);    //防止itemWidth不是整数
        CGFloat xCoord = floor((frame.size.width - itemWidth * count)/2.0);
        
        for (int i = 0; i < count; i++) {
            UIImage *normalImg = nil;
            UIImage *selectedImg = nil;
            if (i == 0) {
                normalImg = [[UIImage imageNamed:@"segmented_left_n.png"]imageResizableWithCapInsets:UIEdgeInsetsMake(10,10,10,10)];
                selectedImg = [[UIImage imageNamed:@"segmented_left_h.png"]imageResizableWithCapInsets:UIEdgeInsetsMake(10,10,10,10)];
            }
            else if (i == count-1)
            {
                normalImg = [[UIImage imageNamed:@"segmented_right_n.png"]imageResizableWithCapInsets:UIEdgeInsetsMake(10,10,10,10)];
                selectedImg = [[UIImage imageNamed:@"segmented_right_h.png"]imageResizableWithCapInsets:UIEdgeInsetsMake(10,10,10,10)];
            }
            else
            {
                normalImg = [[UIImage imageNamed:@"segmented_middle_n.png"] imageResizableWithCapInsets:UIEdgeInsetsMake(10,10,10,10)];
                selectedImg = [[UIImage imageNamed:@"segmented_middle_h.png"]imageResizableWithCapInsets:UIEdgeInsetsMake(10,10,10,10)];
            }
            
            CBButton *button = [CBButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(xCoord+i*itemWidth, (frame.size.height - normalImg.size.height)/2.0, itemWidth,normalImg.size.height);
            button.tag = kStart_Tag +  i;
            [button addTarget:self action:@selector(didButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:normalImg forState:UIControlStateNormal];
            [button setBackgroundImage:selectedImg forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitleColor:NORMAL_COLOR forState:UIControlStateNormal];
            [button setTitleColor:SELECTED_COLOR forState:UIControlStateSelected];
            button.autoresizingMask = 0xff;
            [self addSubview:button];
        }
        
        self.selectedIdx = 0;
    }
   
    return self;
}

-(void)setSelectedIdx:(NSInteger)selectedIdx
{
    UIButton *preBtn = (UIButton *)[self viewWithTag:kStart_Tag + _selectedIdx];
    preBtn.selected = false;
    
    _selectedIdx = selectedIdx;
    
    UIButton *selectedBtn = (UIButton *)[self viewWithTag:kStart_Tag + _selectedIdx];
    selectedBtn.selected = true;
}

-(void)didButtonPressed:(UIButton *)btn
{
    int idx = btn.tag - kStart_Tag;
    if (self.selectedIdx == idx) {
        return;
    }
    else
    {
        self.selectedIdx = idx;
        if ([self.delegate respondsToSelector:@selector(didSegmentCotrolSelectedAtIndex:)]) {
            [self.delegate didSegmentCotrolSelectedAtIndex:self.selectedIdx];
        }
    
    }
}


@end
