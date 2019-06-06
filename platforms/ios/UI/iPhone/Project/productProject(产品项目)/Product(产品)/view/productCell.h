//
//  productCell.h
//  Boss
//
//  Created by jiangfei on 16/5/31.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class productModel;
@class productCell;
@protocol productCellDelegate <NSObject>
@optional
/**
 *  编辑textField
 */
-(void)productCellTextFieldEndEdit:(productCell*)cell withCellModel:(productModel*)cellModel;
/**
 *  点击btn
 *  tage = 1,点击了二维码.
 *  tage = 0,点击了普通的选框按钮.
 */
-(void)productCellClickBtnWith:(productModel*)proModel and:(BOOL)tage;
@end
@interface productCell : UITableViewCell
/** 模型*/
@property (nonatomic,strong)productModel *cellModel;
/**  jump*/
@property (nonatomic,assign)BOOL isJump;
/** 产品分类*/
@property (nonatomic,strong)NSString *categoryName;
/** delegate*/
@property (nonatomic,weak)id <productCellDelegate> delegate;
@end
