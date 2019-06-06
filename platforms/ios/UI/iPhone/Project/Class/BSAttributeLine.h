//
//  BSAttributeLine.h
//  Boss
//
//  Created by XiaXianBing on 15/6/25.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSAttributeLine : NSObject

@property (nonatomic, strong) NSNumber *attributeLineID;
@property (nonatomic, strong) NSString *attributeLineName;
@property (nonatomic, strong) NSNumber *templateID;
@property (nonatomic, strong) NSString *templateName;
@property (nonatomic, strong) NSNumber *attributeID;
@property (nonatomic, strong) NSString *attributeName;
@property (nonatomic, strong) NSMutableArray *attributeValues;

@end
