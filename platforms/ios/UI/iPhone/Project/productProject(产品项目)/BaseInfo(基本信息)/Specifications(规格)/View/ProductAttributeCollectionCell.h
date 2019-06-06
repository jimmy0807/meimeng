//
//  ProductAttributeCollectionCell.h
//  Boss
//
//  Created by jiangfei on 16/7/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CDProjectAttributeValue;
@class ProductAttributeCollectionCell;
@protocol ProductAttributeCollectionCellDelegate <NSObject>

@optional
/**
 *  长按cell
 */
-(void)productAttributeLongPressCellWithAttributeValue:(CDProjectAttributeValue*)attributeValue;
/**
 *  改变按钮的选中状态
 */
-(void)productAttributeChangeStatues:(CDProjectAttributeValue*)attributeValue;
@end
@interface ProductAttributeCollectionCell : UICollectionViewCell
/** delegate*/
@property (nonatomic,weak)id<ProductAttributeCollectionCellDelegate>delegate;
/**  用来删除*/
@property (nonatomic,strong)NSIndexPath *indexPath;
/** attributeLine*/
@property (nonatomic,strong)CDProjectAttributeValue *projectAttributeValue;
@end
