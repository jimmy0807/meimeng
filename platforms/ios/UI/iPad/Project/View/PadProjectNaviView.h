//
//  PadProjectNaviView.h
//  Boss
//
//  Created by XiaXianBing on 15/10/12.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PadProjectData.h"
#import "PadProjectConstant.h"

@protocol PadProjectNaviViewDelegate <NSObject>

- (void)didNaviBackButtonClick:(id)sender;
- (void)didNaviTitleButtonClick:(id)sender;
- (void)didNaviCardItemButtonClick:(id)sender;
- (void)didNaviKeyboardButtonClick:(id)sender;
- (void)didNaviUserInfoButtonClick:(id)sender;
- (void)didNaviDeleteMemberInfoButtonClick:(id)sender;

@end

@interface PadProjectNaviView : UIView

@property (nonatomic, assign) id<PadProjectNaviViewDelegate> delegate;

- (void)reloadRemindInfoWithCount:(NSInteger)count;
- (void)reloadTitleWithData:(PadProjectData *)data;
- (void)reloadUserInfoWithData:(PadProjectData *)data;

- (void)didShowCardItemButton;
- (void)didHideCardItemButton;

@end
