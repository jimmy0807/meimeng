//
//  PrintSettingView.h
//  meim
//
//  Created by 波恩公司 on 2017/12/21.
//

#import <UIKit/UIKit.h>
#import "CBRotateNavigationController.h"

@class PrintSettingView;
@protocol PrintSettingViewDelegate <NSObject>

//- (void)didSaveButtonClick:(PrintSettingView *)settingView;

@end

@interface PrintSettingView : UIView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) CBRotateNavigationController *navi;
@property (nonatomic, weak) id<PrintSettingViewDelegate> delegate;

- (void)show;
- (void)hidden;
- (void)removeSubviews;

@end
