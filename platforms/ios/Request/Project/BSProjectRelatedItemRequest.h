//
//  BSProjectRelatedItemRequest.h
//  Boss
//
//  Created by XiaXianBing on 15/5/27.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSProjectRelatedItemRequest : ICRequest
- (id)initWithLastUpdate;
@property(nonatomic, strong)NSMutableArray* fetchProductIDs;
@end
