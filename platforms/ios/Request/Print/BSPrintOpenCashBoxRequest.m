//
//  BSPrintOpenCashBoxRequest.m
//  meim
//
//  Created by jimmy on 17/3/21.
//
//

#import "BSPrintOpenCashBoxRequest.h"

@implementation BSPrintOpenCashBoxRequest

- (BOOL)willStart
{
    if ( [PersonalProfile currentProfile].printIP.length < 2 )
    {
        return FALSE;
    }
    
    PersonalProfile* profile = [PersonalProfile currentProfile];
    [self sendJsonUrl:[NSString stringWithFormat:@"%@/hw_proxy/open_cashbox",profile.printIP] params:@{@"jsonrpc":@"2.0",@"method":@"call"}];
    
    return YES;
}

-(void)didFinishOnMainThread
{
    //NSString* result = [resultDictionary valueForKey: @"result"];
    //[[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchPrinterStatusResponse object:nil userInfo:resultDictionary];
}

@end
