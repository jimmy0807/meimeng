//
//  BSFetchStaffRequest.m
//  Boss
//
//  Created by lining on 15/5/29.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSFetchStaffRequest.h"
#import "ChineseToPinyin.h"
#import "PersonalProfile.h"

@implementation BSFetchStaffRequest
-(BOOL)willStart
{
    [super willStart];
    self.needCompany = true;
    self.tableName = @"hr.employee";
    
    NSMutableArray *filter = [NSMutableArray array];
    
    if (self.shop)
    {
        self.shopID = self.shop.storeID;
    }
    
    if (self.shopID)
    {
        NSArray *subFilter = @[@"shop_id",@"=",self.shopID];
        self.needCompany = false;
        [filter addObject:subFilter];
    }
    
    if (self.userID) {
        NSArray *subFilter = @[@"user_id",@"=",self.userID];
        [filter addObject:subFilter];
    }
    
    if (self.need_role_id)
    {
        NSArray *subFilter = @[@"rule_id",@">=",@1];
        [filter addObject:subFilter];
    }
    
    self.filter = filter;
    
    if ( [[PersonalProfile currentProfile].isYiMei boolValue] )
    {
        self.field = @[@"name",@"shop_id",@"write_date",@"no",@"gender",@"rule_id",@"isbook",@"hr_category",@"user_id", @"work_location",@"department_id",@"job_id",@"book_time"];
    }
    else
    {
        self.field = @[@"name",@"shop_id",@"write_date",@"no",@"gender",@"rule_id",@"isbook",@"user_id"];
    }
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSMutableArray *oldStaffs;
        if (self.userID) {
            
        }
        else
        {
            NSArray *staffs = [dataManager fetchStaffsWithShopID:self.shopID need_role_id:self.need_role_id];
            oldStaffs = [NSMutableArray arrayWithArray:staffs];
        }
        
        
        for (NSDictionary *params in retArray) {
            
            NSNumber *staffId = [params numberValueForKey:@"id"];
            if (self.userID) {
                [PersonalProfile currentProfile].employeeID = staffId;//利用登录用户的userID来获取这个用户的employeeID（只取返回数据的员工的第一个，所以break了），目的是为了获取这个登录用户管理的会员；
                [PersonalProfile currentProfile].employeeName = [params stringValueForKey:@"name"];
                [[PersonalProfile currentProfile] save];
                break;
            }
            
            CDStaff *staff = [dataManager findEntity:@"CDStaff" withValue:staffId forKey:@"staffID"];
            if (staff) {
                [oldStaffs removeObject:staff];
            }
            else
            {
                staff = [dataManager insertEntity:@"CDStaff"];
                staff.staffID = staffId;
            }
            staff.last_time = [params stringValueForKey:@"write_date"];
            staff.name = [params stringValueForKey:@"name"];
            staff.nameLetter = [ChineseToPinyin pinyinFromChiniseString:staff.name];
            staff.gender = [params stringValueForKey:@"gender"];
            
            staff.rule_id = [params arrayIDValueForKey:@"rule_id"];
            staff.rule_name = [params arrayNameValueForKey:@"rule_id"];
            
            CDCommissionRule *rule = [dataManager uniqueEntityForName:@"CDCommissionRule" withValue:staff.rule_id forKey:@"rule_id"];
            rule.rule_name = staff.rule_name;
            staff.commissionRule = rule;
            
            staff.is_book = [params numberValueForKey:@"isbook"];
            staff.staffNo = [params stringValueForKey:@"no"];
            staff.hr_category = [params stringValueForKey:@"hr_category"];
            staff.work_location = [params stringValueForKey:@"work_location"];
            if ( [staff.work_location isEqualToString:@"0"] )
            {
                staff.work_location = @" ";
            }
            //NSLog(@"看下staff params=%@",params);
            NSArray *shop_id = [params arrayValueForKey:@"shop_id"]; //门店
            if (shop_id.count > 0) {
                NSNumber *storeId = [shop_id objectAtIndex:0];
                CDStore *store = [dataManager findEntity:@"CDStore" withValue:storeId forKey:@"storeID"];
                if (!store) {
                    store = [dataManager insertEntity:@"CDStore"];
                    store.storeID = storeId;
                }
                store.storeName = [shop_id objectAtIndex:1];
                
                staff.store = store;
                
                staff.imgName = [NSString stringWithFormat:@"staff_%@_%@",storeId,staffId]; //名字自己拼的
            }
            
            staff.departmemt_id = [params arrayIDValueForKey:@"department_id"];
            staff.departmemt_name = [params arrayNameValueForKey:@"departmemt_name"];
            staff.job_id = [params arrayIDValueForKey:@"job_id"];
            staff.job_name = [params arrayNameValueForKey:@"job_id"];
            staff.book_time = [params numberValueForKey:@"book_time"];
        }
        
        [dataManager deleteObjects:oldStaffs];
        [dataManager save:nil];
        [dict setObject:@0 forKey:@"rc"];
    }
    else
    {
        dict = [self generateResponse:@"数据请求失败，请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchStaffResponse object:nil userInfo:dict];
}
@end
