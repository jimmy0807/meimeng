//
//  HCustomerListHeadReusableView.m
//  meim
//
//  Created by jimmy on 2017/4/26.
//
//

#import "HCustomerListHeadReusableView.h"
#import "UIImage+Resizable.h"

@implementation HCustomerListHeadReusableView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.searchBar.layer.borderColor = COLOR(237, 237, 237, 1).CGColor;
    [self.searchBar setBackgroundImage:[[UIImage imageNamed:@"pad_search_bar_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)]];
    self.searchBar.returnKeyType = UIReturnKeySearch;
}

@end
