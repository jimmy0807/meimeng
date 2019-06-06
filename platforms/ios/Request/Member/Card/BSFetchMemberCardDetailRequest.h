//
//  BSFetchMemberCardDetailRequest.h
//  Boss
//
//  Created by XiaXianBing on 15/11/13.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchMemberCardDetailRequest : ICRequest

- (instancetype _Nonnull)initWithMemberCardID:(NSNumber * _Nullable)memberCardID;
- (instancetype _Nonnull)initWithPosCardNo:(NSString * _Nullable)posCardNo;

@end
