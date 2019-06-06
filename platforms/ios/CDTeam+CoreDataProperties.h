//
//  CDTeam+CoreDataProperties.h
//  meim
//
//  Created by 波恩公司 on 2017/9/25.
//
//

#import "CDTeam+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDTeam (CoreDataProperties)

+ (NSFetchRequest<CDTeam *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *team_id;
@property (nullable, nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
