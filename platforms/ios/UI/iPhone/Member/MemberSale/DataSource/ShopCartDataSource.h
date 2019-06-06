//
//  ShopCartDataSource.h
//  Boss
//
//  Created by lining on 16/7/25.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ShopCartDataSouceDelegate <NSObject>

@optional
- (void)didSelectedPosproduct:(CDPosProduct *)product;
- (void)didSelectedUseItem:(CDCurrentUseItem *)useItem;

@end

@interface ShopCartDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) id<ShopCartDataSouceDelegate>delegate;
- (instancetype) initWithTableView:(UITableView *)tableView delegate:(id<ShopCartDataSouceDelegate>)delegate;
@end
