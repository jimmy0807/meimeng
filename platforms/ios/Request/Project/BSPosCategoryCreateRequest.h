//
//  BSPosCategoryCreateRequest.h
//  Boss
//
//  Created by XiaXianBing on 15/6/10.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSPosCategoryCreateRequest : ICRequest

- (id)initWithPosCategoryName:(NSString *)name parent:(CDProjectCategory *)parent sequence:(NSNumber *)sequence;
- (id)initWithPosCategoryID:(NSNumber *)categoryID categoryName:(NSString *)name parent:(CDProjectCategory *)parent sequence:(NSNumber *)sequence;

@end
