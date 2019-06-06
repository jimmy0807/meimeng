//
//  BSFetchMemberCardRequest.h
//  Boss
//
//  Created by XiaXianBing on 15/11/2.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchMemberCardRequest : ICRequest

- (id)initWithMemberCardIds:(NSArray *)memberCardIds;
- (id)initWithMemberCardIds:(NSMutableArray *)memberCardIds keyword:(NSString*)keyword;
- (id)initWithMemberID:(NSNumber *)memberID;
@end
