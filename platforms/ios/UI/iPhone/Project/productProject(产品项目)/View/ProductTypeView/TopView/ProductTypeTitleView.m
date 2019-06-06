//
//  ProductTypeTitleBtnsView.m
//  Boss
//
//  Created by jiangfei on 16/5/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ProductTypeTitleView.h"
#import "ProductTypeTitleBtn.h"
#import "BSImageButton.h"

#define kStartTag   1000

@interface ProductTypeTitleView ()
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) NSArray *categorys;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ProductTypeTitleView

- (instancetype)initWithCategorys:(NSArray *)categorys
{
    self = [super init];
    if (self) {
        self.backgroundColor = AppThemeColor;
        self.scrollView = [[UIScrollView alloc] init];
        [self addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsZero);
        }];
        self.scrollView.showsHorizontalScrollIndicator = false;
        self.scrollView.showsVerticalScrollIndicator = false;
        
        [self reloadWithCategorys:categorys];
        _selectedIdx = -1;
    }
    return self;
}


- (void)setSelectedIdx:(NSInteger)selectedIdx
{
    if (_selectedIdx == selectedIdx) {
        [self selectedBornCategory];
        return;
    }
    
    UIButton *preBtn = [self viewWithTag:kStartTag + _selectedIdx];
    preBtn.selected = false;
    
    UIButton *btn = [self viewWithTag:kStartTag + selectedIdx];
    btn.selected = true;
    _selectedIdx = selectedIdx;
    
    [self selectedBornCategory];
}

- (void)selectedBornCategory
{
    if (self.categorys.count == 0) {
        return;
    }
    NSObject *category = [self.categorys objectAtIndex:_selectedIdx];
    NSLog(@"category: %@",category);
    
    if ([category isKindOfClass:[CDBornCategory class]]) {
        CDBornCategory *bornCategoray = (CDBornCategory *)category;
        if ([self.delegate respondsToSelector:@selector(didSelectedBornCategory:)]) {
            [self.delegate didSelectedBornCategory:bornCategoray];
        }
    }
    else
    {
        NSString *categoryString = (NSString *)category;
        if ([categoryString isEqualToString:@"全部"]) {
            if ([self.delegate respondsToSelector:@selector(didSelectedBornCategory:)]) {
                [self.delegate didSelectedBornCategory:nil];
            }
        }
        else if ([categoryString isEqualToString:@"卡内项目"])
        {
            if ([self.delegate respondsToSelector:@selector(didSelectedCardItem)]) {
                [self.delegate didSelectedCardItem];
            }
        }
    }

}

- (void)reloadWithCategorys:(NSArray *)categorys
{
    self.categorys = categorys;

    for (UIView *subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
        make.height.equalTo(self.mas_height);
    }];
    
    NSInteger categoryCount = self.categorys.count;
    if (categoryCount == 0) {
        return;
    }
    
    CGFloat width = (IC_SCREEN_WIDTH/MIN(categoryCount,6));
    BSImageButton *lastBtn = nil;
    for (int i = 0; i < categorys.count; i++) {
        NSObject *category = categorys[i];
        
        NSString *title = nil;
        NSString *normalImageName = nil;
        NSString *selectedImageName = nil;
        if ([category isKindOfClass:[CDBornCategory class]]) {
            CDBornCategory *bornCategory = (CDBornCategory *)category;
            title = bornCategory.bornCategoryName;
            normalImageName = [NSString stringWithFormat:@"BornCategoryCode_%02d_n.png",bornCategory.code.integerValue];
            selectedImageName = [NSString stringWithFormat:@"BornCategoryCode_%02d_h.png",bornCategory.code.integerValue];
        }
        else
        {
            title = (NSString *)category;
            normalImageName = [NSString stringWithFormat:@"BornCategoryCode_%@_n.png",title];
            selectedImageName = [NSString stringWithFormat:@"BornCategoryCode_%@_h.png",title];
        }
//        NSString *namePrefix = [self imageNamePrefixWithCategory:category.integerValue];
        BSImageButton *button = [[BSImageButton alloc] initWithTitle:title normalImageName:normalImageName selectedImageName:selectedImageName];
        button.imageStyle = ImageStyle_Top;
        button.padding = 5;
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        float titleWidth = [title sizeWithFont:[UIFont systemFontOfSize:14.0f]].width;
//        float btnWidth = MAX(titleWidth + 25, width);//图片的宽度为25
        float btnWidth = MAX(titleWidth, width);
        
        [button setTitleColor:COLOR(255, 255, 255, 0.5) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [containerView addSubview:button];
        
//        button.imageView.backgroundColor = [UIColor orangeColor];
//        button.titleLabel.backgroundColor = [UIColor redColor];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.bottom.offset(0);
            make.width.equalTo(@(btnWidth));
            if (lastBtn) {
                make.leading.equalTo(lastBtn.mas_trailing).offset(0);
            }
            else
            {
                make.leading.offset(0);
            }
        }];
        
        if (self.selectedIdx == i) {
            button.selected = true;
        }
        button.tag = kStartTag + i;
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        lastBtn = button;
        
        [self.btns addObject:button];
    }
    
    [lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.offset(0);
    }];

}

- (void)buttonPressed:(UIButton *)btn
{
    self.selectedIdx = btn.tag - kStartTag;
}


@end
