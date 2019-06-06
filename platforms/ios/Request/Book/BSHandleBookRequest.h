//
//  BSHandleBookRequest.h
//  Boss
//
//  Created by lining on 15/12/16.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"


typedef enum HandleBookType
{
    HandleBookType_create,
    HandleBookType_edit,
    HandleBookType_approved,
    HandleBookType_billed,
    HandleBookType_delete
}HandleBookType;

@interface BSHandleBookRequest : ICRequest
@property (assign, nonatomic) HandleBookType type;
@property (strong, nonatomic) NSMutableDictionary *params;
- (instancetype) initWithCDBook:(CDBook *)book;

@end
