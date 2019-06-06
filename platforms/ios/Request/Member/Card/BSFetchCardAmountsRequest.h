//
//  BSFetchCardAmountsRequest.h
//  Boss
//  金额变动明细
//  Created by lining on 16/3/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchCardAmountsRequest : ICRequest
- (instancetype)initWithCardID:(NSNumber *)cardID;
- (instancetype)initWithMemberID:(NSNumber *)memberID;
@end
