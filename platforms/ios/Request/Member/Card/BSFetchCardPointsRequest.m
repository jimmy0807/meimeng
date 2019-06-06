//
//  BSFetchCardPointsRequest.m
//  Boss
//  积分明细
//  Created by lining on 16/3/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchCardPointsRequest.h"

@interface BSFetchCardPointsRequest ()
@property (nonatomic, strong) CDMemberCard *memberCard;
@property (nonatomic, strong) CDMember *member;
@end

@implementation BSFetchCardPointsRequest
- (instancetype)initWithCardID:(NSNumber *)cardID
{
    self = [super init];
    if (self) {
        self.memberCard = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDMemberCard" withValue:cardID forKey:@"cardID"];
    }
    return self;
}

- (instancetype)initWithMemberID:(NSNumber *)memberID
{
    if (self) {
        self.member = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDMember" withValue:memberID forKey:@"memberID"];
    }
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"born.point.record";
    if (self.memberCard) {
        self.filter = @[@[@"card_id",@"=",self.memberCard.cardID]];
    }
    else
    {
        self.filter = @[@[@"member_id",@"=",self.member.memberID]];
    }

    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if ([retArray isKindOfClass:[NSArray class]]) {
        
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        NSMutableArray *oldPoints = nil;
        if (self.memberCard) {
            oldPoints = [NSMutableArray arrayWithArray:[dataManager fetchCardPointsWithCardID:self.memberCard.cardID]];
        }
        else
        {
            oldPoints = [NSMutableArray arrayWithArray:[dataManager fetchCardPointsWithMemberID:self.member.memberID]];
        }
        for (NSDictionary *params in retArray) {
            NSNumber *point_id = [params numberValueForKey:@"id"];
            CDMemberCardPoint *point = [dataManager findEntity:@"CDMemberCardPoint" withValue:point_id forKey:@"point_id"];
            if (point == nil) {
                point = [dataManager insertEntity:@"CDMemberCardPoint"];
                point.point_id = point_id;
            }
            else
            {
                [oldPoints removeObject:point];
            }
            
            point.point = [params numberValueForKey:@"point"];
            point.create_date = [params stringValueForKey:@"create_date"];
            point.exchange_point = [params numberValueForKey:@"exchange_point"];
            
            point.state = [params stringValueForKey:@"state"];
            point.type = [params stringValueForKey:@"type"];
            
            point.shop_id = [params arrayIDValueForKey:@"shop_id"];
            point.shop_name = [params arrayNameValueForKey:@"shop_id"];
            
            point.card_id = [params arrayIDValueForKey:@"card_id"];
            point.card_name = [params arrayNameValueForKey:@"card_id"];

            
            NSNumber *card_id = [params arrayIDValueForKey:@"card_id"];
            CDMemberCard *card = [dataManager uniqueEntityForName:@"CDMemberCard" withValue:card_id forKey:@"cardID"];
            card.cardName = [params arrayNameValueForKey:@"cardID"];
            point.card = card;
            
            NSNumber *member_id = [params arrayIDValueForKey:@"member_id"];
            CDMember *member = [dataManager uniqueEntityForName:@"CDMember" withValue:member_id forKey:@"memberID"];
            self.member.memberName = [params arrayNameValueForKey:@"member_id"];
            point.member = member;
            NSLog(@"@----");
        }
        [dataManager deleteObjects:oldPoints];
        [dataManager save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求失败，请稍后重试"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchMemberCardPointResponse object:nil userInfo:dict];
}


@end
