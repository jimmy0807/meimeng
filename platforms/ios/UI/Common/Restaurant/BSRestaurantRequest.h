//
//  BSRestaurantRequest.h
//  Boss
//
//  Created by XiaXianBing on 2016-2-23.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSRestaurantRequest : NSObject

@property (nonatomic, strong) NSString *errorMessage;

+ (BSRestaurantRequest *)sharedInstance;

- (void)startRestaurantRequest;

@end
