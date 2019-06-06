//
//  ProductTypeOneColumnCollectionCell.h
//  Boss
//
//  Created by jiangfei on 16/5/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CDProjectConsumable;
@interface ProductTypeOneColumnCollectionCell : UICollectionViewCell
@property (nonatomic,strong) NSObject *object;
@property (strong, nonatomic) IBOutlet UILabel *selectedLabel;
@end
