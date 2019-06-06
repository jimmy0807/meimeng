//
//  BSGiveCardRequest.m
//  Boss
//
//  Created by lining on 15/10/26.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSGiveCardRequest.h"

@implementation BSGiveCardRequest

- (BOOL)willStart
{
    [super willStart];
//    NSString *cmd = @"/VipApi/pos/createCard";
    
//    [self sendJsonCommand:cmd params:<#(NSDictionary *)#> httpMethod:<#(NSString *)#>]
    return true;
}
@end
