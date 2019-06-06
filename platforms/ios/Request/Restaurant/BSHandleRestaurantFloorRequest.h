//
//  BSHandleRestaurantFloorRequest.h
//  Boss
//
//  Created by lining on 16/6/22.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICRequest.h"

typedef enum HandleFloorType
{
    HandleFloorType_create,
    HandleFloorType_write,
    HandleFloorType_delete
}HandleFloorType;

@interface BSHandleRestaurantFloorRequest : ICRequest

@property (nonatomic, assign) HandleFloorType type;

- (instancetype)initWithFloor:(CDRestaurantFloor *)floor;
@property(nonatomic, strong)NSArray* createdTableArray;

@end
