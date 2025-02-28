//
//  CDBingfangRoomPerson+CoreDataProperties.h
//  meim
//
//  Created by jimmy on 2018/4/27.
//
//

#import "CDBingfangRoomPerson+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CDBingfangRoomPerson (CoreDataProperties)

+ (NSFetchRequest<CDBingfangRoomPerson *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *customer_state;
@property (nullable, nonatomic, copy) NSNumber *designers_id;
@property (nullable, nonatomic, copy) NSString *designers_name;
@property (nullable, nonatomic, copy) NSNumber *director_employee_id;
@property (nullable, nonatomic, copy) NSString *director_employee_name;
@property (nullable, nonatomic, copy) NSString *image_url;
@property (nullable, nonatomic, copy) NSNumber *line_id;
@property (nullable, nonatomic, copy) NSNumber *member_id;
@property (nullable, nonatomic, copy) NSString *member_name;
@property (nullable, nonatomic, copy) NSString *member_type;
@property (nullable, nonatomic, copy) NSString *start_date;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, retain) CDBingfangRoomPerson *room;

@end

NS_ASSUME_NONNULL_END
