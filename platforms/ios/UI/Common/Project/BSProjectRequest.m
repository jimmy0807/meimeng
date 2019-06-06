//
//  BSProjectRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/9/14.
//  Copyright (c) 2015Âπ? BORN. All rights reserved.
//

#import "BSProjectRequest.h"
#import "NSObject+MainThreadNotification.h"
#import "BSBornCategoryRequest.h"
#import "BSProjectCategoryRequest.h"
#import "BSProjectUomCategoryRequest.h"
#import "BSProjectUomRequest.h"
#import "BSProjectConsumableRequest.h"
#import "BSProjectRelatedItemRequest.h"
#import "BSProjectAttributeRequest.h"
#import "BSProjectAttributeValueRequest.h"
#import "BSProjectAttributePriceRequest.h"
#import "BSProjectAttributeLineRequest.h"
#import "BSProjectTemplateRequest.h"
#import "BSProjectItemRequest.h"
#import "BSProjectCheckRequest.h"

@interface BSProjectRequest ()

@property (nonatomic, assign) BOOL isRequestSuccess;
@property (nonatomic, assign) NSInteger requestCount;
@property (nonatomic, assign) BOOL isNoErrorMessage;

@end

@implementation BSProjectRequest


static BSProjectRequest *mInstance;
+ (BSProjectRequest *)sharedInstance
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
                BSProjectItemRequest *request = [[BSProjectItemRequest alloc] initWithLastUpdate];
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

- (void)startProjectRequest
{
    self.requestCount = 5;
    self.isRequestSuccess = YES;
    BSBornCategoryRequest *bornCategoryRequest = [[BSBornCategoryRequest alloc] init];
    [bornCategoryRequest execute];
    
    BSProjectCategoryRequest *categoryRequest = [[BSProjectCategoryRequest alloc] init];
    [categoryRequest execute];
    
    BSProjectUomCategoryRequest *uomCategoryRequest = [[BSProjectUomCategoryRequest alloc] init];
    [uomCategoryRequest execute];
    
    BSProjectConsumableRequest *consumableRequest = [[BSProjectConsumableRequest alloc] init];
    [consumableRequest execute];
    
    BSProjectCheckRequest *checkRequest = [[BSProjectCheckRequest alloc] init];
    [checkRequest execute];
    
    BSProjectRelatedItemRequest *relatedRequest = [[BSProjectRelatedItemRequest alloc] initWithLastUpdate];
    [relatedRequest execute];
    
    //BSProjectAttributePriceRequest *attributePriceRequest = [[BSProjectAttributePriceRequest alloc] init];
    //[attributePriceRequest execute];
}

- (void)startProjectRequestNoErrorMSG
{
    self.isNoErrorMessage = YES;
    [self startProjectRequest];
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectRequestFailed object:nil userInfo:nil];
}

#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSBornCategoryResponse])
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
    else if ([notification.name isEqualToString:kBSProjectCategoryResponse])
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
    else if ([notification.name isEqualToString:kBSProjectCheckResponse])
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
    else if ([notification.name isEqualToString:kBSProjectUomCategoryResponse])
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
    else if ([notification.name isEqualToString:kBSProjectUomResponse])
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
    else if ([notification.name isEqualToString:kBSProjectConsumableResponse])
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
    else if ([notification.name isEqualToString:kBSProjectRelatedItemResponse])
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
    else if ([notification.name isEqualToString:kBSProjectAttributePriceResponse])
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
    else if ([notification.name isEqualToString:kBSProjectAttributeValueResponse])
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
    else if ([notification.name isEqualToString:kBSProjectAttributeResponse])
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
    else if ([notification.name isEqualToString:kBSProjectAttributeLineResponse])
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
    else if ([notification.name isEqualToString:kBSProjectTemplateResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            ;
        }
        else
        {
            self.isRequestSuccess = NO;
            self.errorMessage = [notification.userInfo stringValueForKey:@"rm"];
            [self requestFailed];
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
            self.isRequestSuccess = NO;
            self.errorMessage = [notification.userInfo stringValueForKey:@"rm"];
            [self requestFailed];
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
            self.isRequestSuccess = NO;
            self.errorMessage = [notification.userInfo stringValueForKey:@"rm"];
            [self requestFailed];
        }
    }
    else if ([notification.name isEqualToString:kBSProjectItemIDResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kBSProjectRequestSuccess object:nil userInfo:nil];
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
