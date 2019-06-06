//
//  BSFetchOperateRequest.m
//  Boss
//
//  Created by XiaXianBing on 2016-4-12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchOperateRequest.h"
#import "BSFetchPosProductRequest.h"
#import "FetchYimeiPhotoImageRequest.h"
#import "FetchYimeiOperateActivityRequest.h"

@interface BSFetchOperateRequest ()

@property (nonatomic, assign) kFetchOperateType type;
@property (nonatomic, strong) CDMember *member;
@property (nonatomic, strong) NSArray *operateIds;
@property(nonatomic)BOOL fetchDisplayRemark;
@end

@implementation BSFetchOperateRequest

- (id)initWithOperateIds:(NSArray *)operateIds
{
    self = [super init];
    if (self != nil)
    {
        self.type = kFetchOperateDefault;
        self.operateIds = operateIds;
    }
    
    return self;
}

- (id)initWithMember:(CDMember *)member recentOperateIds:(NSArray *)operateIds
{
    self = [super init];
    if (self != nil)
    {
        self.type = kFetchOperateMemberRecent;
        self.member = member;
        self.operateIds = operateIds;
        self.fetchDisplayRemark = TRUE;
    }
    
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"born.card.operate";
    self.filter = @[@[@"id", @"in", self.operateIds]];
    if ( [[PersonalProfile currentProfile].isYiMei boolValue] )
    {
        if ( self.fetchDisplayRemark )
        {
            self.field = @[@"id", @"name", @"type", @"amount", @"now_amount", @"now_card_amount", @"now_arrears_amount", @"create_date",  @"member_id", @"member_mobile", @"card_id", @"shop_id", @"card_shop_id", @"session_id", @"product_line_ids",@"image_ids",@"queue_no",@"doctor_id",@"departments_id",@"activity_ids",@"operate_employee_id",@"provision_id",@"consume_product_names",@"operate_employee_ids",@"current_activity_id",@"progre_status",@"records_id",@"display_remark"];
        }
        else
        {
            self.field = @[@"id", @"name", @"type", @"amount", @"now_amount", @"now_card_amount", @"now_arrears_amount", @"create_date", @"member_id", @"member_id", @"member_mobile", @"card_id", @"card_id", @"shop_id", @"card_shop_id", @"session_id", @"product_line_ids",@"image_ids",@"queue_no",@"doctor_id",@"departments_id",@"activity_ids",@"operate_employee_id",@"provision_id",@"consume_product_names",@"operate_employee_ids",@"current_activity_id",@"progre_status",@"records_id"];
        }
    }
    else
    {
        self.field = @[@"id", @"name", @"type", @"amount", @"now_amount", @"now_card_amount", @"now_arrears_amount", @"create_date", @"member_id", @"member_id", @"member_mobile", @"card_id", @"card_id", @"shop_id", @"card_shop_id", @"session_id", @"product_line_ids",@"progre_status"];
    }
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableOrderedSet *mutableOrderedSet = [NSMutableOrderedSet orderedSet];
    if (resultStr.length != 0 && resultList != nil)
    {
        NSMutableArray* activityIDs = [NSMutableArray array];
        for (NSDictionary *params in resultList)
        {
            NSNumber *operateID = [params numberValueForKey:@"id"];
            CDPosOperate *operate = [[BSCoreDataManager currentManager] findEntity:@"CDPosOperate" withValue:operateID forKey:@"operate_id"];
            if (operate == nil)
            {
                operate = [[BSCoreDataManager currentManager] insertEntity:@"CDPosOperate"];
                operate.operate_id = operateID;
            }
            
            operate.isLocal = @(FALSE);
            operate.name = [params stringValueForKey:@"name"];
            //operate.type = [params stringValueForKey:@"type"];
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
            
            operate.amount = [NSNumber numberWithFloat:[[params stringValueForKey:@"now_amount"] floatValue]];
            operate.nowAmount = [NSNumber numberWithFloat:[[params stringValueForKey:@"now_amount"] floatValue]];
            operate.operate_date = [params stringValueForKey:@"create_date"];
            operate.member_id = [params arrayIDValueForKey:@"member_id"];
            operate.member_name = [params arrayNameValueForKey:@"member_id"];
            operate.member_mobile = [params stringValueForKey:@"member_mobile"];
            operate.card_id = [params arrayIDValueForKey:@"card_id"];
            operate.card_name = [params arrayNameValueForKey:@"card_id"];
            operate.operate_shop_id = [params arrayIDValueForKey:@"shop_id"];
            operate.operate_shop_name = [params arrayNameValueForKey:@"shop_id"];
            operate.card_shop_id = [params arrayIDValueForKey:@"card_shop_id"];
            operate.card_shop_name = [params arrayNameValueForKey:@"card_shop_id"];
            operate.progre_status = [params stringValueForKey:@"progre_status"];
            
            CDStore *store = [[BSCoreDataManager currentManager] findEntity:@"CDStore" withValue:[params arrayIDValueForKey:@"card_shop_id"] forKey:@"storeID"];
            if (store == nil) {
                store = [[BSCoreDataManager currentManager] insertEntity:@"CDStore"];
                store.storeID = [params arrayIDValueForKey:@"card_shop_id"];
                store.storeName = [params arrayNameValueForKey:@"card_shop_id"];
            }
            operate.shop = store;
            
            operate.session_id = [params arrayIDValueForKey:@"session_id"];
            operate.session_name = [params arrayNameValueForKey:@"session_id"];
            operate.now_card_amount = [NSNumber numberWithFloat:[[params stringValueForKey:@"now_card_amount"] floatValue]];
            operate.now_arrears_amount = [params stringValueForKey:@"now_arrears_amount"];
            operate.consume_product_names = [params stringValueForKey:@"consume_product_names"];
            
            CDMemberCard *memberCard = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCard" withValue:operate.card_id forKey:@"cardID"];
            if (memberCard == nil)
            {
                memberCard = [[BSCoreDataManager currentManager] insertEntity:@"CDMemberCard"];
                memberCard.cardID = operate.card_id;
                memberCard.cardName = operate.card_name;
            }
            operate.cardForOperateList = memberCard;
            
            operate.product_line_ids = [[params arrayValueForKey:@"product_line_ids"] componentsJoinedByString:@","];
           
            if (self.type == kFetchOperateMemberRecent)
            {
                [mutableOrderedSet addObject:operate];
            }
            
            operate.yimei_before = [NSMutableOrderedSet orderedSet];
            NSArray* image_ids = [params arrayValueForKey:@"image_ids"];
            for ( NSNumber* aID in image_ids )
            {
                CDYimeiImage* a = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDYimeiImage" withValue:aID forKey:@"imageID"];
                a.before = operate;
            }
            
            if ( image_ids.count > 0 )
            {
                FetchYimeiPhotoImageRequest* request = [[FetchYimeiPhotoImageRequest alloc] init];
                request.ids = image_ids;
                [request execute];
            }
            
            operate.currentWorkflowID = [params arrayNotNullIDValueForKey:@"current_activity_id"];
            operate.yimei_queueID = [params stringValueForKey:@"queue_no"];
            operate.doctor_name = [params arrayNameValueForKey:@"doctor_id"];
            operate.doctor_id = [params arrayNotNullIDValueForKey:@"doctor_id"];
            operate.keshi_name = [params arrayNameValueForKey:@"departments_id"];
            operate.keshi_id = [params arrayNotNullIDValueForKey:@"departments_id"];
            operate.yimei_operate_employee_name = [params arrayNameValueForKey:@"operate_employee_id"];
            operate.yimei_operate_employee_id = [params arrayNotNullIDValueForKey:@"operate_employee_id"];
            operate.yimei_operate_employee_ids = [params onlyStringValueForKey:@"operate_employee_ids"];
            
            operate.yimei_provision_id = [params arrayNotNullIDValueForKey:@"provision_id"];
            operate.binglika_id = [params arrayIDValueForKey:@"records_id"];
            
            if ( [[PersonalProfile currentProfile].isYiMei boolValue] )
            {
                NSArray* activity_ids = [params arrayValueForKey:@"activity_ids"];
                for ( NSNumber* aID in activity_ids )
                {
                    CDOperateActivity* a = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDOperateActivity" withValue:aID forKey:@"lineID"];
                    a.operate = operate;
                    [activityIDs addObject:aID];
                }
            }
            operate.display_remark = [params stringValueForKey:@"display_remark"];
            if ( operate.display_remark.length == 0 || [operate.display_remark isEqualToString:@"0"] )
            {
                operate.display_remark = @"无备注";
            }
        }
        
        FetchYimeiOperateActivityRequest* request = [[FetchYimeiOperateActivityRequest alloc] init];
        request.ids = activityIDs;
        [request execute];
        
        if (self.type == kFetchOperateMemberRecent)
        {
            self.member.recentOperates = [NSOrderedSet orderedSetWithOrderedSet:mutableOrderedSet];
        }
        
        if (self.operateIds.count > 0) {
            BSFetchPosProductRequest *request = [[BSFetchPosProductRequest alloc] initWithOperateIds:self.operateIds];
            [request execute];

        }
        
        [[BSCoreDataManager currentManager] save:nil];
    }
    else
    {
        dict = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchMemberOperateResponse object:self userInfo:dict];
}

@end
