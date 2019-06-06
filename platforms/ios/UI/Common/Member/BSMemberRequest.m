//
//  BSMemberRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/10/22.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSMemberRequest.h"
#import "BSFetchProductPriceListRequest.h"
#import "BSFetchMemberCardProjectRequest.h"
#import "BSFetchCouponCardProductRequest.h"
#import "BSFetchMemberCardArrearsRequest.h"
#import "BSFetchMemberRequest.h"

@interface BSMemberRequest ()

@property (nonatomic, assign) BOOL isRequestSuccess;
@property (nonatomic, assign) NSInteger requestCount;
@property (nonatomic, assign) BOOL isNoErrorMessage;

@end


@implementation BSMemberRequest

@synthesize requestCount = _requestCount;

static BSMemberRequest *mInstance;
+ (BSMemberRequest *)sharedInstance
{
    if (mInstance == nil)
    {
        mInstance = [[self alloc] init];
    }
    
    return mInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self registerNofitificationForMainThread:kBSFetchMemberCardProjectResponse];
        [self registerNofitificationForMainThread:kBSFetchMemberCardResponse];
        [self registerNofitificationForMainThread:kBSFetchCouponCardProductResponse];
        [self registerNofitificationForMainThread:kBSFetchCouponCardResponse];
        [self registerNofitificationForMainThread:kBSFetchMemberCardArrearsResponse];
        [self registerNofitificationForMainThread:kBSFetchProductPriceListResponse];
        [self registerNofitificationForMainThread:kBSFetchMemberResponse];
    }
    
    return self;
}


#pragma mark -
#pragma mark init Methods

- (void)setRequestCount:(NSInteger)requestCount
{
    if (_requestCount != requestCount)
    {
        _requestCount = requestCount;
        if (self.requestCount == 0)
        {
            if (self.isRequestSuccess)
            {
                BSFetchProductPriceListRequest *request = [[BSFetchProductPriceListRequest alloc] init];
                [request execute];
            }
            else
            {
                [self requestFailed];
            }
        }
    }
}


#pragma mark -
#pragma mark Required Methods

- (void)startMemberRequest
{
//    self.requestCount = 1;
    self.isRequestSuccess = YES;
    
    BSFetchProductPriceListRequest *request = [[BSFetchProductPriceListRequest alloc] init];
    [request execute];
    
//    BSFetchMemberCardProjectRequest *memberProject = [[BSFetchMemberCardProjectRequest alloc] init];
//    [memberProject execute];
//    
//    BSFetchCouponCardProductRequest *couponProduct = [[BSFetchCouponCardProductRequest alloc] init];
//    [couponProduct execute];
//    
//    BSFetchMemberCardArrearsRequest *arrearsRequest = [[BSFetchMemberCardArrearsRequest alloc] init];
//    [arrearsRequest execute];
//    
//    BSFetchMemberCardExchangeRequest *exchangeRequest = [[BSFetchMemberCardExchangeRequest alloc] init];
//    [exchangeRequest execute];
}

- (void)startMemberRequestNoErrorMSG
{
    self.isNoErrorMessage = YES;
    [self startMemberRequest];
}
- (void)requestFailed
{
    
    if (!self.isNoErrorMessage && self.errorMessage.length != 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:self.errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSMemberRequestFailed object:nil userInfo:nil];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSFetchMemberCardProjectResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            ;
        }
        else
        {
            self.isRequestSuccess = NO;
            self.errorMessage = [notification.userInfo stringValueForKey:@"rm"];
            self.requestCount --;
        }
    }
    else if ([notification.name isEqualToString:kBSFetchMemberCardResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            self.requestCount --;
        }
        else
        {
            self.isRequestSuccess = NO;
            self.errorMessage = [notification.userInfo stringValueForKey:@"rm"];
            self.requestCount --;
        }
    }
    else if ([notification.name isEqualToString:kBSFetchCouponCardProductResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            ;
        }
        else
        {
            self.isRequestSuccess = NO;
            self.errorMessage = [notification.userInfo stringValueForKey:@"rm"];
            self.requestCount --;
        }
    }
    else if ([notification.name isEqualToString:kBSFetchCouponCardResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            self.requestCount --;
        }
        else
        {
            self.isRequestSuccess = NO;
            self.errorMessage = [notification.userInfo stringValueForKey:@"rm"];
            self.requestCount --;
        }
    }
    else if ([notification.name isEqualToString:kBSFetchMemberCardArrearsResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            self.requestCount --;
        }
        else
        {
            self.isRequestSuccess = NO;
            self.errorMessage = [notification.userInfo stringValueForKey:@"rm"];
            self.requestCount --;
        }
    }
    else if ([notification.name isEqualToString:kBSFetchProductPriceListResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kBSMemberRequestSuccess object:nil userInfo:nil];
            BSFetchMemberRequest *request = [[BSFetchMemberRequest alloc] init];
            //request.fetchID = YES;
            [request execute];
        }
        else
        {
            self.isRequestSuccess = NO;
            self.errorMessage = [notification.userInfo stringValueForKey:@"rm"];
            [self requestFailed];
        }
    }
    else if ([notification.name isEqualToString:kBSFetchMemberResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kBSMemberRequestSuccess object:nil userInfo:nil];
        }
        else
        {
            self.isRequestSuccess = NO;
            self.errorMessage = [notification.userInfo stringValueForKey:@"rm"];
            [self requestFailed];
        }
    }
}

@end
