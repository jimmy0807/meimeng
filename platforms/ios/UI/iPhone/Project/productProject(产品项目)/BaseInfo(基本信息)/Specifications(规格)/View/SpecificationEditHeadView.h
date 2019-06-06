//
//  SpecificationEditHeadCell.h
//  Boss
//
//  Created by jiangfei on 16/7/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SpecificationEditModel;
@protocol SpecificationEditHeadCellDelegate <NSObject>

@optional
/**
 *  点击了IconView
 */
-(void)specificationEditHeadCellImageBtnClickWithLine:(CDProjectAttributeLine*)line;

@end
@interface SpecificationEditHeadView : UIView
/** delegate*/
@property (nonatomic,weak)id<SpecificationEditHeadCellDelegate>delegate;
/** attributeLine*/
@property (nonatomic,strong)CDProjectAttributeLine *attributeLine;
/** attribute*/
@property (nonatomic,strong)CDProjectAttribute *attribute;
+(instancetype)specificationEditHeadView;
@end
