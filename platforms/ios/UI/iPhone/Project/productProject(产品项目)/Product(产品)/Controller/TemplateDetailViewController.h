//
//  prodcutViewController.h
//  Boss
//
//  Created by jiangfei on 16/5/31.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemplateDetailViewController : ICCommonViewController
/**  tag*/
@property (nonatomic,assign)NSUInteger titleTag;
@property (nonatomic,copy)NSString *titleName;
/**  项目要显示的子控制对应的tag*/
@property (nonatomic,assign)NSInteger consumTag;


/** 要修改，显示，添加，删除的商品对应的CDProjectTemplate*/
@property (nonatomic,strong)CDProjectTemplate *projectTemplate;

@property (nonatomic, strong) CDBornCategory *bornCategory;

@end
