//
//  FetchHomeMyTodayInComeRequset.h
//  Boss
//
//  Created by jimmy on 15/7/7.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface FetchHomeMyTodayInComeRequset : ICRequest

@property(nonatomic, strong)NSArray* userIDs;
@property(nonatomic, strong)NSNumber* period;

@end
