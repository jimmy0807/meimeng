//
//  PadRestaurantEditViewController.h
//  Boss
//
//  Created by XiaXianBing on 2016-2-24.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadTableNameCell.h"
#import "PadTableSeatCell.h"
#import "PadRestaurantFloorCell.h"
#import "PadRestaurantCollectionView.h"

@interface PadRestaurantEditViewController : ICCommonViewController <PadRestaurantCollectionViewDataSource, PadRestaurantCollectionViewDelegate, PadTableSeatCellDelegate, UITableViewDataSource, UITableViewDelegate>

@end
