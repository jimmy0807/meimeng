//
//  BSUpdatePersonalInfoRequest.h
//  Boss
//
//  Created by mac on 15/7/3.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"
#import "PersonalProfile.h"

@interface BSUpdatePersonalInfoRequest : ICRequest
- (id)initWithAttribute:(NSString *)attribute attributeName:(NSString *)attributeName;
- (instancetype)initWithParams:(NSDictionary *)params;

@property(nonatomic, strong)NSNumber *userID;
@property(nonatomic, strong)NSString *attribute;
@property(nonatomic, strong)NSString *attributeName;

@property(nonatomic, strong)PersonalProfile* profile;

@end
