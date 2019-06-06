//
//  BSAttributeValueCreateRequest.h
//  Boss
//
//  Created by XiaXianBing on 15/6/12.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSAttributeValueCreateRequest : ICRequest

- (id)initWithAttribute:(CDProjectAttribute *)attribute attributeValueName:(NSString *)attributeValueName;
- (id)initWithAttribute:(CDProjectAttribute *)attribute attributeValue:(CDProjectAttributeValue *)attributeValue attributeValueName:(NSString *)attributeValueName;

@end
