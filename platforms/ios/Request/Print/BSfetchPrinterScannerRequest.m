//
//  BSfetchPrinterScannerRequest.m
//  meim
//
//  Created by jimmy on 17/3/21.
//
//

#import "BSfetchPrinterScannerRequest.h"

@implementation BSfetchPrinterScannerRequest

- (BOOL)willStart
{
    if ( [PersonalProfile currentProfile].printIP.length < 2 )
    {
        return FALSE;
    }
    
    PersonalProfile* profile = [PersonalProfile currentProfile];
    [self sendJsonUrl:[NSString stringWithFormat:@"%@/hw_proxy/scanner",profile.printIP] params:@{@"jsonrpc":@"2.0",@"method":@"call"}];
    
    return YES;
}

-(void)didFinishOnMainThread
{
    NSString* result = [resultDictionary valueForKey: @"result"];
    if ( result )
    {
        if ( result.length > 0 )
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchPrinterScannerResponse object:nil userInfo:@{@"result":result}];
        }
        
        [[[BSfetchPrinterScannerRequest alloc] init] execute];
    }
    else
    {
        [self performSelector:@selector(delayToSend) withObject:nil afterDelay:5];
    }
}

- (void)delayToSend
{
    [[[BSfetchPrinterScannerRequest alloc] init] execute];
}

@end
