//
//  GiveCouponSelectedProductViewController.h
//  Boss
//
//  Created by lining on 16/9/22.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@protocol CouponSelectedProjectDelegate <NSObject>
- (void)didSureSeletedItems:(NSArray *)items;
@end

@interface GiveCouponSelectedProductViewController : ICCommonViewController
@property (strong, nonatomic) NSArray *existIds;
@property (strong, nonatomic) NSArray *itemArray;
@property (strong, nonatomic) NSMutableArray *selectedItems;
@property (Weak, nonatomic) id<CouponSelectedProjectDelegate>delegate;
@end
