//
//  PadProjectHeaderView.m
//  Boss
//
//  Created by XiaXianBing on 15/10/13.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadProjectHeaderView.h"
#import "UIImage+Resizable.h"

@interface PadProjectHeaderView ()

@end

@implementation PadProjectHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
//        UIImageView *contentView = [[UIImageView alloc] initWithFrame:CGRectMake(16.0, 16.0, self.frame.size.width - 32.0, self.frame.size.height - 16.0)];
//        contentView.backgroundColor = [UIColor clearColor];
//        UIImage *searchBarImage = [[UIImage imageNamed:@"pad_search_bar_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(7.0, 20.0, 7.0, 20.0)];
//        contentView.image = searchBarImage;
        
        
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(16.0, 16.0, self.frame.size.width - 32.0, self.frame.size.height - 16.0)];
        UIImage *searchBarImage = [[UIImage imageNamed:@"pad_search_bar_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(7.0, 20.0, 7.0, 20.0)];
        [self.searchBar setBackgroundImage:searchBarImage];
        self.searchBar.contentMode = UIViewContentModeLeft;
        //[self.searchBar setSearchFieldBackgroundPositionAdjustment:UIOffsetMake(-64.0, 0.0)];
        //[self.searchBar setSearchTextPositionAdjustment:UIOffsetMake(32.0, 0.0)];
        //[self.searchBar setPositionAdjustment:UIOffsetMake(64.0, 0.0) forSearchBarIcon:UISearchBarIconSearch];
        self.searchBar.returnKeyType = UIReturnKeySearch;
        self.searchBar.delegate = self;
        [self addSubview:self.searchBar];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.backgroundColor = [UIColor clearColor];
        self.cancelButton.frame = CGRectMake(self.frame.size.width, 16.0 + 12.0, 56.0, self.frame.size.height - 16.0 - 2 * 12.0);
        [self.cancelButton setBackgroundImage:[[UIImage imageNamed:@"pad_setting_cell_n"] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)] forState:UIControlStateNormal];
        [self.cancelButton setBackgroundImage:[[UIImage imageNamed:@"pad_setting_cell_h"] imageResizableWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)] forState:UIControlStateHighlighted];
        [self.cancelButton setTitleColor:COLOR(136.0, 136.0, 136.0, 1.0) forState:UIControlStateNormal];
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self.cancelButton setTitle:LS(@"Cancel") forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(didCancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelButton];
        
    }
    
    return self;
}

- (void)setSearchBarText:(NSString *)text
{
    self.searchBar.text = text;
}

- (void)didCancelButtonClick:(id)sender
{
    [UIView animateWithDuration:0.24 animations:^{
        self.searchBar.frame = CGRectMake(self.searchBar.frame.origin.x, self.searchBar.frame.origin.y, self.frame.size.width - 32.0, self.searchBar.frame.size.height);
        self.cancelButton.frame = CGRectMake(self.frame.size.width, self.cancelButton.frame.origin.y, self.cancelButton.frame.size.width, self.cancelButton.frame.size.height);
    } completion:^(BOOL finished) {
        self.searchBar.text = @"";
        [self.searchBar resignFirstResponder];
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didProjectItemSearchBarCancelButtonClick)])
    {
        [self.delegate didProjectItemSearchBarCancelButtonClick];
    }
}


#pragma mark -
#pragma mark UISearchBarDelegate Methods

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didProjectItemSearchBarBeginEditing)])
    {
        [self.delegate didProjectItemSearchBarBeginEditing];
    }
    
    [UIView animateWithDuration:0.24 animations:^{
        self.searchBar.frame = CGRectMake(self.searchBar.frame.origin.x, self.searchBar.frame.origin.y, self.frame.size.width - 32.0 - 72.0, self.searchBar.frame.size.height);
        self.cancelButton.frame = CGRectMake(self.frame.size.width - 72.0, self.cancelButton.frame.origin.y, self.cancelButton.frame.size.width, self.cancelButton.frame.size.height);
    } completion:^(BOOL finished) {
        ;
    }];
    
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didProjectItemSearchBarSearch:)])
    {
        [self.delegate didProjectItemSearchBarSearch:searchBar.text];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didProjectItemSearchBarSearch:)])
    {
        [self.delegate didProjectItemSearchBarSearch:searchBar.text];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(didProjectItemSearchBarTextChanged:)])
//    {
//        [self.delegate didProjectItemSearchBarTextChanged:searchBar.text];
//    }
}

@end
