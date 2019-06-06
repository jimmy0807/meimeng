//
//  BSTemplateGiveRequest.h
//  Boss
//
//  Created by lining on 16/4/18.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICRequest.h"
typedef enum TemplateType
{
    TemplateType_coupon,
    TemplateType_card
}TemplateType;

@interface BSTemplateGiveRequest : ICRequest
@property (nonatomic, assign)TemplateType type;
- (instancetype)initWithParams:(NSDictionary *)params;

@end
