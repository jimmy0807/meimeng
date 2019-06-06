//
//  BSFetchCardOperateRequest.m
//  Boss
//
//  Created by lining on 15/10/19.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSFetchPosOperateRequest.h"
#import "BSDataManager.h"
#import "ChineseToPinyin.h"

@implementation BSFetchPosOperateRequest

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.card.operate";
    
    if ( self.currentWorkFlowID )
    {
        if ( self.shopID )
        {
            self.filter = @[@[@"shop_id",@"=",self.shopID],@[@"is_import",@"=",@0],@[@"current_activity_id",@"=",self.currentWorkFlowID],@[@"shop_id",@"=",self.shopID],@[@"state",@"=",@"done"]];
        }
        else
        {
            self.needCompany = YES;
            self.filter = @[@[@"is_import",@"=",@0],@[@"current_activity_id",@"=",self.currentWorkFlowID],@[@"state",@"=",@"done"]];
        }
        
        self.field = @[@"operate_id",@"name",@"now_amount",@"create_date",@"type",@"card_id",@"period_id",@"card_shop_id",@"create_uid",@"member_id",@"shop_id",@"product_line_ids",@"statement_ids",@"arrears_ids",@"commission_ids",@"consume_line_ids",@"member_mobile",@"born_uuid",@"wevip_member_id",@"wevip_member_name",@"current_activity_id",@"queue_no",@"sort",@"doctor_id",@"departments_id",@"activity_ids",@"operate_employee_id",@"operate_employee_ids",@"employee_id",@"after_sign_image_url",@"remark",@"designers_id",@"anesthetic_consuming",@"image_ids",@"director_employee_id",@"state",@"member_type",@"workflow_id",@"role_option",@"current_workflow_activity_id",@"line_display_name"];
    }
    else
    {
        NSString *start = nil;
        NSString *end = nil;
        
        if ( [self.type isEqualToString:@"day"] )
        {
            [BSDataManager getTodayString:&start end:&end];
        }
        else if ( [self.type isEqualToString:@"week"] )
        {
            [BSDataManager getWeekString:&start end:&end];
        }
        else
        {
            [BSDataManager getMonthString:self.type start:&start end:&end];
        }
        
        if ( self.keyword.length > 0 )
        {
            NSMutableArray *filters = [NSMutableArray array];
            //[filters addObject:@"|"];
            //[filters addObject:@"|"];
            [filters addObject:@[@"name", @"ilike", self.keyword]];
            //[filters addObject:@[@"state", @"ilike", self.keyword]];
            //[filters addObject:@[@"state", @"ilike", self.keyword]];
        }
        else
        {
            if ( self.shopID )
            {
                self.filter = @[@[@"create_date",@">=",start],@[@"create_date",@"<=",end],@[@"shop_id",@"=",self.shopID],@[@"is_import",@"=",@0],@[@"create_uid",@"=",[PersonalProfile currentProfile].userID]];
            }
            else
            {
                self.needCompany = YES;
                self.filter = @[@[@"create_date",@">=",start],@[@"create_date",@"<=",end],@[@"is_import",@"=",@0],@[@"create_uid",@"=",[PersonalProfile currentProfile].userID]];
            }
            
            if (self.operateID)
            {
                self.needCompany = YES;
                self.filter = @[@[@"id",@"=",self.operateID]];
            }
        }
        
        
        self.field = @[@"operate_id",@"name",@"now_amount",@"create_date",@"type",@"card_id",@"period_id",@"card_shop_id",@"create_uid",@"member_id",@"shop_id",@"product_line_ids",@"statement_ids",@"arrears_ids",@"commission_ids",@"consume_line_ids",@"member_mobile",@"born_uuid",@"wevip_member_id",@"wevip_member_name",@"remark",@"note",@"director_employee_id",@"state"];
    }
    
    [self sendShopAssistantXmlSearchReadCommand];
   
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict;
    NSMutableArray* searchArray = [NSMutableArray array];
    
    if ([retArray isKindOfClass:[NSArray class]])
    {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        
        NSMutableArray *oldOperates;
        if ( self.operateID || self.keyword.length > 0 )
        {
            
        }
        else
        {
            NSArray *operates = [dataManager fetchHistoryPosOperatesByType:self.type storeID:self.shopID];
            oldOperates = [NSMutableArray arrayWithArray:operates];
        }
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        
        for (NSDictionary *params in retArray)
        {
            NSNumber *operate_id = [params numberValueForKey:@"id"];
            CDPosOperate *operate = [dataManager findEntity:@"CDPosOperate" withValue:operate_id forKey:@"operate_id"];
            if (operate)
            {
                [oldOperates removeObject:operate];
            }
            else
            {
                operate = [dataManager insertEntity:@"CDPosOperate"];
                operate.operate_id = operate_id;
            }
            
            operate.name = [params stringValueForKey:@"name"];
            operate.amount = [params numberValueForKey:@"now_amount"];
            operate.operate_date = [params stringValueForKey:@"create_date"];
            NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[dateFormat dateFromString:operate.operate_date]];
            operate.day = @(components.day);
            operate.year_month = [NSString stringWithFormat:@"%d年%d月",components.year,components.month];
            operate.year_month_day = [NSString stringWithFormat:@"%02d年%02d月%02d日",components.year,components.month,components.day];
            
            NSString *type = [params stringValueForKey:@"type"];
            if ([type isEqualToString:@"ungrade"])
            {
                type = @"卡升级";
            }
            else if ([type isEqualToString:@"refund"])
            {
                type = @"退款";
            }
            else if ([type isEqualToString:@"retreat"])
            {
                type = @"退货";
            }
            else if ([type isEqualToString:@"consume"])
            {
                type = @"消费";
            }
            else if ([type isEqualToString:@"card"])
            {
                type = @"开卡";
            }
            else if ([type isEqualToString:@"lost"])
            {
                type = @"挂失";
            }
            else if ([type isEqualToString:@"active"])
            {
                type = @"激活";
            }
            else if ([type isEqualToString:@"exchange"])
            {
                type = @"退换";
            }
            else if ([type isEqualToString:@"merger"])
            {
                type = @"并卡";
            }
            else if ([type isEqualToString:@"buy"])
            {
                type = @"消费";
            }
            else if ([type isEqualToString:@"replacement"])
            {
                type = @"换卡";
            }
            else if ([type isEqualToString:@"repayment"])
            {
                type = @"还款";
            }
            else if ([type isEqualToString:@"recharge"])
            {
                type = @"充值";
            }
            operate.type = type;
            
            operate.born_uuid = [params stringValueForKey:@"born_uuid"];
            
            CDMemberCard *memberCard = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCard" withValue:[params arrayIDValueForKey:@"card_id"] forKey:@"cardID"];
            if (memberCard == nil)
            {
                NSLog(@"NO CARD_ID: %@",[params arrayIDValueForKey:@"card_id"]);
                memberCard = [[BSCoreDataManager currentManager] insertEntity:@"CDMemberCard"];
                memberCard.cardID = [params arrayIDValueForKey:@"card_id"];
                memberCard.cardName = [params arrayNameValueForKey:@"card_id"];
            }
            operate.cardForOperateList = memberCard;
            operate.card_id = [params arrayIDValueForKey:@"card_id"];
            operate.card_name = [params arrayNameValueForKey:@"card_id"];
            
            operate.period_id = [params arrayIDValueForKey:@"period_id"];
            operate.period_name = [params arrayNameValueForKey:@"period_id"];
            
            operate.operate_user_id = [params arrayIDValueForKey:@"create_uid"];
            operate.operate_user_name = [params arrayNameValueForKey:@"create_uid"];
            
            operate.operate_shop_id = [params arrayIDValueForKey:@"shop_id"];
            operate.operate_shop_name = [params arrayNameValueForKey:@"shop_id"];
            
            operate.card_shop_id = [params arrayIDValueForKey:@"card_shop_id"];
            operate.card_shop_name = [params arrayNameValueForKey:@"card_shop_id"];
            operate.remark = [params stringValueForKey:@"remark"];
            if ( [operate.remark isEqualToString:@"0"] )
            {
                operate.remark = @"";
            }
            
            operate.note = [params stringValueForKey:@"note"];
            if ( [operate.note isEqualToString:@"0"] )
            {
                operate.note = @"";
            }
            
            CDStore *store = [[BSCoreDataManager currentManager] findEntity:@"CDStore" withValue:[params arrayIDValueForKey:@"card_shop_id"] forKey:@"storeID"];
            if (store == nil) {
                NSLog(@"NO SHOP_ID: %@",[params arrayIDValueForKey:@"card_id"]);
                store = [[BSCoreDataManager currentManager] insertEntity:@"CDStore"];
                store.storeID = [params arrayIDValueForKey:@"card_shop_id"];
                store.storeName = [params arrayNameValueForKey:@"card_shop_id"];
            }
            
            operate.shop = store;
            
            CDMember *member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:[params arrayIDValueForKey:@"member_id"] forKey:@"memberID"];
            if (member == nil)
            {
                member = [[BSCoreDataManager currentManager] insertEntity:@"CDMember"];
                member.memberID = [params arrayIDValueForKey:@"member_id"];
                member.memberName = [params arrayNameValueForKey:@"member_id"];
                
            }
            operate.member = member;
            operate.member_id = [params arrayIDValueForKey:@"member_id"];
            operate.member_name = [params arrayNameValueForKey:@"member_id"];
            operate.memberNameLetter = [ChineseToPinyin pinyinFromChiniseString:member.memberName];
            operate.memberNameFirstLetter = [[ChineseToPinyin pinyinFirstLetterString:member.memberName] uppercaseString];
            
            operate.member_mobile = [params stringValueForKey:@"member_mobile"];
            
            operate.wevip_member_id = [params numberValueForKey:@"wevip_member_id"];
            operate.wevip_member_name = [params stringValueForKey:@"wevip_member_name"];
            operate.yimei_member_type = [params stringValueForKey:@"member_type"];
            if ( [operate.yimei_member_type isEqualToString:@"0"] )
            {
                operate.yimei_member_type = @"";
            }
            
            //产品列表
