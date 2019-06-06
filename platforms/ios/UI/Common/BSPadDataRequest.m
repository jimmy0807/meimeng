//
//  BSPadDataRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/11/18.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSPadDataRequest.h"
#import "BSOrderRequest.h"
#import "BSMemberRequest.h"
#import "BSProjectRequest.h"
#import "BSFetchPadOrderRequest.h"
#import "BSFetchMemberCardProjectRequest.h"
#import "BSFetchCouponCardProductRequest.h"
#import "BSFetchMemberCardArrearsRequest.h"

#define kBSPadDataRequestCount       9

@interface BSPadDataRequest ()

@property (nonatomic, assign) NSInteger requestCount;
@property (nonatomic, assign) BOOL isRequestSuccess;
@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, assign) NSInteger finishedCount;

@end

@implementation BSPadDataRequest

@synthesize finishedCount = _finishedCount;
@synthesize requestCount = _requestCount;

static BSPadDataRequest *mInstance;
+ (BSPadDataRequest *)sharedInstance
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
        //Order
        [self registerNofitificationForMainThread:kBSFetchPadOrderResponse];
        [self registerNofitificationForMainThread:kBSFetchPadOrderLineResponse];
        //Member
        [self registerNofitificationForMainThread:kBSFetchMemberCardProjectResponse];
        [self registerNofitificationForMainThread:kBSFetchMemberCardArrearsResponse];
        [self registerNofitificationForMainThread:kBSFetchMemberCardResponse];
        [self registerNofitificationForMainThread:kBSFetchCouponCardProductResponse];
        [self registerNofitificationForMainThread:kBSFetchCouponCardResponse];
        [self registerNofitificationForMainThread:kBSFetchProductPriceListResponse];
        [self registerNofitificationForMainThread:kBSFetchMemberResponse];
        //Project
        [self registerNofitificationForMainThread:kBSBornCategoryResponse];
        [self registerNofitificationForMainThread:kBSProjectCategoryResponse];
        [self registerNofitificationForMainThread:kBSProjectUomCategoryResponse];
        [self registerNofitificationForMainThread:kBSProjectUomResponse];
        [self registerNofitificationForMainThread:kBSProjectConsumableResponse];
        [self registerNofitificationForMainThread:kBSProjectRelatedItemResponse];
        [self registerNofitificationForMainThread:kBSProjectAttributePriceResponse];
        [self registerNofitificationForMainThread:kBSProjectAttributeValueResponse];
        [self registerNofitificationForMainThread:kBSProjectAttributeResponse];
        [self registerNofitificationForMainThread:kBSProjectAttributeLineResponse];
        [self registerNofitificationForMainThread:kBSProjectTemplateResponse];
        [self registerNofitificationForMainThread:kBSProjectTemplateIDResponse];
        [self registerNofitificationForMainThread:kBSProjectItemResponse];
        [self registerNofitificationForMainThread:kBSProjectItemIDResponse];
        //Order、Member、Project
        [self registerNofitificationForMainThread:kBSOrderRequestSuccess];
        [self registerNofitificationForMainThread:kBSOrderRequestFailed];
        [self registerNofitificationForMainThread:kBSMemberRequestSuccess];
        [self registerNofitificationForMainThread:kBSMemberRequestFailed];
        [self registerNofitificationForMainThread:kBSProjectRequestSuccess];
        [self registerNofitificationForMainThread:kBSProjectRequestFailed];
    }
    
    return self;
}


#pragma mark -
#pragma mark init Methods

- (void)setFinishedCount:(NSInteger)finishedCount
{
    if (_finishedCount != finishedCount)
    {
        _finishedCount = finishedCount;
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@(_finishedCount), @"finish_count", @(kBSPadDataRequestCount), @"total_count", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSPadDataRequestFinishCount object:nil userInfo:params];
    }
}

- (void)setRequestCount:(NSInteger)requestCount
{
    if (_requestCount != requestCount)
    {
        _requestCount = requestCount;
        if (self.requestCount == 0)
        {
            if (self.isRequestSuccess)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kBSPadDataRequestSuccess object:nil userInfo:nil];
            }
            else
            {
                if (self.errorMessage.length != 0)
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                        message:self.errorMessage
                                                                       delegate:nil
                                                              cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                              otherButtonTitles:nil, nil];
                    [alertView show];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kBSPadDataRequestFailed object:nil userInfo:nil];
            }
        }
    }
}


#pragma mark -
#pragma mark Required Methods

- (void)startDataRequest
{
    self.finishedCount = 0;
    self.requestCount = 3;
    self.isRequestSuccess = YES;
    [[BSOrderRequest sharedInstance] startOrderRequestNoErrorMSG];
    [[BSMemberRequest sharedInstance] startMemberRequestNoErrorMSG];
    [[BSProjectRequest sharedInstance] startProjectRequestNoErrorMSG];
}

