//
//  ApproveDetailViewController.h
//  Boss
//  审核页
//  Created by lining on 15/6/29.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

typedef enum kApproveType
{
    kType_approving,
    kType_done
}kApproveType;

@interface ApproveDetailViewController : ICCommonViewController
@property(nonatomic, strong)CDPurchaseOrder *purchaseOrder;
@property(nonatomic, assign) kApproveType type;
@end
