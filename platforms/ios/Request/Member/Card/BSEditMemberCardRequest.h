//
//  BSEditMemberCardRequest.h
//  Boss
//
//  Created by lining on 16/4/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSEditMemberCardRequest : ICRequest
- (instancetype) initWithCard:(CDMemberCard *)card;
@property (nonatomic, strong) NSDictionary *params;
@end
