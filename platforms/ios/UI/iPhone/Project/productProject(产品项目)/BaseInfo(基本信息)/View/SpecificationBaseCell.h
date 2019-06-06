//
//  SpecificationBaseCell.h
//  Boss
//
//  Created by jiangfei on 16/7/30.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CDProjectTemplate;
@interface SpecificationBaseCell : UITableViewCell
/** template*/
@property (nonatomic,strong)CDProjectTemplate *projectTemp;
/** orderSet*/
@property (nonatomic,strong)NSOrderedSet *orderSet;
@end
