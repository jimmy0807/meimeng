//
//  ResposityViewController.h
//  Boss
//
//  Created by lining on 15/6/24.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

typedef enum SelectedType{
    SelectedType_resposity,  //仓库
    SelectedType_storage,    //仓位
}SelectedType;


@protocol PurchaseSelectedDelegate <NSObject>
@optional
-(void)didSelectedManageObject:(NSManagedObject *)object withType:(SelectedType)type;
@end

@interface PurchaseSelectedViewController : ICCommonViewController
@property(nonatomic, assign) SelectedType type;
@property(nonatomic, assign) id<PurchaseSelectedDelegate>delegate;
@property(nonatomic, strong) NSManagedObject *selectedObject;
@property(nonatomic, strong) CDPurchaseOrder *purchaseOrder;
@end
