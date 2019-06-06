//
//  ConsumeGoodModel.h
//  Boss
//
//  Created by jiangfei on 16/7/1.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  CDProjectTemplate;
@interface ConsumeGoodModel : NSObject
/** tmplate*/
//@property (nonatomic,strong)CDProjectConsumable *consum;
/**  是否选中*/
@property (nonatomic,assign)BOOL isChoice;
/**  数量*/
@property (nonatomic,assign)NSInteger num;
/** imageUrl*/
@property (nonatomic,strong)NSString *imageUrl;
//@property (nonatomic,strong)CDProjectTemplate *temp;
/** name*/
@property (nonatomic,strong)NSString *name;
/** 单位*/
@property (nonatomic,strong)NSString *uomName;
/**  modelId*/
@property (nonatomic,assign)NSInteger modelId;
+(instancetype)consumGoodModelWithTemp:(CDProjectTemplate*)temp;
+(instancetype)consumGoodModelWithConsum:(CDProjectConsumable*)consum;
@end
