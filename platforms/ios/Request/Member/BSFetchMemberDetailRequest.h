//
//  BSFetchMemberDetailRequest.h
//  Boss
//
//  Created by XiaXianBing on 15/11/13.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchMemberDetailRequest : ICRequest

- (id)initWithMember:(CDMember *)member;

@property(nonatomic)BOOL onlyMemberInfo;

@end
