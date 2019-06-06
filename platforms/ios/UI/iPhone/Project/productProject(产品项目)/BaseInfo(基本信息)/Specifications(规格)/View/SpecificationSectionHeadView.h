//
//  SpecificationCell.h
//  Boss
//
//  Created by jiangfei on 16/7/28.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SpecificationSectionHeadView;
@class CDProjectAttributeLine;
@class SpecificationEditModel;
@protocol SpecificationSectionHeadViewDelegate <NSObject>

-(void)specificationSectionHeadViewAddBtnClickWithLine:(SpecificationEditModel*)model;

@end
@interface SpecificationSectionHeadView : UIView
/** editModel*/
@property (nonatomic,strong)SpecificationEditModel *editModel;
/** attribute*/
@property (nonatomic,strong)CDProjectAttribute *attribute;
/** attributeLine*/
@property (nonatomic,strong)CDProjectAttributeLine *attributeLine;
/** delegate*/
@property (nonatomic,weak)id<SpecificationSectionHeadViewDelegate>delegate;
+(instancetype)specificationHeadView;
@end
