//
//  BSAttributeValue.h
//  Boss
//
//  Created by XiaXianBing on 15/6/25.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BSAttributeLine;

@interface BSAttributeValue : NSObject

@property (nonatomic, assign) NSInteger editType;
@property (nonatomic, strong) NSNumber *attributeValueID;
@property (nonatomic, strong) NSString *attributeValueName;
@property (nonatomic, strong) CDProjectAttributePrice *attributePrice;
@property (nonatomic, assign) CGFloat attributeValueExtraPrice;
@property (nonatomic, strong) BSAttributeLine *attributeLine;

@end
