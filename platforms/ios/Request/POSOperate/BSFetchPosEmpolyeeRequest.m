//
//  BSFetchPosEmpolyeeRequest.m
//  Boss
//
//  Created by lining on 15/11/5.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSFetchPosEmpolyeeRequest.h"

@implementation BSFetchPosEmpolyeeRequest

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"hr.employee";
    if (self.shopID) {
//        self.filter = @[@[]]
    }
    self.field = @[];
    
    return TRUE;
}

@end
