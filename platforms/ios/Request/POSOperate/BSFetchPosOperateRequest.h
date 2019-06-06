//
//  BSFetchCardOperateRequest.h
//  Boss
//
//  Created by lining on 15/10/19.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchPosOperateRequest : ICRequest

@property(nonatomic, strong)NSString* type; //day week month
@property(nonatomic, strong)NSNumber* shopID;
@property(nonatomic, strong)NSNumber* operateID;
@property(nonatomic, strong)NSNumber* currentWorkFlowID; //day week month
@property(nonatomic, strong)NSString* keyword;

@end
