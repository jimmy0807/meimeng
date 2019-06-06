//
//  BSHandleRestaurantTableRequest.h
//  Boss
//
//  Created by lining on 16/6/22.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICRequest.h"
typedef enum HandleTableType
{
    HandleTableType_create,
    HandleTableType_write,
    HandleTableType_delete
}HandleTableType;

@interface BSHandleRestaurantTableRequest : ICRequest
@property (nonatomic, assign) HandleTableType type;
- (instancetype)initWithTable:(CDRestaurantTable *)table;
@end
