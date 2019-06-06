//
//  BSCreateRestaurantOperateRequest.h
//  Boss
//
//  Created by jimmy on 16/6/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSCreateRestaurantOperateRequest : ICRequest

- (id)initWithTable:(CDRestaurantTable*)table personCount:(NSInteger)personCount isBooked:(BOOL)isBooked;

@property(nonatomic)NSInteger personCount;
@property(nonatomic, strong)NSNumber* occupyID;

@end
