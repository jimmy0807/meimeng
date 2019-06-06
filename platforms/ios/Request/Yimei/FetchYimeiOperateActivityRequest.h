//
//  FetchYimeiOperateActivityRequest.h
//  ds
//
//  Created by jimmy on 16/11/7.
//
//

#import "ICRequest.h"

@interface FetchYimeiOperateActivityRequest : ICRequest

@property(nonatomic, strong)CDPosOperate* posOperate;
@property(nonatomic, strong)NSMutableArray* ids;

@end
