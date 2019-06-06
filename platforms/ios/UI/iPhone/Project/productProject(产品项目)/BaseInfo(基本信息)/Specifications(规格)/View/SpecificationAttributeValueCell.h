//
//  SpecificationAttributeValueCell.h
//  Boss
//
//  Created by jiangfei on 16/7/28.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CDProjectAttributeValue;
@interface SpecificationAttributeValueCell : UITableViewCell
/** attributeVlue*/
@property (nonatomic,strong)CDProjectAttributeValue *attributeValue;
/** tmplate*/
@property (nonatomic,strong)CDProjectAttributeLine *attributeLine;
@end
