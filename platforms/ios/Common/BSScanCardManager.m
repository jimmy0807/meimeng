//
//  BSScanCardManager.m
//  Boss
//
//  Created by jimmy on 15/11/12.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSScanCardManager.h"
#import "FetchCardInfoFromWevipQRCodeRequest.h"
#import "BSFetchCouponCardRequest.h"
#import "BSFetchMemberCardRequest.h"
#import "BSFetchMemberDetailRequest.h"
#import "BSFetchMemberCardDetailRequest.h"


@interface BSScanCardManager()
@property (nonatomic, strong) NSString *couponNo;
@property (nonatomic, assign) kPadCardType cardType;
@end


@implementation BSScanCardManager

IMPSharedManager(BSScanCardManager)

-(instancetype)init
{
    self = [super init];
    if ( self )
    {
        [self registerNofitificationForMainThread:kFetchCardInfoFromWevipQRCodeResponse];
        [self registerNofitificationForMainThread:kBSFetchCouponCardResponse];
        [self registerNofitificationForMainThread:kBSFetchMemberCardResponse];
    }
    
    return self;
}

- (void)fetchCardFromQRCode:(NSString*)code
{
    if (code.length == 0)
    {
        return;
    }
    
    // E: 会员卡 G: 礼品卡 F: 礼品券
    NSString *prefixstr = [code substringToIndex:1];
    if ([prefixstr isEqualToString:@"E"])
    {
        self.cardType = kPadCardTypeMemberCard;
    }
    else if ([prefixstr isEqualToString:@"G"])
    {
        self.cardType = kPadCardTypeGiftCard;
    }
    else if ([prefixstr isEqualToString:@"F"])
    {
        self.cardType = kPadCardTypeGiftCoupon;
    }
    FetchCardInfoFromWevipQRCodeReqeust *request = [[FetchCardInfoFromWevipQRCodeReqeust alloc] initWithQRCode:prefixstr];
    [request execute];
}

- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kFetchCardInfoFromWevipQRCodeResponse])
    {
        self.couponNo = notification.userInfo[@"couponNo"];
        
        if (self.cardType == kPadCardTypeMemberCard)
        {
            CDMemberCard *memberCard = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCard" withValue:self.couponNo forKey:@"cardNo"];
            if (memberCard)
            {
                self.couponNo = nil;
                BSFetchMemberDetailRequest* memberDetailRequest = [[BSFetchMemberDetailRequest alloc] initWithMember:memberCard.member];
                [memberDetailRequest execute];
                BSFetchMemberCardDetailRequest* memberCardDetailRequest = [[BSFetchMemberCardDetailRequest alloc] initWithMemberCardID:memberCard.cardID];
                [memberCardDetailRequest execute];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kBSScanCardManagerResponse object:nil userInfo:@{@"card":memberCard}];
                return;
            }
            else
            {
                BSFetchMemberCardRequest* request = [[BSFetchMemberCardRequest alloc] initWithMemberCardIds:@[self.couponNo]];
                [request execute];
                return;
            }
        }
        else if (self.cardType == kPadCardTypeGiftCard || self.cardType == kPadCardTypeGiftCoupon)
        {
            CDCouponCard *couponCard = [[BSCoreDataManager currentManager] findEntity:@"CDCouponCard" withValue:self.couponNo forKey:@"cardNumber"];
            if (couponCard)
            {
                self.couponNo = nil;
                BSFetchMemberDetailRequest* memberDetailRequest = [[BSFetchMemberDetailRequest alloc] initWithMember:couponCard.member];
                [memberDetailRequest execute];
                BSFetchMemberCardDetailRequest* memberCardDetailRequest = [[BSFetchMemberCardDetailRequest alloc] initWithMemberCardID:couponCard.cardID];
                [memberCardDetailRequest execute];
                [[NSNotificationCenter defaultCenter] postNotificationName:kBSScanCardManagerResponse object:nil userInfo:@{@"card":couponCard}];
                return ;
            }
            else
            {
                BSFetchCouponCardRequest *couponRequest = [[BSFetchCouponCardRequest alloc] initWithCouponCardIds:@[self.couponNo]];
                [couponRequest execute];
                return;
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSScanCardManagerResponse object:nil userInfo:nil];
    }
    else if ([notification.name isEqualToString:kBSFetchCouponCardResponse])
    {
        CDCouponCard *couponCard = [[BSCoreDataManager currentManager] findEntity:@"CDCouponCard" withValue:self.couponNo forKey:@"cardNumber"];
        if (couponCard)
        {
            self.couponNo = nil;
            BSFetchMemberDetailRequest* memberDetailRequest = [[BSFetchMemberDetailRequest alloc] initWithMember:couponCard.member];
            [memberDetailRequest execute];
            BSFetchMemberCardDetailRequest* memberCardDetailRequest = [[BSFetchMemberCardDetailRequest alloc] initWithMemberCardID:couponCard.cardID];
            [memberCardDetailRequest execute];
            [[NSNotificationCenter defaultCenter] postNotificationName:kBSScanCardManagerResponse object:nil userInfo:@{@"card":couponCard}];
            return ;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSScanCardManagerResponse object:nil userInfo:nil];

    }
    else if ([notification.name isEqualToString:kBSFetchMemberCardResponse])
    {
        CDMemberCard *memberCard = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCard" withValue:self.couponNo forKey:@"cardNo"];
        if (memberCard)
        {
            self.couponNo = nil;
            BSFetchMemberDetailRequest* memberDetailRequest = [[BSFetchMemberDetailRequest alloc] initWithMember:memberCard.member];
            [memberDetailRequest execute];
            BSFetchMemberCardDetailRequest* memberCardDetailRequest = [[BSFetchMemberCardDetailRequest alloc] initWithMemberCardID:memberCard.cardID];
            [memberCardDetailRequest execute];
            [[NSNotificationCenter defaultCenter] postNotificationName:kBSScanCardManagerResponse object:nil userInfo:@{@"card":memberCard}];
            return;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSScanCardManagerResponse object:nil userInfo:nil];
    }
}

@end
