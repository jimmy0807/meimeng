//
//  ConsumeEditCell.h
//  Boss
//
//  Created by jiangfei on 16/6/8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSConsumable.h"
@class ConsumeGoodModel;
@class ConsumeEditCell;

@protocol ConsumeEditCellDelegate <NSObject>

@end

@interface ConsumeEditCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *lineImgView;
@property (nonatomic,strong)BSConsumable *consumable;

@end
