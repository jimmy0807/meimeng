//
//  MemberFilterView.m
//  Boss
//
//  Created by lining on 16/5/17.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "FilterView.h"
#import "FilterMonthDataSource.h"

@interface FilterView ()<FilterItemViewDelegate>
{
    FilterItemView *currentItemView;
    
    UIScrollView *scrollView;
    UIView *containerView;
   
}

@end

@implementation FilterView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initView];
}

- (void)initView
{
    self.filterTitles = @[FilterTypeBirthday,FilterTypeGuwen,FilterTypeShopCount,FilterTypeHuoyue,FilterTypeYue,FilterTypeChongzhi,FilterTypeConsume,FilterTypeZhuce];
    scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = false;
    scrollView.showsVerticalScrollIndicator = false;
    scrollView.bounces = false;
    scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:scrollView];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
    containerView = [[UIView alloc] init];
    
    containerView.backgroundColor = [UIColor redColor];
    [scrollView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
        make.height.equalTo(scrollView.mas_height);
    }];
    
    UIImageView *filterView1 = [[UIImageView alloc] init];
    filterView1.image = [UIImage imageNamed:@"member_filter_bg1.png"];
    filterView1.userInteractionEnabled = true;
    filterView1.backgroundColor = [UIColor clearColor];
    [containerView addSubview:filterView1];
    
    [filterView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(0);
        make.top.leading.offset(0);
        make.width.equalTo(scrollView.mas_width);
        make.bottom.leading.offset(0);
    }];
    
    UIImageView *filterView2 = [[UIImageView alloc] init];
    filterView2.userInteractionEnabled = true;
    filterView2.image = [UIImage imageNamed:@"member_filter_bg2.png"];
    [containerView addSubview:filterView2];
    
    [filterView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(filterView1.mas_trailing);
        make.trailing.offset(0);
        make.top.offset(0);
//        make.width;
        make.bottom.offset(0);
        make.width.equalTo(filterView1);
    }];
    
    UIView *lastView1, *lastView2;
    
    for (int i = 0; i< self.filterTitles.count; i++) {
        NSString *title = self.filterTitles[i];
        FilterItemView *itemView = nil;
        if (i < 4) {
            if ([title isEqualToString:FilterTypeHuoyue]) {
                itemView =[[FilterItemView alloc] initWithTitle:title imgName:@"member_filter_frame_n.png" selectedImgName:@"member_filter_frame_h.png"];
            }
            else
            {
                itemView = [[FilterItemView alloc] initWithTitle:title];
            }
            
            [filterView1 addSubview:itemView];
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                make.bottom.offset(0);
                if (lastView1 == nil) {
                    make.leading.offset(0);
                }
                else
                {
                    make.leading.equalTo(lastView1.mas_trailing).offset(0);
                    make.width.equalTo(lastView1);
                }
            }];
            
            lastView1 = itemView;
            
            if (i == 3) {
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.trailing .offset(0);
                }];
            }
        }
        else
        {
            itemView = [[FilterItemView alloc] initWithTitle:title];
            [filterView2 addSubview:itemView];
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                make.bottom.offset(0);
                if (lastView2 == nil) {
                    make.leading.offset(0);
                }
                else
                {
                    make.leading.equalTo(lastView2.mas_trailing).offset(0);
                    make.width.equalTo(lastView2);
                }
            }];
            lastView2 = itemView ;
            
            if (i == 7) {
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.trailing.offset(0);
                }];
            }
        }
//        itemView.backgroundColor = [UIColor redColor];
        itemView.tagString = title;
        itemView.delegate = self;
    }
}


#pragma mark - FilterItemViewDelegate
- (void)didArrowBtnPressed:(FilterItemView *)itemView
{
    if ([self.delegate respondsToSelector:@selector(didFilterItemViewPressed:)]) {
        [self.delegate didFilterItemViewPressed:itemView];
    }
    
    if (![currentItemView.tagString isEqualToString:itemView.tagString]) {
        currentItemView.normalBtn.selected = false;
        itemView.normalBtn.selected = true;
        currentItemView = itemView;
    }
}

- (void)didCancelSelectedBtnPressed:(FilterItemView *)itemView
{
    NSLog(@"cancel tag: %@",itemView.tagString);
    if ([self.delegate respondsToSelector:@selector(didCancelFilterItemSelected:)]) {
        [self.delegate didCancelFilterItemSelected:itemView];
    }
}



#pragma mark - UITableViewDataSource


#pragma mark - UITableViewDelegateSouce


@end
