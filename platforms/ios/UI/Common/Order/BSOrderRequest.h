//
//  BSOrderRequest.h
//  Boss
//
//  Created by XiaXianBing on 15/11/18.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSOrderRequest : NSObject

@property (nonatomic, strong) NSString *errorMessage;

+ (BSOrderRequest *)sharedInstance;

- (void)startOrderRequest;
- (void)startOrderRequestNoErrorMSG;

@end
