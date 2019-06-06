//
//  FetchWXCouponCardQrUrlRequest.h
//  Boss
//
//  Created by jimmy on 16/5/11.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface FetchWXCouponCardQrUrlRequest : ICRequest

- (instancetype)initWithWxCardTemplates:(NSArray*)wxCardTemplates phoneNumber:(NSString*)phoneNumber;

@end
