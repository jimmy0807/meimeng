//
//  PadProjectSideView.h
//  Boss
//
//  Created by XiaXianBing on 15/10/10.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PadProjectData.h"
#import "PadProjectConstant.h"
#import "PadProjectSideCell.h"

@protocol PadProjectSideViewDelegate <NSObject>

- (void)isGuadanActive:(BOOL)isGuadan;
- (void)isAddItemActive:(BOOL)isAddItem;
- (void)didProjectSideCellClick:(CDPosProduct *)product;
- (void)didProjectSideCellDelete:(CDPosProduct *)product;
- (void)didProjectSideUseItemClick:(CDCurrentUseItem *)useItem;
- (void)didProjectSideUseItemDelete:(CDCurrentUseItem *)useItem;
- (void)didProjectSideSettleButtonClick:(CDPosOperate *)operate;

- (void)didProjectSideYiMeiLeftButtonPressed;
- (void)didProjectSideYiMeiRightButtonPressed;

@end

@interface PadProjectSideView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<PadProjectSideViewDelegate> delegate;
@property (nonatomic) BOOL isGuadanAddItem;
@property (nonatomic) BOOL isAddItem;
- (void)reloadProjectSideViewWithData:(PadProjectData *)data;
- (void)updateFrame;

@end
