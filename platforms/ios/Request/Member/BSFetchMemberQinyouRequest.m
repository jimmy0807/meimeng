//
//  BSFetchMemberQinyouRequest.m
//  Boss
//
//  Created by lining on 16/3/22.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchMemberQinyouRequest.h"

@interface BSFetchMemberQinyouRequest ()
@property(nonatomic, strong) CDMember *member;
@property(nonatomic, strong) NSString *posCardNo;
@end

@implementation BSFetchMemberQinyouRequest

- (instancetype)initWithMember:(CDMember *)member
{
    self = [super init];
    if (self)
    {
        self.member = member;
    }
    return self;
}

- (instancetype) initWithPosCardNo:(NSString *)posCardNo
{
    self = [super init];
    if (self)
    {
        self.posCardNo = posCardNo;
    }
    
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"born.relatives";
    if ( self.posCardNo )
    {
        self.filter = @[@[@"card_no",@"=",self.posCardNo]];
    }
    else
    {
        self.filter = @[@[@"partner_id",@"=",self.member.memberID]];
    }
    
    self.field = @[@"gender",@"birth_date",@"mobile",@"display_name",@"partner_id",@"relatives_card_no",@"card_id",@"card_no",@"write_date"];
    [self sendShopAssistantXmlSearchReadCommand];
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if ([resultList isKindOfClass:[NSArray class]]) {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSMutableArray *oldAry = [NSMutableArray arrayWithArray:[dataManager fetchMemberQinyouWithMember:self.member]];
        
        for (NSDictionary *params in resultList) {
            NSNumber *qy_id = [params numberValueForKey:@"id"];
            CDMemberQinyou *qinyou = [dataManager findEntity:@"CDMemberQinyou" withValue:qy_id forKey:@"qy_id"];
            if (qinyou) {
                [oldAry removeObject:qinyou];
            }
            else
            {
                qinyou = [dataManager insertEntity:@"CDMemberQinyou"];
                qinyou.qy_id = qy_id;
            }
            qinyou.gender = [params stringValueForKey:@"gender"];
            qinyou.birthday = [params stringValueForKey:@"birth_date"];
            qinyou.telephone = [params stringValueForKey:@"mobile"];
            qinyou.name = [params stringValueForKey:@"display_name"];
            qinyou.partner_id = [params arrayIDValueForKey:@"partner_id"];
            qinyou.partner_name = [params arrayNameValueForKey:@"partner_id"];
            qinyou.relative_card_no = [params stringValueForKey:@"relatives_card_no"];
            qinyou.card_id = [params arrayIDValueForKey:@"card_id"];
            qinyou.card_no = [params stringValueForKey:@"card_no"];
            qinyou.last_update = [params stringValueForKey:@"write_date"];
            qinyou.image_name = [NSString stringWithFormat:@"member_%@_qinyou_%@",self.member.memberID,qy_id];
            qinyou.member = self.member;
            
        }
        
        [dataManager deleteObjects:oldAry];
        [dataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"亲友请求失败，请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchMemberQinyouResponse object:nil userInfo:dict];
}

@end
