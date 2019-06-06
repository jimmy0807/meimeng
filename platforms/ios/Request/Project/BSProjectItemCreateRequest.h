//
//  BSProjectItemCreateRequest.h
//  Boss
//
//  Created by XiaXianBing on 15/6/11.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSProjectItemCreateRequest : ICRequest

- (id)initWithParams:(NSDictionary *)params;
- (id)initWithProjectItemID:(NSNumber *)itemID params:(NSDictionary *)params;

@property(nonatomic)BOOL useTemplate;

@end
