//
//  ERecipeHomeView.m
//  meim
//
//  Created by 波恩公司 on 2018/3/19.
//

#import "ERecipeHomeView.h"
#import "UIImage+Resizable.h"

//@interface ERecipeHomeView ()
//{
//    NSInteger oringalCount;
//}
//
//@end

@implementation ERecipeHomeView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 1024, 768)];
    
    if ( self )
    {
        self = [ERecipeHomeView loadFromNib];
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(102.0, 0.0, 376.0, 36.0)];
//        UIImage *searchBarImage = [[UIImage imageNamed:@"pad_search_bar_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(7.0, 20.0, 7.0, 20.0)];
//        [self.searchBar setBackgroundImage:searchBarImage];
        self.searchBar.backgroundColor = COLOR(241, 241, 243, 1);
        self.searchBar.contentMode = UIViewContentModeLeft;
        //[self.searchBar setSearchFieldBackgroundPositionAdjustment:UIOffsetMake(-64.0, 0.0)];
        //[self.searchBar setSearchTextPositionAdjustment:UIOffsetMake(32.0, 0.0)];
        //[self.searchBar setPositionAdjustment:UIOffsetMake(64.0, 0.0) forSearchBarIcon:UISearchBarIconSearch];
        self.searchBar.returnKeyType = UIReturnKeySearch;
        self.searchBar.delegate = self;
        self.searchBar.clipsToBounds = YES;
        NSLog(@"%@",self.searchBar.subviews);
        UIView *firstSubView = self.searchBar.subviews.firstObject;
        NSLog(@"%@",firstSubView.subviews);
        UIView *backgroundImageView = [firstSubView.subviews firstObject];
        [backgroundImageView removeFromSuperview];
        UIView *searchBarTextField = [[self.searchBar.subviews.firstObject subviews] firstObject];
        searchBarTextField.layer.borderWidth = 0;
        searchBarTextField.backgroundColor = COLOR(241, 241, 243, 1);
        [self.searchView addSubview:self.searchBar];
    }
    
    return self;
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (IBAction)hide:(id)sender
{
    [self removeFromSuperview];
}
@end
