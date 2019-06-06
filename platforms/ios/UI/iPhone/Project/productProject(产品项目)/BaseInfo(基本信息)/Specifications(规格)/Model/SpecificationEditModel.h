//
//  SpecificationEditModel.h
//  Boss
//
//  Created by jiangfei on 16/7/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecificationEditModel : NSObject
/** attribute*/
@property (nonatomic,strong)CDProjectAttribute *attribute;
/** attributeVlue*/
@property (nonatomic,strong)CDProjectAttributeValue *attributeValue;
/** tmplate*/
@property (nonatomic,strong)CDProjectAttributeLine *attributeLine;
/** attributeValue*/
@property (nonatomic,strong)NSMutableArray *attributeValueArray;
/**  attributeId*/
@property (nonatomic,assign)NSNumber *numId;
/** attributeName*/
@property (nonatomic,strong)NSString *attributeName;
@end
