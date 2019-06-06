//
//  ProjectViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/6/12.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "BNSegmentedControl.h"

typedef enum kProjectViewType
{
    kProjectViewEdit            = kProjectItemDefault,      // 产品项目
    kProjectSelectConsumable    = kProjectItemConsumable,   // 项目消耗
    kProjectSelectSubItem       = kProjectItemSubItem,      // 组合清单
    kProjectSelectSameItem      = kProjectItemSameItem,     // 可替换项目
    kProjectSelectPurchase      = kProjectItemPurchase,     // 可采购项目
    kProjectSelectCardItem      = kProjectItemCardItem,     // 卡内项目
    kProjectSelectCardBuyItem   = kProjectItemCardBuyItem,  // 可购买项目
    kProjectSelectPanDianItem   = kProjectItemPanDianItem   // 盘点
}kProjectViewType;


@protocol ProjectItemPanDianDelegate <NSObject>

- (void)didAddPanDianWithProjectItem:(CDProjectItem *)item;
- (void)didDeletePanDianWithProjectItem:(CDProjectItem *)item;
- (void)didEditPanDianWithProjectItem:(CDProjectItem *)item withAmount:(NSInteger)amount;

@end


@interface ProjectViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, BNSegmentedControlDelegate, UITextFieldDelegate>

- (id)initWithViewType:(kProjectViewType)viewType existItemIds:(NSArray *)itemIds;
- (id)initWithViewType:(kProjectViewType)viewType projectType:(kPadBornCategoryType)projectType existItemIds:(NSArray *)itemIds;
- (id)initWithParams:(NSDictionary *)params delegate:(id<ProjectItemPanDianDelegate>)delegate;

@end
