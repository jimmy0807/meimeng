//
//  CDYimeiHistory+CoreDataProperties.m
//  meim
//
//  Created by 波恩公司 on 2017/12/18.
//
//

#import "CDYimeiHistory+CoreDataProperties.h"

@implementation CDYimeiHistory (CoreDataProperties)

+ (NSFetchRequest<CDYimeiHistory *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDYimeiHistory"];
}

@dynamic amount;
@dynamic card_id;
@dynamic create_date;
@dynamic create_name;
@dynamic is_cancel_operate;
@dynamic is_update_add_operate;
@dynamic member_id;
@dynamic member_name;
@dynamic name;
@dynamic nameFirstLetter;
@dynamic nameLetter;
@dynamic note;
@dynamic operate_id;
@dynamic progre_status;
@dynamic remark;
@dynamic sort_index;
@dynamic state;
@dynamic statements;
@dynamic type;
@dynamic is_checkout;
@dynamic is_post_checkout;
@dynamic buy_item;
@dynamic consume_item;

@end