//            NSArray *line
            operate.product_line_ids = [[params arrayValueForKey:@"product_line_ids"] componentsJoinedByString:@","];

            //付款明细
            operate.statement_ids = [[params arrayValueForKey:@"statement_ids"] componentsJoinedByString:@","];
            if (operate.statement_ids.length == 0) {
                [dataManager deleteObjects:operate.payInfos.array];
                operate.payInfos = nil;
            }
            
            //本次欠款
            operate.arrear_ids = [[params arrayValueForKey:@"arrears_ids"] componentsJoinedByString:@","];
            
            
            //员工业绩
            operate.commission_ids = [[params arrayValueForKey:@"commission_ids"] componentsJoinedByString:@","];
            if (operate.commission_ids.length == 0) {
                [dataManager deleteObjects:operate.commissions.array];
                operate.commissions = nil;
            }
            
            //本次服务项目
            operate.consume_line_ids = [[params arrayValueForKey:@"consume_line_ids"] componentsJoinedByString:@","];
           
            operate.isLocal = @(FALSE);
            
            operate.currentWorkflowID = [params arrayNotNullIDValueForKey:@"current_activity_id"];
            operate.yimei_queueID = [params stringValueForKey:@"queue_no"];
            operate.yimei_orderIndex = [params numberValueForKey:@"sort"];
            operate.doctor_name = [params arrayNameValueForKey:@"doctor_id"];
            operate.doctor_id = [params arrayNotNullIDValueForKey:@"doctor_id"];
            operate.keshi_name = [params arrayNameValueForKey:@"departments_id"];
            operate.keshi_id = [params arrayNotNullIDValueForKey:@"departments_id"];
            
            NSArray* activity_ids = [params arrayValueForKey:@"activity_ids"];
            for ( NSNumber* aID in activity_ids )
            {
                CDOperateActivity* a = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDOperateActivity" withValue:aID forKey:@"lineID"];
                a.operate = operate;
                a.state = @"waiting";
            }
            
            operate.yimei_shejishiName = [params arrayNameValueForKey:@"designers_id"];
            operate.yimei_shejishiID = [params arrayIDValueForKey:@"designers_id"];
            
            operate.yimei_guwenName = [params arrayNameValueForKey:@"employee_id"];
            operate.yimei_guwenID = [params arrayIDValueForKey:@"employee_id"];
            
            operate.yimei_shejizongjianName = [params arrayNameValueForKey:@"director_employee_id"];
            operate.yimei_shejizongjianID = [params arrayIDValueForKey:@"director_employee_id"];
            
            operate.yimei_operate_employee_name = [params arrayNameValueForKey:@"operate_employee_id"];
            operate.yimei_operate_employee_id = [params arrayNotNullIDValueForKey:@"operate_employee_id"];
            operate.yimei_operate_employee_ids = [params onlyStringValueForKey:@"operate_employee_ids"];
            operate.yimei_sign_after = [params stringValueForKey:@"after_sign_image_url"];
            if ( [operate.yimei_sign_after isEqualToString:@"0"] )
            {
                operate.yimei_sign_after = @"";
            }
            operate.anesthetic_consuming = [params stringValueForKey:@"anesthetic_consuming"];
            
            operate.role_option = [params numberValueForKey:@"role_option"];
            operate.workflow_id = [params arrayIDValueForKey:@"workflow_id"];
            operate.current_workflow_activity_id = [params arrayIDValueForKey:@"current_workflow_activity_id"];
            
            operate.state = [params stringValueForKey:@"state"];
            operate.line_display_name = [params stringValueForKey:@"line_display_name"];
            
            [searchArray addObject:operate];
        }
        
        [dataManager deleteObjects:oldOperates];
        [dataManager save:nil];
    }
    else
    {
        [self generateResponse:@"请求失败，请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFetchPosCardOperateResponse object:searchArray userInfo:dict];
}

@end
