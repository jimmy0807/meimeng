//
//  BSMemberCardOperateRequest.h
//  Boss
//
//  Created by XiaXianBing on 15/11/2.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"
#import "PadProjectConstant.h"

@interface BSMemberCardOperateRequest : ICRequest

- (id)initWithParams:(NSDictionary *)params operateType:(kPadMemberCardOperateType)operateType;

@property(nonatomic, strong)CDPosOperate* operate;
@property(nonatomic, strong)NSNumber* orignalOperateID;
@property (nonatomic, assign) kPadMemberCardOperateType operateType;

@end
