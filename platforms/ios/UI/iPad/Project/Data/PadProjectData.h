//
//  PadProjectData.h
//  Boss
//
//  Created by XiaXianBing on 15/10/26.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PadProjectCart.h"
#import "PadProjectConstant.h"

@interface PadProjectData : NSObject

@property (nonatomic, assign) BOOL isCardItem;
@property (nonatomic, assign) NSInteger cardItemCount;
@property (nonatomic, strong) NSMutableArray *cardItems;
@property (nonatomic, strong) NSArray *types;
@property (nonatomic, strong) CDBornCategory *bornCategory;//最外面的一层
@property (nonatomic, assign) kPadProjectResultType resultType;

@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic, assign) BOOL isCustomPrice;//定制价格
@property (nonatomic, assign) BOOL isDefaultCode;
@property (nonatomic, strong) NSArray *existItemIds;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, assign) BOOL isPriceSortASC;
@property (nonatomic, strong) NSArray *projectArray;
@property (nonatomic, strong) CDProjectCategory *currentCategory;//当前选的那层
@property (nonatomic, strong) NSArray *subCategoryArray;//当前选的那的子category
@property (nonatomic, strong) CDPosOperate *posOperate;
@property (nonatomic, assign) kPadProjectPosOperateType operateType;
@property (nonatomic, strong) CDMemberCard *memberCard;
@property (nonatomic, strong) CDCouponCard *couponCard;

@property (nonatomic) BOOL isOnlyParent;//其他

- (void)reloadPosOperate;
- (void)reloadProjectItem;
- (void)reloadOnlyParantProjectItem;
- (void)reloadProjectItemWithBornCategory:(CDBornCategory *)bornCategory;
- (void)reloadProjectItemWithKeyword:(NSString *)keyword;

- (CDPosProduct *)didAddPosOperateWithProjectItem:(CDProjectItem *)item;
- (CDPosProduct *)didAddPosOperateWithProjectItem:(CDProjectItem *)item withUseCount:(NSInteger)useCount;//进入详情里面修改数量后调用
- (CDCurrentUseItem *)didAddPosOperateWithCart:(PadProjectCart *)cart;
- (CDCurrentUseItem *)didAddPosOperateWithMemberCardProject:(CDMemberCardProject *)project;
- (CDCurrentUseItem *)didAddPosOperateWithCouponCardProduct:(CDCouponCardProduct *)product;

- (void)relaodBornCategories;

@end
