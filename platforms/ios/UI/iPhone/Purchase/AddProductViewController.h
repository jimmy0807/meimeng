//
//  AddProductViewController.h
//  Boss
//
//  Created by lining on 15/6/23.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#define kEidtOrderLine      @"kEidtOrderLine"
#define kCreateOrderLine    @"kCreateOrderLine"

@class AddProductViewController;
@protocol AddProductViewControllerDelegate <NSObject>
@optional
-(void)didSureBtnPressed:(AddProductViewController *)viewController;
@end

@interface AddProductViewController : ICCommonViewController
@property(nonatomic, strong) CDPurchaseOrder *purchaseOrder;

@property(nonatomic, assign) id<AddProductViewControllerDelegate>delegate;
@property(nonatomic, strong) NSMutableArray *orderLines;


@end
