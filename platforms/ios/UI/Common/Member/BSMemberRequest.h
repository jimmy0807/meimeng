//
//  BSMemberRequest.h
//  Boss
//
//  Created by XiaXianBing on 15/10/22.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSMemberRequest : ICRequest

@property (nonatomic, strong) NSString *errorMessage;

+ (BSMemberRequest *)sharedInstance;

- (void)startMemberRequest;
- (void)startMemberRequestNoErrorMSG;

@end
