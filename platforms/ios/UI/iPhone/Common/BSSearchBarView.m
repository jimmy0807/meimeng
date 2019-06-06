//
//  BSSearchBarView.m
//  Boss
//
//  Created by lining on 16/10/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSSearchBarView.h"

@implementation BSSearchBarView

+ (instancetype)createView
{
    return [self loadFromNib];
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.searchBar.delegate = self;
    [self.searchBar setBackgroundImage:[self getImageWithColor:COLOR(245, 245, 245, 1)]];
    
    [self.searchBar setHasCentredPlaceholder:false];
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    self.searchBar.placeholder = placeHolder;
}

- (void)endSearch
{
    self.searchBar.text = nil;
    [self.searchBar resignFirstResponder];
    self.searchBar.showsCancelButton = false;
}

- (void)setMarkBtnImgName:(NSString *)markBtnImgName
{
    UIImage *markImg = [UIImage imageNamed:markBtnImgName];
    if (markImg != nil) {
        [self.searchBar setImage:markImg forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
        self.searchBar.showsBookmarkButton = true;
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = true;
    
    
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancelBtn =(UIButton *)view;
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            [cancelBtn setTitleColor:COLOR(0, 148, 288, 1) forState:UIControlStateNormal];
        }
    }
}

//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
//{
//    if ([self.delegate respondsToSelector:@selector(didSearchWithText:)]) {
//        [self.delegate didSearchWithText:searchBar.text];
//    }
//
//}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancelBtn =(UIButton *)view;
            cancelBtn.enabled = true;
        }
    }
    if ([self.delegate respondsToSelector:@selector(didSearchWithText:)]) {
        [self.delegate didSearchWithText:searchBar.text];
    }
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = nil;
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = false;
    if ([self.delegate respondsToSelector:@selector(didSearchWithText:)]) {
        [self.delegate didSearchWithText:searchBar.text];
    }
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    if ([self.delegate respondsToSelector:@selector(didMarkBtnPressed)]) {
        [self.delegate didMarkBtnPressed];
    }
}



- (UIImage *)getImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 10, 10);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

@end
