//
//  productTableHeadView.h
//  Boss
//
//  Created by jiangfei on 16/6/3.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseInfoTempModel;
@protocol productTableHeadViewDelegate <NSObject>
@optional
//设置图片
-(void)productTableHeadViewImageBtnClick;
//设置名称，售价，成本，时间
-(void)productTableHeadViewChangeTextField:(BaseInfoTempModel*)tempModel andText:(NSString*)text;
@end
typedef void(^productTableHeadViewBlock)();
@interface productTableHeadView : UIView
/** 点击在手数量*/
@property (nonatomic,strong)productTableHeadViewBlock numBlock;
/** image*/
@property (nonatomic,strong)UIImage *image;
/** delegate*/
@property (nonatomic,weak)id<productTableHeadViewDelegate> delegate;
/** 显示产品的名字，图像，价格*/
@property (nonatomic,strong)BaseInfoTempModel *tempModel;
@end
