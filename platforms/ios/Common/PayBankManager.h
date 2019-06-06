//
//  PayBankManager.h
//  Boss
//
//  Created by jimmy on 16/1/19.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum PayBankAccountType
{
    PayBankAccountType_BlueTooth,
    PayBankAccountType_Audio
}PayBankAccountType;

@protocol PayBankManagerDelegate <NSObject>
- (void)pleaseSetUserName:(PayBankAccountType)type;
- (void)pleaseInstallVePos;
- (void)tradeSuccess:(NSString*)bankNo;
- (void)tradeFailed:(NSString*)errorMesage;
@end

@interface PayBankManager : NSObject

InterfaceSharedManager(PayBankManager)

- (void)payWithAccountType:(PayBankAccountType)type price:(NSString*)price device:(NSString *)device bankNo:(NSString*)bankNo delegate:(id<PayBankManagerDelegate>)delegate;
- (void)handleOpenURL:(NSURL *)url;

@property(nonatomic, weak)id<PayBankManagerDelegate> delegate;

@end
