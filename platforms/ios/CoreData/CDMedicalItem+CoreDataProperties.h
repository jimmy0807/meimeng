//
//  CDMedicalItem+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2017/7/17.
//
//

#import "CDMedicalItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDMedicalItem (CoreDataProperties)

+ (NSFetchRequest<CDMedicalItem *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *count;
@property (nullable, nonatomic, copy) NSNumber *is_prescription;
@property (nullable, nonatomic, copy) NSNumber *itemID;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *uomName;
@property (nullable, nonatomic, copy) NSNumber *uomID;
@property (nullable, nonatomic, retain) CDPosWashHand *chufang;
@property (nullable, nonatomic, retain) CDPosWashHand *feichufang;

@end

NS_ASSUME_NONNULL_END
