//
//  FetchWXCouponCardAddressUrlRequest.h
//  Boss
//
//  Created by jimmy on 16/5/11.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface FetchWXCouponCardAddressUrlRequest : ICRequest

- (instancetype)initWithWxCardTemplates:(NSArray*)wxCardTemplates phoneNumber:(NSString*)phoneNumber;

@end
