//
//  BSFetchMemberCardArrearsRequest.h
//  Boss
//  欠款还款明细
//  Created by XiaXianBing on 15/11/19.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchMemberCardArrearsRequest : ICRequest

- (id)initWithMemberCardID:(NSNumber *)memberCardID;
- (instancetype)initWithMemberID:(NSNumber *)memberID;

@end
