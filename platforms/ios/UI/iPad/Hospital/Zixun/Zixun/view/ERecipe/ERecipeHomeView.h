//
//  ERecipeHomeView.h
//  meim
//
//  Created by 波恩公司 on 2018/3/19.
//

#import <UIKit/UIKit.h>

@interface ERecipeHomeView : UIView

@property(nonatomic, strong)IBOutlet UIButton *confirmButton;
@property(nonatomic, strong)IBOutlet UIView *searchView;
@property(nonatomic, strong)UISearchBar *searchBar;
- (void)show;
//- (void)hide;
@end
