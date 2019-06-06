//
//  BSAttributePrice.h
//  Boss
//
//  Created by XiaXianBing on 15/7/3.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSAttributePrice : NSObject

@property (nonatomic, strong) NSNumber *templateID;
@property (nonatomic, strong) NSNumber *attributeLineID;
@property (nonatomic, strong) NSNumber *attributeID;
@property (nonatomic, strong) NSString *attributeName;
@property (nonatomic, strong) NSNumber *attributeValueID;
@property (nonatomic, strong) NSString *attributeValueName;
@property (nonatomic, strong) NSNumber *attributePriceID;
@property (nonatomic, strong) NSString *attributePriceName;
@property (nonatomic, assign) CGFloat attributeExtraPrice;

@end
