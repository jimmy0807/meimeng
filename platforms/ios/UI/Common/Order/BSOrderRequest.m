//
//  BSOrderRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/11/18.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSOrderRequest.h"
#import "BSFetchPadOrderRequest.h"
#import "BSFetchPadOrderLineRequest.h"

@interface BSOrderRequest ()

@property (nonatomic, assign) BOOL isRequestSuccess;
@property (nonatomic, assign) BOOL isNoErrorMessage;

@end


@implementation BSOrderRequest

static BSOrderRequest *mInstance;
+ (BSOrderRequest *)sharedInstance
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
        [self registerNofitificationForMainThread:kBSFetchPadOrderResponse];
        [self registerNofitificationForMainThread:kBSFetchPadOrderLineResponse];
    }
    
    return self;
}


#pragma mark -
#pragma mark Required Methods

- (void)startOrderRequest
{
    //BSFetchPadOrderRequest *request = [[BSFetchPadOrderRequest alloc] init];
    //[request execute];
}

- (void)startOrderRequestNoErrorMSG
{
    self.isNoErrorMessage = YES;
    [self startOrderRequest];
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSOrderRequestFailed object:nil userInfo:nil];
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSFetchPadOrderResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            ;
        }
        else
        {
            self.errorMessage = [notification.userInfo stringValueForKey:@"rm"];
            [self requestFailed];
        }
    }
    else if ([notification.name isEqualToString:kBSFetchPadOrderLineResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kBSOrderRequestSuccess object:nil userInfo:nil];
        }
        else
        {
            self.errorMessage = [notification.userInfo stringValueForKey:@"rm"];
            [self requestFailed];
        }
    }
}

@end
