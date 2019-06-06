//
//  CDQuestionResultItem+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/6/14.
//
//

#import "CDQuestionResultItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDQuestionResultItem (CoreDataProperties)

+ (NSFetchRequest<CDQuestionResultItem *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *itemID;
@property (nullable, nonatomic, retain) CDQuestionResult *question;

@end

NS_ASSUME_NONNULL_END
