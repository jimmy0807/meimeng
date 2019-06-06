//
//  BSConsumable.h
//  Boss
//
//  Created by XiaXianBing on 15/6/25.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSConsumable : NSObject

@property (nonatomic, strong) NSNumber *consumableID;
@property (nonatomic, strong) NSNumber *baseProductID;
@property (nonatomic, strong) NSString *baseProductName;
@property (nonatomic, strong) NSNumber *productID;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSNumber *uomID;
@property (nonatomic, strong) NSString *uomName;
@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) BOOL isStock;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) CDProjectItem *projectItem;

@end
