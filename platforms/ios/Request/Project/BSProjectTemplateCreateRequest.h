//
//  BSProjectTemplateCreateRequest.h
//  Boss
//
//  Created by XiaXianBing on 15/7/7.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSProjectTemplateCreateRequest : ICRequest
//
- (id)initWithParams:(NSDictionary *)params;
- (id)initWithProjectTemplateID:(NSNumber *)templateID params:(NSDictionary *)params;

@property (strong, nonatomic) CDProjectTemplate *projectTemplate;

@end
