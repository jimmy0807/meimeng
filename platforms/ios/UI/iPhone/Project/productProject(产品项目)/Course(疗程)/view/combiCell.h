//
//  combiCell.h
//  Boss
//
//  Created by jiangfei on 16/6/13.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CDProjectRelated;
@class CombiModel;
@interface combiCell : UITableViewCell
/** 组合套*/
@property (nonatomic,strong)CDProjectRelated *related;
/** cdprojectTemp*/
@property (nonatomic,strong)CDProjectTemplate *temp;
/** combiModel*/
@property (nonatomic,strong)CombiModel *combiModel;
@end
