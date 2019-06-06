//
//  BSPersonalInfo.h
//  Boss
//
//  Created by mac on 15/7/1.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSPersonalInfoRequest : ICRequest
@property(nonatomic,strong)NSNumber *userID;
- (id)initWithPersonalUserID:(NSNumber *)userID;
@end
