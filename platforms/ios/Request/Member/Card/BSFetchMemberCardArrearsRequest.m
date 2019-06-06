//
//  BSFetchMemberCardArrearsRequest.m
//  Boss
//  欠款还款明细
//  Created by XiaXianBing on 15/11/19.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSFetchMemberCardArrearsRequest.h"
#import "BSFetchOperateRequest.h"

typedef enum kBSFetchArrearsType
{
    kBSFetchArrearsAll,
    kBSFetchArrearsWithCardID,
    kBSFetchArrearsWithMemberID
}kBSFetchArrearsType;

@interface BSFetchMemberCardArrearsRequest ()
@property (nonatomic, strong) NSNumber *memberID;
@property (nonatomic, strong) NSNumber *memberCardID;
@property (nonatomic, assign) kBSFetchArrearsType type;


@end

@implementation BSFetchMemberCardArrearsRequest

- (id)init
{
    self = [super init];
    if (self)
    {
        self.type = kBSFetchArrearsAll;
    }
    
    return self;
}

- (id)initWithMemberCardID:(NSNumber *)memberCardID
{
    self = [super init];
    if (self)
    {
        self.memberCardID = memberCardID;
        self.type = kBSFetchArrearsWithCardID;
    }
    
    return self;
}

- (instancetype)initWithMemberID:(NSNumber *)memberID
{
    if (self) {
//        self.memberID = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDMember" withValue:memberID forKey:@"memberID"];
        self.memberID = memberID;
        self.type = kBSFetchArrearsWithMemberID;
    }
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"born.arrears";
    if (self.type == kBSFetchArrearsWithCardID)
    {
        if ( self.memberCardID == nil )
            return FALSE;
        
        self.filter = @[@[@"card_id", @"=", self.memberCardID]];

    }
    else if (self.type == kBSFetchArrearsWithMemberID)
    {
        self.filter = @[@[@"member_id",@"=",self.memberID]];
    }
    
    self.field = @[@"id", @"name", @"type", @"arrears_amount", @"total_repayment_amount", @"unrepayment_amount", @"remain_amount", @"create_date", @"__last_update", @"plant_payment_date", @"operate_id", @"card_id", @"member_id"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([resultArray isKindOfClass:[NSArray class]])
    {
        NSMutableArray *oldArrearsArray = [NSMutableArray array];
        if (self.type == kBSFetchArrearsAll)
        {
            NSArray *arrearsArray = [[BSCoreDataManager currentManager] fetchAllMemberCardArrears];
            oldArrearsArray = [NSMutableArray arrayWithArray:arrearsArray];
        }
        else if (self.type == kBSFetchArrearsWithCardID)
        {
            oldArrearsArray = [NSMutableArray arrayWithArray:[[BSCoreDataManager currentManager] fetchCardArrearsWithCardID:self.memberCardID]];
        }
        else if (self.type == kBSFetchArrearsWithMemberID)
        {
            oldArrearsArray = [NSMutableArray arrayWithArray:[[BSCoreDataManager currentManager] fetchCardArrearsWithMemberID:self.memberID]];
        }
        
        for (NSDictionary *params in resultArray)
        {
            NSNumber *arrearsID = [params numberValueForKey:@"id"];
            CDMemberCardArrears *arrears = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCardArrears" withValue:arrearsID forKey:@"arrearsID"];
            if(!arrears)
            {
                arrears = [[BSCoreDataManager currentManager] insertEntity:@"CDMemberCardArrears"];
                arrears.arrearsID = arrearsID;
            }
            else
            {
                [oldArrearsArray removeObject:arrears];
            }
            
            arrears.arrearsName = [params stringValueForKey:@"name"];
            //"type":[arrears]-充值欠款 [course_arrears]-消费欠款
            arrears.arrearsType = [params stringValueForKey:@"type"];
            arrears.arrearsAmount = [NSNumber numberWithFloat:[[params stringValueForKey:@"arrears_amount"] floatValue]];
            arrears.repaymentAmount = [NSNumber numberWithFloat:[[params stringValueForKey:@"total_repayment_amount"] floatValue]];
            arrears.unRepaymentAmount = [NSNumber numberWithFloat:[[params stringValueForKey:@"unrepayment_amount"] floatValue]];
            arrears.remainAmount = [NSNumber numberWithFloat:[[params stringValueForKey:@"remain_amount"] floatValue]];
            arrears.createDate = [params stringValueForKey:@"create_date"];
            arrears.lastUpdate = [params stringValueForKey:@"__last_update"];
            arrears.plantPaymentDate = [params stringValueForKey:@"plant_payment_date"];
            
            NSArray *memberinfo = [params objectForKey:@"member_id"];
            if ([memberinfo isKindOfClass:[NSArray class]] && memberinfo.count > 1)
            {
                arrears.memberID = [memberinfo objectAtIndex:0];
                arrears.memberName = [memberinfo objectAtIndex:1];
                CDMember *member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:arrears.memberID forKey:@"memberID"];
                if (member == nil)
                {
                    member = [[BSCoreDataManager currentManager] insertEntity:@"CDMember"];
                    member.memberID = arrears.memberID;
                    member.memberName = arrears.memberName;
                }
                arrears.member = member;
            }
            
            NSArray *cardinfo = [params objectForKey:@"card_id"];
            if ([cardinfo isKindOfClass:[NSArray class]] && cardinfo.count > 1)
            {
                arrears.memberCardID = [cardinfo objectAtIndex:0];
                arrears.memberCardNumber = [cardinfo objectAtIndex:1];
                CDMemberCard *memberCard = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCard" withValue:arrears.memberCardID forKey:@"cardID"];
                if (memberCard == nil)
                {
                    memberCard = [[BSCoreDataManager currentManager] insertEntity:@"CDMemberCard"];
                    memberCard.cardID = arrears.memberCardID;
                    memberCard.cardNo = arrears.memberCardNumber;
                    memberCard.cardNumber = arrears.memberCardNumber;
                }
                arrears.memberCard = memberCard;
            }
            
            NSArray *operates = [params objectForKey:@"operate_id"];
            if ([operates isKindOfClass:[NSArray class]] && operates.count > 1)
            {
                arrears.operateID = [operates objectAtIndex:0];
                arrears.operateName = [operates objectAtIndex:1];
                
                BSFetchOperateRequest *request = [[BSFetchOperateRequest alloc] initWithOperateIds:@[arrears.operateID]];
                [request execute];
            }
        }
        
         [[BSCoreDataManager currentManager] deleteObjects:oldArrearsArray];
        [[BSCoreDataManager currentManager] save:nil];
    }
    else
    {
        dict = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchMemberCardArrearsResponse object:nil userInfo:dict];
}


@end
