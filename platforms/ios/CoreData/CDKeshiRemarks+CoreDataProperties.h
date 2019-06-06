//
//  CDKeshiRemarks+CoreDataProperties.h
//  meim
//
//  Created by 波恩公司 on 2018/3/2.
//
//

#import "CDKeshiRemarks+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDKeshiRemarks (CoreDataProperties)

+ (NSFetchRequest<CDKeshiRemarks *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *remark_id;
@property (nullable, nonatomic, copy) NSString *remark_name;

@end

NS_ASSUME_NONNULL_END
