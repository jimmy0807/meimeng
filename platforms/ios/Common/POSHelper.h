//
//  POSHelper.h
//  Boss
//
//  Created by jimmy on 16/4/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

#define POSHelperURL @"http://112.124.32.157:8999/Mpay_mng/199043.tranm"
#define POSHelperURL2 @"http://112.124.32.157:8999/Mpay_mng/199044.tranm"

@interface POSHelper : NSObject
+ (NSString*)decrypt:(NSString*)encryptText;
+ (NSString*)decrypt:(NSString*)encryptText password:(NSString *)pwd;
+ (NSString*)encrypt:(NSString*)plainText;
+ (NSString*)encrypt:(NSString*)plainText password:(NSString *)pwd;
@end
