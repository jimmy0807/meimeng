//
//  ConsumeGoodModel.m
//  Boss
//
//  Created by jiangfei on 16/7/1.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ConsumeGoodModel.h"

@implementation ConsumeGoodModel
+(instancetype)consumGoodModelWithTemp:(CDProjectTemplate*)temp
{
    ConsumeGoodModel *model = [[self alloc]init];
    model.name = temp.templateName;
    model.num = temp.qty_available.integerValue;
    model.imageUrl = temp.imageUrl;
    model.uomName = temp.uomName;
    model.modelId = temp.templateID.integerValue;
    return model;
}
+(instancetype)consumGoodModelWithConsum:(CDProjectConsumable*)consum
{
    ConsumeGoodModel *model = [[self alloc]init];
    model.name = consum.productName;
    model.num = consum.qty.integerValue;
    CDProjectTemplate *tmp = [[consum.projectItems allObjects]lastObject];
    model.imageUrl = tmp.imageUrl;
    model.uomName = consum.uomName;
    model.modelId = consum.consumableID.integerValue;
    
    return model;
}
//-(NSString *)name
//{
//    if (self.temp) {
//        return self.temp.templateName;
//    }else if (self.consum){
//        return self.consum.productName;
//    }else{
//        return @"";
//    }
//}
//-(NSInteger)num
//{
//    if (self.temp) {
//        return self.temp.qty_available.integerValue;
//    }else if(self.consum){
//        return self.consum.qty.integerValue;
//    }else{
//        return 0;
//    }
//}
//-(void)setNum:(NSInteger)num
//{
//    if (self.temp) {
//        self.temp.qty_available = @(num);
//    }else if (self.consum){
//        self.consum.qty = @(num);
//    }
//}
//-(NSString *)imageUrl
//{
//    if (self.temp) {
//        return self.temp.imageUrl;
//    }else if (self.consum){
//        CDProjectTemplate *tmp = [[self.consum.projectItems allObjects]lastObject];
//        return tmp.imageUrl;
//    }else{
//        return @"";
//    }
//}
//-(NSString *)uomName
//{
//    if (self.temp) {
//        return self.temp.uomName;
//    }else if (self.consum){
//        return self.consum.uomName;
//    }else{
//        return @"";
//    }
//}
@end
