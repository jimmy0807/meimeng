//
//  GivePeople.h
//  Boss
//
//  Created by lining on 16/6/3.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GivePeople : NSObject
@property (nonatomic, strong) NSString *member_name;
@property (nonatomic, strong) NSNumber *member_id;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSNumber *shop_id;
@property (nonatomic, strong) NSNumber *is_default_customer;
@property (nonatomic, strong) NSNumber *operateID;
@property (nonatomic, strong) CDPosOperate *operate;
@property (nonatomic, strong) CDMember *member;
@end
