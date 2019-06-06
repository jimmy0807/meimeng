//
//  CDHJiaoHaoWorkflow+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/7/3.
//
//

#import "CDHJiaoHaoWorkflow+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDHJiaoHaoWorkflow (CoreDataProperties)

+ (NSFetchRequest<CDHJiaoHaoWorkflow *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *workflow_id;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *operate_time;
@property (nullable, nonatomic, retain) CDHJiaoHao *jiaohao;

@end

NS_ASSUME_NONNULL_END
