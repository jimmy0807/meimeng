//
//  ReadMessageRequest.h
//  Boss
//
//  Created by jimmy on 15/9/6.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface ReadMessageRequest : ICRequest


- (id)initWithMessageIds:(NSArray *)messageIds;

@end
