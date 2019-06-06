//
//  PadProjectHeaderView.h
//  Boss
//
//  Created by XiaXianBing on 15/10/13.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PadProjectHeaderViewDelegate <NSObject>

- (void)didProjectItemSearchBarBeginEditing;
- (void)didProjectItemSearchBarCancelButtonClick;
- (void)didProjectItemSearchBarSearch:(NSString *)keyword;
- (void)didProjectItemSearchBarTextChanged:(NSString *)keyword;

@end

@interface PadProjectHeaderView : UICollectionReusableView <UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, assign) id<PadProjectHeaderViewDelegate> delegate;

- (void)setSearchBarText:(NSString *)text;

@end
