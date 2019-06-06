//
//  productModel.h
//  Boss
//
//  Created by jiangfei on 16/5/31.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface productModel : NSObject
/** 标题name */
@property (nonatomic,strong)NSString *name;
/** 提示语 */
@property (nonatomic,strong)NSString *placeHold;
/** textField内容*/
@property (nonatomic,strong)NSString *textContent;

/** 普通状态下的图片norImage*/
@property (nonatomic,strong)NSString *norImageName;
/** 选中下的图片selImage*/
@property (nonatomic,strong)NSString *selImageName;
/**  当前图片是否选中*/
@property (nonatomic,assign)BOOL imageSeleted;
/**  cell右边的btn是否影藏*/
@property (nonatomic,assign)BOOL btnIsHidden;
/** 编辑model的属性名*/
@property (nonatomic,strong)NSString *editModelProperty;
/** type 0:textField,1:箭头,2:选框,3:二维码*/
@property (nonatomic,assign)NSInteger type;
+(instancetype)productModelWithDict:(NSMutableDictionary*)dict;
@end
