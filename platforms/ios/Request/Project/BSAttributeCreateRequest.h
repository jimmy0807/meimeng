//
//  BSAttributeCreateRequest.h
//  Boss
//
//  Created by XiaXianBing on 15/6/12.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"


@interface BSAttributeCreateRequest : ICRequest

- (id)initWithAttributeName:(NSString *)attributeName;
- (id)initWithAttribute:(CDProjectAttribute *)attribute attributeName:(NSString *)attributeName;

@end
