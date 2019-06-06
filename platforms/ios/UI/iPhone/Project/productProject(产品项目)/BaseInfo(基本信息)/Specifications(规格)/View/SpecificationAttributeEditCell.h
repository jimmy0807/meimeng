//
//  SpecificationAttributeEditCell.h
//  Boss
//
//  Created by jiangfei on 16/7/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SpecificationEditModel;
@protocol SpecificationAttributeEditCellDelegate <NSObject>

@optional
/**
 *  iconBtn点击
 */
-(void)specificationAttributeEditCellWith:(CDProjectAttributeValue*)attributeValue;

@end
@interface SpecificationAttributeEditCell : UITableViewCell
+(instancetype)specificationAttributeEditCell;
/** attributeVlue*/
@property (nonatomic,strong)CDProjectAttributeValue *attributeValue;
/**attributeLin->获取tmplate*/
@property (nonatomic,strong)CDProjectAttributeLine *attributeLine;
/** delegate*/
@property (nonatomic,weak)id<SpecificationAttributeEditCellDelegate>delegate;
@end
