//
//  BSAttributePriceCreateRequest.h
//  Boss
//
//  Created by XiaXianBing on 15/6/12.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"
#import "BSAttributePrice.h"

@interface BSAttributePriceCreateRequest : ICRequest

- (id)initWithTemplateID:(NSNumber *)templateID attributeValueID:(NSNumber *)attributeValueID extraPrice:(CGFloat)extraPrice;

@end
