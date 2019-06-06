//
//  BSRestaurantRequest.m
//  Boss
//
//  Created by XiaXianBing on 2016-2-23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSRestaurantRequest.h"
#import "BSFetchRestaurantTableRequest.h"
#import "BSFetchRestaurantTableIDRequest.h"
#import "BSFetchRestaurantFloorRequest.h"
#import "BSFetchRestaurantFloorIDRequest.h"

@interface BSRestaurantRequest ()

@property (nonatomic, assign) BOOL isRequestSuccess;
@property (nonatomic, assign) NSInteger requestCount;
@property (nonatomic, assign) BOOL isNoErrorMessage;

@end


@implementation BSRestaurantRequest

@synthesize requestCount = _requestCount;

static BSRestaurantRequest *mInstance;
+ (BSRestaurantRequest *)sharedInstance
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
        [self registerNofitificationForMainThread:kFetchRestaurantTableResponse];
        [self registerNofitificationForMainThread:kFetchRestaurantTableIDResponse];
        [self registerNofitificationForMainThread:kFetchRestaurantFloorResponse];
        [self registerNofitificationForMainThread:kFetchRestaurantFloorIDResponse];
    }
    
    return self;
}


#pragma mark -
#pragma mark init Methods


#pragma mark -
#pragma mark Required Methods

- (void)startRestaurantRequest
{
    self.isRequestSuccess = YES;
    
    BSFetchRestaurantTableRequest *request = [[BSFetchRestaurantTableRequest alloc] initWithLastUpdate];
    [request execute];
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSRestaurantRequestFailed object:nil userInfo:nil];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kFetchRestaurantTableResponse])
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
    else if ([notification.name isEqualToString:kFetchRestaurantTableIDResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            BSFetchRestaurantFloorRequest *request = [[BSFetchRestaurantFloorRequest alloc] initWithLastUpdate];
            [request execute];
        }
        else
        {
            self.isRequestSuccess = NO;
            self.errorMessage = [notification.userInfo stringValueForKey:@"rm"];
            [self requestFailed];
        }
    }
    else if ([notification.name isEqualToString:kFetchRestaurantFloorResponse])
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
    else if ([notification.name isEqualToString:kFetchRestaurantFloorIDResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kBSRestaurantRequestSuccess object:nil userInfo:nil];
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
