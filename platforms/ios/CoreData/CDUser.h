//
//  CDUser.h
//  Boss
//
//  Created by lining on 15/8/26.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDStaff;

@interface CDUser : NSManagedObject

@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSNumber * company_id;
@property (nonatomic, retain) NSString * constellation;
@property (nonatomic, retain) NSString * create_date;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSNumber * idx;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * shop_id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSSet *staffs;
@end

@interface CDUser (CoreDataGeneratedAccessors)

- (void)addStaffsObject:(CDStaff *)value;
- (void)removeStaffsObject:(CDStaff *)value;
- (void)addStaffs:(NSSet *)values;
- (void)removeStaffs:(NSSet *)values;

@end
