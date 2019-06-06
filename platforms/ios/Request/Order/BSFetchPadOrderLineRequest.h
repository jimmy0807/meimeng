//
//  BSFetchPadOrderLineRequest.h
//  Boss
//
//  Created by XiaXianBing on 15/11/18.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchPadOrderLineRequest : ICRequest

- (id)initWithPadOrderLineIds:(NSArray *)orderLineIds;

@end
