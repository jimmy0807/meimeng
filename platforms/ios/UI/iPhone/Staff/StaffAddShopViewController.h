//
//  StaffAddShopViewController.h
//  Boss
//
//  Created by mac on 15/7/13.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface StaffAddShopViewController : ICCommonViewController
@property (nonatomic,strong)NSMutableArray *shopInfoArray;
@property (nonatomic,strong)NSMutableArray *infoTypeArray;
@property (nonatomic,strong)NSMutableDictionary *keyValueDic;
@property (nonatomic,strong)NSMutableDictionary *params;
@property (nonatomic,strong)NSIndexPath *selectedIndexPath;
@property (nonatomic,strong)NSMutableDictionary *selectedList;
@end
