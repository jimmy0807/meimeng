//
//  PosAccountManager.h
//  Boss
//
//  Created by jimmy on 16/1/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PosAccountManager : NSObject

+ (void)setBLUserName:(NSString*)userName password:(NSString*)password;
+ (void)setAudioUserName:(NSString*)userName password:(NSString*)password;
+ (void)deleteBLUserName;
+ (void)deleteAudioUserName;
+ (NSString*)getBLUserName;
+ (NSString*)getBLPassword;
+ (NSString*)getAudioUserName;
+ (NSString*)getAudioPassword;

@end
