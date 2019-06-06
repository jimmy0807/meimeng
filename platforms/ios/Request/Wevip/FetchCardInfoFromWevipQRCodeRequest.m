//
//  FetchCardInfoFromWevipQRCodeReqeust.m
//  Boss
//
//  Created by jimmy on 15/11/12.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "FetchCardInfoFromWevipQRCodeRequest.h"

@interface FetchCardInfoFromWevipQRCodeReqeust ()
@property(nonatomic, strong)NSString* QRCode;
@end

@implementation FetchCardInfoFromWevipQRCodeReqeust

- (instancetype)initWithQRCode:(NSString*)QRCode
{
    self = [super init];
    if (self)
    {
        self.QRCode = QRCode;
    }
    
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    
    [self sendWeVipCommend:@"/getCard" params:@{@"code":self.QRCode,@"company_uuid":[PersonalProfile currentProfile].companyUUID}];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kFetchCardInfoFromWevipQRCodeResponse object:nil userInfo:self.resultDictionary];
}

@end
