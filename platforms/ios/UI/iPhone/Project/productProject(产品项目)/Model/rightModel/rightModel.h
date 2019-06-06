//
//  rightModel.h
//  Boss
//
//  Created by jiangfei on 16/5/25.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CDProjectCategory;
@interface rightModel : NSObject

/** name */
@property (nonatomic,copy)NSString *titleName;
/** 数量*/
@property (nonatomic,assign)NSUInteger count;
/**  是否选中*/
@property (nonatomic,assign)BOOL seleted;
/** category*/
@property (nonatomic,strong)CDProjectCategory *category;
@end
