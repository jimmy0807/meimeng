//
//  productTypeNaviSearch.h
//  Boss
//
//  Created by jiangfei on 16/5/27.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^productTypeNaviSearchBlock)(NSString *searchKey);
typedef void(^productTypeNaviCancelBlock)();
@interface productTypeNaviSearch : UIView
/** 点击了搜索按钮*/
@property (nonatomic,strong)productTypeNaviSearchBlock searchBlock;
/** 点击了取消按钮*/
@property (nonatomic,strong)productTypeNaviCancelBlock cancelBlock;
/** 搜索textFild成为第一响应者*/
-(void)searchBecomeFirstResponder;
/** 调用取消按钮*/
-(void)cancelbtnClick;
@end
