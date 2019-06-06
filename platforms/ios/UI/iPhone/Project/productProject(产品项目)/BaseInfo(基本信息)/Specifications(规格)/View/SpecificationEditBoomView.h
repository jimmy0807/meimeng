//
//  SpecificationEditBoomView.h
//  Boss
//
//  Created by jiangfei on 16/7/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SpecificationEditModel;
typedef void(^SpecificationEditBoomViewDeleteBlock)();
typedef void(^SpecificationEditBoomViewBlock)(BOOL isAllSeleted);
@class SpecificationEditModel;
@interface SpecificationEditBoomView : UIView
+(instancetype)specificationEditBoomView;
/**  是否全选*/
@property (nonatomic,assign)BOOL isAllSeleted;
/** block*/
@property (nonatomic,strong)SpecificationEditBoomViewBlock allSeletedBlock;
/** deleted*/
@property (nonatomic,strong)SpecificationEditBoomViewDeleteBlock deleteBlock;
@end
