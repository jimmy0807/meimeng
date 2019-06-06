//
//  ProductTypeCollectionHeadView.m
//  Boss
//
//  Created by jiangfei on 16/5/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ProductTypeCollectionHeadView.h"
#import "BSSearchBarView.h"

@interface ProductTypeCollectionHeadView ()<BSSearchBarViewDelegate>
{
    BSSearchBarView *searchBar;
}
@property (weak, nonatomic) IBOutlet UIImageView *statuesImage;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;


@end
@implementation ProductTypeCollectionHeadView

+ (instancetype)createView
{
    return [self loadFromNib];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
    searchBar = [BSSearchBarView createView];
    searchBar.delegate = self;
    searchBar.markBtnImgName = @"search_saoma";
    [self.searchView addSubview:searchBar];
    
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
   
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    searchBar.placeHolder = placeholder;
}

- (IBAction)statusChange:(UIButton *)sender {
    self.statuesImage.highlighted = !self.statuesImage.highlighted;
    
    if ([self.delegate respondsToSelector:@selector(didChangeBtnPressed:)]) {
        [self.delegate didChangeBtnPressed:self.statuesImage.highlighted];
    }

}


#pragma mark - BSSearchBarViewDelegate
- (void)didSearchWithText:(NSString *)text
{
    if ([self.delegate respondsToSelector:@selector(didSearchWithString:)]) {
        [self.delegate didSearchWithString:text];
    }
}

- (void)didMarkBtnPressed
{
    if ([self.delegate respondsToSelector:@selector(didScanBtnPressed)]) {
        [self.delegate didScanBtnPressed];
    }
}

@end
