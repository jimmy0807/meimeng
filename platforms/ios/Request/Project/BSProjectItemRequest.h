//
//  BSProjectItemRequest.h
//  Boss
//
//  Created by XiaXianBing on 15/5/27.
//  Copyright (c) 2014年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSProjectItemRequest : ICRequest

- (id)initWithLastUpdate;

@property(nonatomic, strong)NSMutableArray* fetchProductIDs;

@end
