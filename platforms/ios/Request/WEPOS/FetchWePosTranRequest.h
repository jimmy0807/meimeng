//
//  FetchWePosTranRequest.h
//  Boss
//
//  Created by jimmy on 16/4/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface FetchWePosTranRequest : ICRequest

- (instancetype)initWithPhoneNumber:(NSString*)phoneNumber tranMonth:(NSString*)tranMonth;
- (instancetype)initWithPhoneNumber:(NSString*)phoneNumber tranNo:(NSString*)tranNo;

@end
