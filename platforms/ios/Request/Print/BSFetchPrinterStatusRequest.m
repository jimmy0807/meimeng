//
//  BSFetchPrinterStatusRequest.m
//  meim
//
//  Created by jimmy on 17/3/21.
//
//

#import "BSFetchPrinterStatusRequest.h"
#import "BSPrinterManager.h"

@implementation BSFetchPrinterStatusRequest

- (BOOL)willStart
{
    if ( [PersonalProfile currentProfile].printIP.length < 2 )
    {
        return FALSE;
    }
    
    PersonalProfile* profile = [PersonalProfile currentProfile];
    [self sendJsonUrl:[NSString stringWithFormat:@"%@/hw_proxy/status_json",profile.printIP] params:@{@"jsonrpc":@"2.0",@"method":@"call"}];
    
    return YES;
}

-(void)didFinishOnMainThread
{
    NSMutableDictionary* result = [resultDictionary valueForKey: @"result"];
    if ( result )
    {
        NSDictionary* scanner = result[@"scanner"];
        if ( [scanner[@"status"] isEqualToString:@"connected"] )
        {
            [BSPrinterManager sharedManager].isScannerConnected = TRUE;
        }
        else
        {
            [BSPrinterManager sharedManager].isScannerConnected = FALSE;
        }
        
        NSDictionary* escpos = result[@"escpos"];
        if ( [escpos[@"status"] isEqualToString:@"connected"] || [escpos[@"status"] isEqualToString:@"connecting"] )
        {
            [BSPrinterManager sharedManager].isPrinterConnected = TRUE;
        }
        else
        {
            [BSPrinterManager sharedManager].isPrinterConnected = FALSE;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchPrinterStatusResponse object:nil userInfo:resultDictionary];
}

@end
