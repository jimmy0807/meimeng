//
//  FetchWePosTranRequest.m
//  Boss
//
//  Created by jimmy on 16/4/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "FetchWePosTranRequest.h"
#import "NSData+Additions.h"
#import "POSHelper.h"
#import "TouchXML.h"

@interface FetchWePosTranRequest ()
@property(nonatomic, strong)NSString* phoneNumber;
@property(nonatomic, strong)NSString* tranMonth;
@property(nonatomic, strong)NSString* tranNo;
@end
@implementation FetchWePosTranRequest

- (instancetype)initWithPhoneNumber:(NSString*)phoneNumber tranMonth:(NSString*)tranMonth
{
    self = [super init];
    if ( self )
    {
        self.phoneNumber = phoneNumber;
        self.tranMonth = tranMonth;
    }
    
    return self;
}

- (instancetype)initWithPhoneNumber:(NSString*)phoneNumber tranNo:(NSString*)tranNo
{
    self = [super init];
    if ( self )
    {
        self.phoneNumber = phoneNumber;
        self.tranNo = tranNo;
    }
    
    return self;
}

- (BOOL)willStart
{
    if ( self.tranNo )
    {
        NSString* encodeString = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><EPOSPROTOCOL><TRANCODE>199044</TRANCODE><PHONENUMBER>%@</PHONENUMBER><LOGNO>%@</LOGNO></EPOSPROTOCOL>",self.phoneNumber,self.tranNo];
        NSString* PACKAGEMAC = [[[encodeString dataUsingEncoding:NSUTF8StringEncoding] md5Hash] uppercaseString];
        
        encodeString = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><EPOSPROTOCOL><TRANCODE>199044</TRANCODE><PHONENUMBER>%@</PHONENUMBER><LOGNO>%@</LOGNO><PACKAGEMAC>%@</PACKAGEMAC></EPOSPROTOCOL>",self.phoneNumber,self.tranNo,PACKAGEMAC];
        NSString* send = [POSHelper encrypt:encodeString];
        
        NSString* body = [NSString stringWithFormat:@"requestParam=%@",send];
        [self sendWePOSUrl:POSHelperURL2 body:body];
    }
    else
    {
        NSString* encodeString = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><EPOSPROTOCOL><TRANCODE>199043</TRANCODE><PHONENUMBER>%@</PHONENUMBER><MONTH>%@</MONTH></EPOSPROTOCOL>",self.phoneNumber,self.tranMonth];
        NSString* PACKAGEMAC = [[[encodeString dataUsingEncoding:NSUTF8StringEncoding] md5Hash] uppercaseString];
        
        encodeString = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><EPOSPROTOCOL><TRANCODE>199043</TRANCODE><PHONENUMBER>%@</PHONENUMBER><MONTH>%@</MONTH><PACKAGEMAC>%@</PACKAGEMAC></EPOSPROTOCOL>",self.phoneNumber,self.tranMonth,PACKAGEMAC];
        NSString* send = [POSHelper encrypt:encodeString];
        
        NSString* body = [NSString stringWithFormat:@"requestParam=%@",send];
        [self sendWePOSUrl:POSHelperURL body:body];
    }
    
    return YES;
}

- (void)didFinishOnMainThread
{
    NSString* decode = [POSHelper decrypt:self.resultStr];
    NSData* data = [decode dataUsingEncoding:NSUTF8StringEncoding];
    
    CXMLDocument *xmlDocument = [[CXMLDocument alloc] initWithData:data options:0 error:nil];
    
    CXMLNode * e = [xmlDocument nodeForXPath:@"EPOSPROTOCOL" error:nil];
    CXMLNode* targetNode = [e nodeForXPath:@"TRANDETAILS" error:nil];
    
    NSArray *resultNodes = [targetNode nodesForXPath:@"TRANDETAIL" error:nil];

    NSArray* tranList = [[BSCoreDataManager currentManager] fetchWePosTranWithMonth:self.tranMonth phoneNumber:self.phoneNumber];
    NSMutableArray* oldList = [NSMutableArray arrayWithArray:tranList];
    
    for (CXMLElement *resultListDocement in resultNodes)
    {
        NSString* tradeNo = [[resultListDocement nodeForXPath:@"LOGNO" error:nil] stringValue];
        
        CDWePosTran *pos = [[BSCoreDataManager currentManager] findEntity:@"CDWePosTran" withValue:tradeNo forKey:@"tradeNo"];
        if( pos == nil )
        {
            pos = [[BSCoreDataManager currentManager] insertEntity:@"CDWePosTran"];
            pos.tradeNo = tradeNo;
        }
        else
        {
            [oldList removeObject:pos];
        }
        
        pos.name = [[resultListDocement nodeForXPath:@"MERNAM" error:nil] stringValue];
        pos.canCancel = @([[[resultListDocement nodeForXPath:@"PAYCANCELFLG" error:nil] stringValue] integerValue]);
        pos.cardNo = [[resultListDocement nodeForXPath:@"CRDNO" error:nil] stringValue];
        pos.phoneNumber = self.phoneNumber;
        
        NSInteger money = [[[resultListDocement nodeForXPath:@"TXNAMT" error:nil] stringValue] integerValue];
        pos.money = @(1.0 * money / 100);
        
        NSString* time = [[resultListDocement nodeForXPath:@"SYSDAT" error:nil] stringValue];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"yyyyMMddHHmmss";
        NSDate *date = [dateFormat dateFromString:time];
        dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        pos.time = [dateFormat stringFromDate:date];
        dateFormat.dateFormat = @"yyyyMM";
        pos.year_month = [dateFormat stringFromDate:date];
        
        
        //NSString* name = [[resultListDocement attributeForName:@"class"] stringValue];
    }
    
    [[BSCoreDataManager currentManager] deleteObjects:oldList];
    [[BSCoreDataManager currentManager] save:nil];
}

@end
