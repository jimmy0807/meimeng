//
//  BSUomCreateRequest.h
//  Boss
//
//  Created by XiaXianBing on 15/6/26.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSUomCreateRequest : ICRequest

- (id)initWithUomName:(NSString *)uomName uomType:(NSString *)uomType uomCategoryId:(NSNumber *)uomCategoryId uomCategoryName:(NSString *)uomCategoryName;
- (id)initWithProjectUom:(CDProjectUom *)projectUom uomName:(NSString *)uomName uomType:(NSString *)uomType uomCategoryId:(NSNumber *)uomCategoryId uomCategoryName:(NSString *)uomCategoryName;

@end
