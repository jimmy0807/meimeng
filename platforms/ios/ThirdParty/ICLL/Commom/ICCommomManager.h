//
//  ICCommomManager.h
//  BetSize
//
//  Created by jimmy on 12-10-10.
//
//

#import <Foundation/Foundation.h>
#import "ICKeyChainManager.h"

#define ADKeyChainKey @"ADKeyChainKey"
#define UsingICManager @"UsingICManager" // 随便起个名字 否则会让人看到是AD的开关

@interface ICCommomManager : NSObject

+ (ICCommomManager*)sharedManager;

@property(nonatomic, readonly)NSString* language;
@property(nonatomic, readonly)NSString* currentVersion;
@property(nonatomic, readonly)NSString* udid;

- (BOOL)isAdvertiseCanShow;
- (void)setAdvertiseShow;

- (float)getIOSVersion;
- (void)savePhotoWithData:(NSData*)data toAlubm:(NSString*)album andDelegate:(id)delegate;

@end
