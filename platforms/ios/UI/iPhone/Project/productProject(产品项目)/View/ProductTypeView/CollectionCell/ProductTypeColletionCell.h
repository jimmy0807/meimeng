//
//  ProductTypeColletionCell.h
//  Boss
//
//  Created by jiangfei on 16/5/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CDProjectTemplate;
@class CDProjectItem;
@class GoodsModel;
@interface ProductTypeColletionCell : UICollectionViewCell

@property (nonatomic,strong) NSObject *object;

@property (strong, nonatomic) IBOutlet UILabel *selectedLabel;

@end
