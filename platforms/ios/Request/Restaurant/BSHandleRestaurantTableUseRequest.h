//
//  BSHandleRestaurantTableUseRequest.h
//  Boss
//
//  Created by lining on 16/6/30.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICRequest.h"

typedef enum HandleTableUseType
{
    HandleTableUseType_create,
    HandleTableUseType_edit
}HandleTableUseType;

@interface BSHandleRestaurantTableUseRequest : ICRequest

- (instancetype) initWithTableUse:(CDRestaurantTableUse *)tableUse type:(HandleTableUseType)type;
@end
