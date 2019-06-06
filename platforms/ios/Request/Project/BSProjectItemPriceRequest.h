//
//  BSProjectItemPriceRequest.h
//  Boss
//
//  Created by XiaXianBing on 15/11/16.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSProjectItemPriceRequest : ICRequest

- (id)initWithProjectIds:(NSArray *)projectIds priceListId:(NSNumber *)pricelistId;

@end
