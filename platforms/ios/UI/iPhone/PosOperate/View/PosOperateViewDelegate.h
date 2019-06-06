//
//  PosOperateViewDelegate.h
//  Boss
//
//  Created by lining on 16/9/2.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PosOperateViewDelegate <NSObject>
@optional
- (void)didSelectedPosOperate:(CDPosOperate *)operate;
@end
