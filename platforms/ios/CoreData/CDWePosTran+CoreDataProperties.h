//
//  CDWePosTran+CoreDataProperties.h
//  Boss
//
//  Created by jimmy on 16/4/21.
//  Copyright © 2016年 BORN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDWePosTran.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDWePosTran (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *tradeNo;
@property (nullable, nonatomic, retain) NSNumber *canCancel;
@property (nullable, nonatomic, retain) NSString *time;
@property (nullable, nonatomic, retain) NSString *year_month;
@property (nullable, nonatomic, retain) NSString *cardNo;
@property (nullable, nonatomic, retain) NSNumber *money;
@property (nullable, nonatomic, retain) NSString *phoneNumber;

@end

NS_ASSUME_NONNULL_END