- (void)requestFailed
{
    if (self.errorMessage.length != 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:self.errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectRequestFailed object:nil userInfo:nil];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    // Order
    if ([notification.name isEqualToString:kBSFetchPadOrderResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            ;
        }
        else
        {
            self.finishedCount ++;
        }
    }
    else if ([notification.name isEqualToString:kBSFetchPadOrderLineResponse])
    {
        self.finishedCount ++;
    }
    // Member
    /*
    else if ([notification.name isEqualToString:kBSFetchMemberCardProjectResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            ;
        }
        else
        {
            self.finishedCount ++;
        }
    }
    else if ([notification.name isEqualToString:kBSFetchMemberCardResponse])
    {
        self.finishedCount ++;
    }
    else if ([notification.name isEqualToString:kBSFetchCouponCardProductResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            ;
        }
        else
        {
            self.finishedCount ++;
        }
    }
    else if ([notification.name isEqualToString:kBSFetchCouponCardResponse])
    {
        self.finishedCount ++;
    }
    else if ([notification.name isEqualToString:kBSFetchMemberCardArrearsResponse])
    {
        self.finishedCount ++;
    }
    else if ([notification.name isEqualToString:kBSFetchMemberCardExchangeResponse])
    {
        self.finishedCount ++;
    }
     */
    else if ([notification.name isEqualToString:kBSFetchProductPriceListResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            ;
        }
        else
        {
            self.finishedCount ++;
        }
    }
    else if ([notification.name isEqualToString:kBSFetchMemberResponse])
    {
        self.finishedCount ++;
    }
    // Project
    else if ([notification.name isEqualToString:kBSBornCategoryResponse])
    {
        self.finishedCount ++;
    }
    else if ([notification.name isEqualToString:kBSProjectCategoryResponse])
    {
        self.finishedCount ++;
    }
    else if ([notification.name isEqualToString:kBSProjectUomCategoryResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            ;
        }
        else
        {
            self.finishedCount ++;
        }
    }
    else if ([notification.name isEqualToString:kBSProjectUomResponse])
    {
        self.finishedCount ++;
    }
    else if ([notification.name isEqualToString:kBSProjectConsumableResponse])
    {
        self.finishedCount ++;
    }
    else if ([notification.name isEqualToString:kBSProjectRelatedItemResponse])
    {
        self.finishedCount ++;
    }
    else if ([notification.name isEqualToString:kBSProjectAttributePriceResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            ;
        }
        else
        {
            self.finishedCount ++;
        }
    }
    else if ([notification.name isEqualToString:kBSProjectAttributeValueResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            ;
        }
        else
        {
            self.finishedCount ++;
        }
    }
    else if ([notification.name isEqualToString:kBSProjectAttributeResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            ;
        }
        else
        {
            self.finishedCount ++;
        }
    }
    else if ([notification.name isEqualToString:kBSProjectAttributeLineResponse])
    {
        self.finishedCount ++;
    }
    else if ([notification.name isEqualToString:kBSProjectTemplateResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            ;
        }
        else
        {
            self.finishedCount ++;
        }
    }
    else if ([notification.name isEqualToString:kBSProjectTemplateIDResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            ;
        }
        else
        {
            self.finishedCount ++;
        }
    }
    else if ([notification.name isEqualToString:kBSProjectItemResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            ;
        }
        else
        {
            self.finishedCount ++;
        }
    }
    else if ([notification.name isEqualToString:kBSProjectItemIDResponse])
    {
        self.finishedCount ++;
    }
    // Order、Member、Project
    else if ([notification.name isEqualToString:kBSOrderRequestSuccess])
    {
        self.requestCount --;
    }
    else if ([notification.name isEqualToString:kBSOrderRequestFailed])
    {
        self.isRequestSuccess = NO;
        self.errorMessage = [[BSOrderRequest sharedInstance] errorMessage];
        self.requestCount --;
    }
    else if ([notification.name isEqualToString:kBSMemberRequestSuccess])
    {
        self.requestCount --;
    }
    else if ([notification.name isEqualToString:kBSMemberRequestFailed])
    {
        self.isRequestSuccess = NO;
        self.errorMessage = [[BSMemberRequest sharedInstance] errorMessage];
        self.requestCount --;
    }
    else if ([notification.name isEqualToString:kBSProjectRequestSuccess])
    {
        self.requestCount --;
    }
    else if ([notification.name isEqualToString:kBSProjectRequestFailed])
    {
        self.isRequestSuccess = NO;
        self.errorMessage = [[BSProjectRequest sharedInstance] errorMessage];
        self.requestCount --;
    }
}

@end
