//
//  BSSearchBarView.h
//  Boss
//
//  Created by lining on 16/10/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISearchBar+Placeholder.h"
@protocol BSSearchBarViewDelegate <NSObject>

@optional
- (void)didSearchWithText:(NSString *)text;
- (void)didMarkBtnPressed;

@end

@interface BSSearchBarView : UIView<UISearchBarDelegate>

+ (instancetype)createView;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) id<BSSearchBarViewDelegate>delegate;
@property (strong, nonatomic) NSString *placeHolder;
@property (strong, nonatomic) NSString *markBtnImgName;
- (void)endSearch;
@end
