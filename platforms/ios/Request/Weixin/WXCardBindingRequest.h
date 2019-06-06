//
//  WXCardBindingRequest.h
//  Boss
//
//  Created by jimmy on 16/5/11.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface WXCardBindingRequest : ICRequest

- (instancetype)initWithMemberCard:(CDMemberCard*)memberCard;

@end
