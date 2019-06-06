//
//  BSPosAssignCommissionRequest.h
//  Boss
//
//  Created by lining on 15/11/17.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSPosAssignCommissionRequest : ICRequest
@property (nonatomic, strong) NSMutableDictionary *params;
- (id) initWithPosOperate:(CDPosOperate *)operate params:(NSMutableDictionary *)params;
@end
