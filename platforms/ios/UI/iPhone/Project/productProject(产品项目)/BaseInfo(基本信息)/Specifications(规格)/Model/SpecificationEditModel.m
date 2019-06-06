//
//  SpecificationEditModel.m
//  Boss
//
//  Created by jiangfei on 16/7/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "SpecificationEditModel.h"

@implementation SpecificationEditModel
-(NSNumber *)numId
{
    if (self.attributeLine) {
        return self.attributeLine.attributeID;
    }else if (self.attribute){
        return self.attribute.attributeID;
    }else{
        return @0;
    }
    
}
-(NSString*)attributeName
{
    if (self.attribute.attributeName.length) {
        return self.attribute.attributeName;
    }else if (self.attributeLine.attributeName.length){
        return self.attributeLine.attributeName;
    }else{
         return nil;
    }
   
}
-(CDProjectAttribute *)attribute
{
    if (self.attributeLine.attribute) {
        return self.attributeLine.attribute;
    }else if (_attribute){
        return _attribute;
    }else{
        return nil;
    }
}
@end
