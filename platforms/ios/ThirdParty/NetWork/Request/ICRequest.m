//
//  ICRequest.m
//  BetSize
//
//  Created by jimmy on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ICRequest.h"
#import "ICRequestManager.h"
#import "NSData+JSON.h"
#import "NSArray+JSON.h"
#import "NSData+Additions.h"
#import "NSDictionary+JSON.h"
#import "NSString+Additions.h"

#ifdef Using_RandomKeyForRequest
#import "PersonalProfile.h"
#import "CBMessageView.h"
#endif

@implementation ICRequest
@synthesize httpResp;
@synthesize auth = _auth;
@synthesize resultStr;
@synthesize resultDictionary;

- (void)dealloc
{
    if (_connection) 
    {
        [_connection cancel];
        [_connection release];
    }
    [_auth release];
    self.resultStr = nil;
    self.resultDictionary = nil;
    [httpResp release];
    [receivedData release];
#ifdef Xml_RPC_Request
    self.tableName = nil;
    self.filter = nil;
    self.field = nil;
    self.xmlStyle = nil;
#endif
    [super dealloc];
}

- (void)startDownloadWithUrl:(NSString*)url
{
    NSMutableURLRequest* rq = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
    [self performSelectorOnMainThread: @selector(doSendRequest:) withObject: rq waitUntilDone: YES];
   
}

- (void)sendJsonCommand:(NSString*)command params: (id)params httpMethod:(NSString *)method
{
    NSMutableString* baseUrl = [NSMutableString stringWithFormat: @"%@%@", SERVER_IP,command];
    
#ifdef Using_RandomKeyForRequest
    
    NSString *randomNum = [ICKeyChainManager getPasswordForUsername:USER_RandomNum];
    if (randomNum != nil)
    {
        if ([params respondsToSelector:@selector(setObject:forKey:)] && [[UIDevice currentDevice].systemVersion integerValue] >= 6.0 )
        {
            [params setObject:randomNum forKey:@"randomNum"];
        }
        else
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
            [dict setObject:randomNum forKey:@"randomNum"];
            params =  dict;
        }
    }
#endif

#ifdef CardBag_Project
    NSString *token = [ICKeyChainManager getPasswordForUsername:USER_PASSWORD];
    if (token != nil)
    {
        if ([params respondsToSelector:@selector(setObject:forKey:)] && [[UIDevice currentDevice].systemVersion integerValue] >= 6.0 )
        {
            [params setObject:token forKey:@"token"];
            [params setObject:[ICAuthentication authenticationFromUserDefaults].secret forKey:@"usercode"];
        }
        else
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
            [dict setObject:token forKey:@"token"];
            [dict setObject:[ICAuthentication authenticationFromUserDefaults].secret forKey:@"usercode"];
            params =  dict;
        }
    }
#endif
    
    NSData* httpBody = nil;
    if ( params )
    {
        if ( [method isEqualToString:@"GET"] )
        {
            [baseUrl appendString:@"?"];
            NSDictionary* dict = (NSDictionary*)params;
            for ( NSString* str in [dict allKeys] )
            {
                [baseUrl appendFormat:@"%@=%@&",str,[dict objectForKey:str]];
            }
            [baseUrl deleteCharactersInRange:NSMakeRange([baseUrl length] - 1, 1)];
        }
        else
        {
            httpBody = [NSData jsonDataWithObject: params];
        }
    }

    NSString* encodinUrl = [baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"baseUrl = %@",encodinUrl);
    NSMutableURLRequest* rq = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: encodinUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
#ifdef CardBag_Project
    [rq setHTTPMethod: @"POST"];
#else
    [rq setHTTPMethod: method];
#endif
    [rq addValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    NSString* secret = [ICAuthentication authenticationFromUserDefaults].secret;
    if (secret)
    {
        [rq addValue:secret forHTTPHeaderField: @"Authorization"];
        NSString* username = [ICAuthentication authenticationFromUserDefaults].userName;
        if ( [username length] > 0 )
        {
            [rq addValue:username forHTTPHeaderField: @"userID"];
        }
    }
    
    if ( httpBody )
    {
        NSLog(@"httpBody: %@", [NSString stringWithCString:[httpBody bytes] encoding: NSUTF8StringEncoding]);
        [rq setHTTPBody: httpBody];
    }
    
    [self performSelectorOnMainThread: @selector(doSendRequest:) withObject: rq waitUntilDone: YES];
}

- (void)sendJsonUrl:(NSString*)command params:(id)params
{
    [self sendJsonUrl:command params:params httpMethod:@"POST"];
}

- (void)sendJsonUrl:(NSString*)command params:(id)params httpMethod:(NSString *)method
{
    NSString* baseUrl = [command stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"baseUrl = %@",baseUrl);
    NSMutableURLRequest* rq = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: baseUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
    [rq setHTTPMethod: method];
    if ( [method isEqualToString:@"POST"] )
    {
        [rq addValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    }
    
    NSData* httpBody = nil;
    if ( params)
    {
        httpBody = [NSData jsonDataWithObject: params];
        [rq setHTTPBody: httpBody];
    }
    
    [self performSelectorOnMainThread: @selector(doSendRequest:) withObject: rq waitUntilDone: YES];
}

- (void)sendJsonPHPCommand:(NSString *)command params:(NSDictionary *)params httpMethod:(NSString *)method
{
    NSMutableString *baseUrl = [NSMutableString stringWithFormat: @"%@", command];
    
    NSData *httpBody = nil;
    if (params)
    {
        if ( [method isEqualToString:@"GET"] )
        {
            [baseUrl appendString:@"?"];
            NSDictionary* dict = (NSDictionary*)params;
            for ( NSString* str in [dict allKeys] )
            {
                [baseUrl appendFormat:@"%@=%@&",str,[dict objectForKey:str]];
            }
            [baseUrl deleteCharactersInRange:NSMakeRange([baseUrl length] - 1, 1)];
        }
        else
        {
            //[rq addValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
            //httpBody = [NSData jsonDataWithObject: params];
            
            NSMutableString *form = [[NSMutableString alloc] init];
            for ( NSString *key in [params allKeys] )
            {
                [form appendFormat:@"%@=%@&", key, [params objectForKey:key]];
            }
            [form deleteCharactersInRange:NSMakeRange([form length] - 1, 1)];
            
            httpBody = [form dataUsingEncoding:NSUTF8StringEncoding];
            [form release];
        }
    }
    
    NSString* encodinUrl = [baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"baseUrl = %@",encodinUrl);
    NSMutableURLRequest *rq = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:encodinUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    [rq setHTTPMethod:method];
    [rq addValue: @"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-Type"];
    [rq setHTTPBody:httpBody];
    
    [self performSelectorOnMainThread: @selector(doSendRequest:) withObject:rq waitUntilDone: YES];
}

- (void)sendJsonCommand:(NSString*)command params: (NSDictionary *)params httpMethod:(NSString *)method fileDataArray:(NSArray*)fileDataArray
{
    NSString* baseUrl = [NSString stringWithFormat: @"%@", FILE_IP];
    baseUrl = [NSString stringWithFormat:@"%@%@", baseUrl, command];
    baseUrl = [baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"baseUrl :%@",baseUrl);
    NSMutableURLRequest* rq = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: baseUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
    [rq setHTTPMethod: method];
    
    NSString* secret = [ICAuthentication authenticationFromUserDefaults].secret;
    if (secret)
    {
        [rq addValue:secret forHTTPHeaderField: @"Authorization"];
        NSString* username = [ICAuthentication authenticationFromUserDefaults].userName;
        if ( [username length] > 0 )
        {
            [rq addValue:username forHTTPHeaderField: @"username"];
        }
    }
    
    NSString* boundary = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    [rq setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary] forHTTPHeaderField:@"Content-Type"];
    NSData* boundaryBytes = [[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding];
    NSData* boundaryEndBytes = [[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* httpBody = [NSMutableData data];
    
    for ( NSData* fileData in fileDataArray )
    {
        NSLog(@"%d", fileData.length);
        [httpBody appendData:boundaryBytes];
        NSString* head = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"1.png\"\r\nContent-Type: application/octet-stream\r\n\r\n", @"filename"];
        [httpBody appendData:[head dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:fileData];
    }
    
    [httpBody appendData:boundaryEndBytes];
    [rq setValue:[NSString stringWithFormat:@"%d",[httpBody length]] forHTTPHeaderField:@"Content-Length"];
    [rq setHTTPBody: httpBody];
    
    [self performSelectorOnMainThread: @selector(doSendRequest:) withObject: rq waitUntilDone: YES];
}

- (void)sendXmlCommand:(NSString *)url params:(NSString *)params
{
    self.requestType = BNRequestXml;
    NSData *httpBody = [params dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest* rq = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    [rq setHTTPMethod: @"POST"];
    
    if (httpBody)
    {
        //NSLog(@"httpBody: %@", [NSString stringWithCString:[httpBody bytes] encoding:NSUTF8StringEncoding]);
        [rq setHTTPBody: httpBody];
    }
    
    [self performSelectorOnMainThread: @selector(doSendRequest:) withObject: rq waitUntilDone: YES];
}

- (void)sendWePOSUrl:(NSString *)url body:(NSString *)body
{
    self.requestType = BNRequestNoResponseDecode;
    
    NSMutableURLRequest* rq = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    
    if ( body.length > 0 )
    {
        NSData *httpBody = [body dataUsingEncoding:NSUTF8StringEncoding];
        [rq setHTTPBody: httpBody];
    }
    
    [rq setHTTPMethod: @"POST"];
    [rq addValue: @"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-Type"];
    
    [self performSelectorOnMainThread: @selector(doSendRequest:) withObject: rq waitUntilDone: YES];
}

#pragma mark - Xml_RPC_Request
#ifdef Xml_RPC_Request

-(void)setFilter:(NSArray *)filter
{
    if (_filter != filter) {
        [_filter release];
        if ( self.needCompany)
        {
            NSMutableArray *filterAry = [NSMutableArray arrayWithArray:filter];
            NSArray *shopIds = [PersonalProfile currentProfile].shopIds;
            if (shopIds.count > 0) {
                NSMutableArray* shopsArray = [NSMutableArray arrayWithArray:shopIds];
                [shopsArray addObject:@(FALSE)];
                [filterAry addObject:@[@"shop_id",@"in",shopsArray]];
            }
            _filter = [filterAry retain];
        }
        else
        {
            _filter = [filter retain];
        }
    }
}

-(NSMutableArray *)xmlRpcBaseParams
{
    PersonalProfile* profile = [PersonalProfile currentProfile];
    NSMutableArray* sendArray = [NSMutableArray arrayWithObjects:profile.sql,profile.userID,profile.deviceString,nil];
    
    return sendArray;
}

- (void)sendShopAssistantXmlSearchCountCommand
{
    self.xmlStyle = @"search_count";
    self.xmlRpcType = rpc_request_searchCount;
    [self sendShopAssistantXmlStandardCommand:@"/xmlrpc/2/object" params:nil method:@"execute"];
}

- (void)sendShopAssistantXmlSearchReadCommand
{
    self.xmlStyle = @"search_read";
    [self sendShopAssistantXmlSearchReadCommand:nil];
}

- (void)sendShopAssistantXmlSearchReadCommand:(NSArray*)params
{
    self.xmlStyle = @"search_read";
    [self sendShopAssistantXmlStandardCommand:@"/xmlrpc/2/object" params:params method:@"execute"];
}

- (void)sendShopAssistantXmlCreateCommand
{
    self.xmlStyle = @"create";
    self.xmlRpcType = rpc_request_create;
    [self sendShopAssistantXmlSearchReadCommand:nil];
}

- (void)sendShopAssistantXmlCreateCommand:(NSArray*)params
{
    self.xmlStyle = @"create";
    self.xmlRpcType = rpc_request_create;
    [self sendShopAssistantXmlStandardCommand:@"/xmlrpc/2/object" params:params method:@"execute"];
}

- (void)sendShopAssistantXmlCreateMultiCommand:(NSArray*)params
{
    self.xmlStyle = @"create_multi";
    self.xmlRpcType = rpc_request_create;
    [self sendShopAssistantXmlStandardCommand:@"/xmlrpc/2/object" params:params method:@"execute"];
}

- (void)sendShopAssistantXmlWriteExtCommand:(NSArray*)params
{
    self.xmlStyle = @"write_ext";
    self.xmlRpcType = rpc_request_write;
    [self sendShopAssistantXmlStandardCommand:@"/xmlrpc/2/object" params:params method:@"execute"];
}

- (void)sendShopAssistantXmlWriteCommand
{
    self.xmlStyle = @"write";
    self.xmlRpcType = rpc_request_write;
    [self sendShopAssistantXmlSearchReadCommand:nil];
}

- (void)sendShopAssistantXmlWriteCommand:(NSArray*)params
{
    self.xmlStyle = @"write";
    self.xmlRpcType = rpc_request_write;
    [self sendShopAssistantXmlStandardCommand:@"/xmlrpc/2/object" params:params method:@"execute"];
}

- (void)sendShopAssistantXmlStandardCommand:(NSString*)command params:(NSArray*)params method:(NSString*)method
{
    if ( !self.requestType )
    {
        self.requestType = BNRequestXml;
    }
    
    PersonalProfile* profile = [PersonalProfile currentProfile];
    
    NSMutableArray* sendArray = [NSMutableArray arrayWithObjects:profile.sql,profile.userID,profile.deviceString,self.tableName,self.xmlStyle, nil];
    
    if (self.xmlRpcType == rpc_request_create || self.xmlRpcType == rpc_request_write)
    {
        for (int i = 0; i < params.count; i++)
        {
            [sendArray addObject:[params objectAtIndex:i]];
        }
    }
    else if ( self.xmlRpcType == rpc_request_searchRead || self.xmlRpcType == rpc_request_searchCount )
    {
        if ( self.filter.count )
        {
            [sendArray addObject:self.filter];
            if ( self.xmlRpcType == rpc_request_searchRead )
            {
                if ( self.field.count )
                {
                    [sendArray addObject:self.field];
                }
                else
                {
                    [sendArray addObject:@""];
                }
            }
        }
        else if ( self.field.count )
        {
            [sendArray addObject:@""];
            [sendArray addObject:self.field];
        }
        else
        {
            [sendArray addObject:@""];
            if ( self.xmlRpcType == rpc_request_searchRead )
            {
                [sendArray addObject:@""];
            }
        }
        
        if ( self.xmlRpcType == rpc_request_searchRead )
        {
            if ( params && params.count > 0 )
            {
                for (NSObject *obj in params) {
                    [sendArray addObject:obj];
                }
                int count = params.count;
                while (count++ < 3) {
                    [sendArray addObject:@""];
                }
            }
            else
            {
                if (self.requestType != BNRequestXmlImage && self.xmlRpcType == rpc_request_searchRead) {
                    [sendArray addObject:@(0)];
                    [sendArray addObject:@""];
                    [sendArray addObject:@""];
                    
                }
            }
        }
    }
    
    if ( profile.userID )
    {
        NSString *datastr = [[sendArray toJsonData] md5Hash];
        NSString *str = [NSString stringWithFormat:@"%@%@", datastr, [profile token]];
        NSString *signstr = [[str dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
        NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:
                                     @{@"client_id"  : [profile deviceString],
                                       @"lang"          : @"zh_CN",
                                       @"sign_data"     : datastr,
                                       @"sign"          : signstr}];
        for ( NSDictionary* d in self.additionalParams )
        {
            [dict setObject:d.allValues[0] forKey:d.allKeys[0]];
        }
        
        [sendArray addObject:dict];
    }
    
    NSString *jsonStr = [BNXmlRpc jsonWithArray:sendArray];
    NSLog(@"send %@",jsonStr);
    
    NSString *xmlStr = [BNXmlRpc xmlMethod:method jsonString:jsonStr];
    
    NSData *httpBody = [xmlStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest* rq = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",profile.baseUrl,command]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:self.timeOut > 0 ? self.timeOut : 30];
    [rq setHTTPMethod: @"POST"];
    
    if (httpBody)
    {
        //NSLog(@"httpBody: %@", xmlStr);
        [rq setHTTPBody: httpBody];
    }
    
    [self performSelectorOnMainThread: @selector(doSendRequest:) withObject: rq waitUntilDone: YES];
}

//-(void)sendXmlWriteCommand
//{
//    self.xmlRpcType = rpc_request_write;
//    NSString *cmd =  @"/xmlrpc/2/object";
//    self.xmlStyle = @"write";
//    [self sendShopAssistantXmlStandardCommand:cmd params:nil method:@"excute"];
//}


- (void)sendRpcXmlStyle:(NSString *)xmlStyle params:(NSArray *)params
{
    self.xmlStyle = xmlStyle;
    [self sendRpcXmlCommand:nil method:nil params:params];
}

- (void)sendCustomRpcXmlStyle:(NSString *)xmlStyle params:(NSArray *)params
{
    self.xmlStyle = xmlStyle;
    [self sendCustomRpcXmlCommand:nil method:nil params:params];
}

- (void)sendRpcXmlCommand:(NSString *)command method:(NSString *)method params:(NSArray *)params
{
    if(command == nil)
    {
        command = @"/xmlrpc/2/object";
    }
    if (method == nil)
    {
        method = @"execute";
    }
    [self sendRpcXmlCommand:command method:method params:params custom:NO];
}

- (void)sendCustomRpcXmlCommand:(NSString *)command method:(NSString *)method params:(NSArray *)params
{
    if(command == nil)
    {
        command = @"/xmlrpc/2/object";
    }
    if (method == nil)
    {
        method = @"execute";
    }
    [self sendRpcXmlCommand:command method:method params:params custom:YES];
}

-(void)sendRpcXmlCommand:(NSString *)command method:(NSString *)method params:(NSArray *) params custom:(BOOL)custom
{
    self.requestType = BNRequestXml;
    NSMutableArray *sendArray = [self xmlRpcBaseParams];
    if (custom) {
        sendArray = [NSMutableArray array]; 
    }
    if (self.tableName) {
        [sendArray addObject:self.tableName];
    }
    if (self.xmlStyle) {
        [sendArray addObject:self.xmlStyle];
    }
    
    for (NSObject *object in params) {
        [sendArray addObject:object];
    }
    
    PersonalProfile* profile = [PersonalProfile currentProfile];
    if ( profile.userID)
    {
        
        NSString *datastr = [[sendArray toJsonData] md5Hash];
        NSString *str = [NSString stringWithFormat:@"%@%@", datastr, [[PersonalProfile currentProfile] token]];
        NSString *signstr = [[str dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
        
        NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:
                                     @{@"client_id"  : [profile deviceString],
                                       @"lang"          : @"zh_CN",
                                       @"sign_data"     : datastr,
                                       @"sign"          : signstr}];
        
        for ( NSDictionary* d in self.additionalParams )
        {
            [dict setObject:d.allValues[0] forKey:d.allKeys[0]];
        }
        
        [sendArray addObject:dict];
    }
    NSString *jsonStr = [BNXmlRpc jsonWithArray:sendArray];
    
    NSLog(@"send %@",jsonStr);
    
    NSString *xmlStr = [BNXmlRpc xmlMethod:method jsonString:jsonStr];
    
    NSData *httpBody = [xmlStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *rq = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",profile.baseUrl,command]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    [rq setHTTPMethod:@"POST"];
    
    if (httpBody)
    {
        //NSLog(@"httpBody: %@", [NSString stringWithCString:[httpBody bytes] encoding:NSUTF8StringEncoding]);
        [rq setHTTPBody: httpBody];
    }
    [self performSelectorOnMainThread:@selector(doSendRequest:) withObject:rq waitUntilDone:YES];
}

- (NSDictionary*)generateResponse
{
    return [self generateResponse:nil];
}

- (NSMutableDictionary*)generateResponse:(NSString*)defaultString
{
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    [params setValue:@(-1) forKey:@"rc"];
    
    if ( defaultString.length == 0 )
    {
        defaultString = @"服务器异常, 请稍后重试";
    }
    
    NSDictionary *errorDictionary= [BNXmlRpc errorArrayWithXmlRpc:resultStr];
    if ( [errorDictionary isKindOfClass:[NSDictionary class]] )
    {
        [params setValue:errorDictionary[@"faultString"] forKey:@"rm"];
    }
    else
    {
        [params setValue:defaultString forKey:@"rm"];
    }
    
    return params;
}
//9月份修改登录新增
- (NSMutableDictionary*)generateResponse:(NSString*)defaultString andErrorRet:(NSInteger)errorRet{
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    [params setValue:@(-1) forKey:@"rc"];
    
    if ( defaultString.length == 0 )
    {
        defaultString = @"服务器异常, 请稍后重试";
    }
    NSLog(@"resultStr%@",resultStr);
    NSDictionary *errorDictionary= [BNXmlRpc errorArrayWithXmlRpc:resultStr];
    NSLog(@"errorDictionary%@",errorDictionary);
    
    if ( [errorDictionary isKindOfClass:[NSDictionary class]] )
    {
        [params setValue:defaultString forKey:@"rm"];
    }
    else
    {
        [params setValue:defaultString forKey:@"rm"];
    }
    NSLog(@"params%@",params);
    return params;
}


- (NSMutableDictionary*)generateDsApiResponse:(NSDictionary*)dict
{
    NSString* defaultString = @"";
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    [params setValue:@(-1) forKey:@"rc"];
    
    if ( dict == nil )
    {
        defaultString = @"服务器异常, 请稍后重试";
    }
    else
    {
        if ( [dict[@"errcode"] integerValue] != 0 )
        {
            defaultString = dict[@"errmsg"];
        }
        else
        {
            [params setValue:@(0) forKey:@"rc"];
        }
    }
    
    [params setValue:defaultString forKey:@"rm"];
    
    return params;
}

- (void)sendWeVipCommend:(NSString*)command params:(NSDictionary *)params
{
    [self sendWeVipCommend:command params:params nosignKeys:nil];
}

- (void)sendWeVipCommend:(NSString *)command params:(NSDictionary *)params nosignKeys:(NSArray *)keys
{
    NSMutableString* baseUrl = nil;
#ifdef DEBUG
    baseUrl = [NSMutableString stringWithFormat:@"https://test.we-erp.com/VipApi/pos%@?",command];
#else
    baseUrl = [NSMutableString stringWithFormat:@"http://www.wevip.com/VipApi/pos%@?",command];
#endif
    
    NSMutableString *secretString = [NSMutableString string];
    NSArray *sortKeys = [[params allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    for ( NSString* str in sortKeys )
    {
        id value = [params objectForKey:str];
        if ([value isKindOfClass:[NSString class]])
        {
            value = [value urlEncode];
        }
        
        [baseUrl appendFormat:@"%@=%@&",str,value];
        if (![keys containsObject:str]) {
            [secretString appendFormat:@"%@=%@",str,[params objectForKey:str]];
        }
    }
    
    NSString *md5Sign = [[[NSString stringWithFormat:@"%@%@",secretString,@"a64c81c4120f5bab976b8185ae3c1541b38189931"] dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
    [baseUrl appendFormat:@"sign=%@",md5Sign];
    NSMutableURLRequest* rq = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:baseUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    [rq setHTTPMethod: @"POST"];
    
    
    [rq addValue: @"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-Type"];
    
    [self performSelectorOnMainThread: @selector(doSendRequest:) withObject:rq waitUntilDone: YES];
}

#endif
#pragma mark -
- (BOOL)execute
{
    BOOL bResult = [self willStart];
    
    if ( bResult )
    {
        [[ICRequestManager sharedManager] addRequest: self];
    }
    
    return bResult;
}

- (void)finish
{
//    NSString *received = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", received);
    if (receivedData)
    {
        if (self.requestType == BNRequestXml)
        {
            self.resultStr = [[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] autorelease];
        }
        else if (self.requestType == BNRequestXmlImage)
        {
            self.resultStr = [[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] autorelease];
        }
        else if ( self.requestType == BNRequestNoResponseDecode )
        {
            self.resultStr = [[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] autorelease];
        }
        else
        {
            self.resultDictionary = [NSDictionary dictionaryWithJSONData: receivedData];
        }
    }
    else
    {
        self.resultStr = @"";
        self.resultDictionary = nil;
    }
    
    if ([self didFinish])
    {
        [self performSelectorOnMainThread: @selector(didFinishOnMainThread) withObject: nil waitUntilDone: YES];
    }
    
    [self retain];
    [[ICRequestManager sharedManager] removeRequest: self];
    [self autorelease];
}

- (void)cancel
{
    isCancelled = YES;
    [_connection cancel];
    SAFE_RELEASE(_connection);
    SAFE_RELEASE(receivedData);
    [self retain];
    [[ICRequestManager sharedManager] removeRequest: self];
    [self autorelease];
}

- (BOOL)willStart
{
    return TRUE;
}

- (BOOL)didFinish
{
#ifdef Using_RandomKeyForRequest
 
    NSDictionary *responseDict = [resultDictionary objectForKey:@"response"];
    NSDictionary *responseHeader = [responseDict objectForKey:@"header"];
    //NSDictionary *responseBody = [responseDict objectForKey:@"body"];
    
    
    NSString* result = [responseHeader stringValueForKey:@"rc"];
    
   // NSNumber *number = [resultDictionary numberValueForKey:@"ret"];
    
    if ([result integerValue] == -7 &&[ICAuthentication authenticationFromUserDefaults].secret) {
        [PersonalProfile deleteProfile];
        [[NSNotificationCenter defaultCenter] postNotificationName:kCBFetchRandomNum object:nil userInfo:resultDictionary];
//        NSDictionary *msg = [resultDictionary objectForKey:@"msg"];
//        NSString *alertString = [NSString stringWithFormat:LS(@"LoginAtOtherPlaceAgain"),[msg objectForKey:@"loginTime"],[msg objectForKey:@"loginDevice"]];
        
//        NSString *alertString = [responseHeader objectForKey:@"rm"];
////        CBMessageView *message = [[CBMessageView alloc] initWithTitle:LS(@"LoginAtOtherPlaceAgain")];
////        [message show];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LS(@"ABAlertTitle") message:alertString delegate:nil cancelButtonTitle:LS(@"OK") otherButtonTitles:nil, nil];
//        [alertView show];
        return FALSE;
    }
   
#endif
    return TRUE;
}

- (void)didFinishOnMainThread
{
    
}

- (void)doSendRequest:(NSURLRequest*)request
{
    _connection = [[NSURLConnection connectionWithRequest: request delegate: self] retain];
    receivedData = [[NSMutableData data] retain];
    
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData: data];
    if ( [self respondsToSelector:@selector(didReceiveData)] )
    {
        readBytes = [receivedData length];
        [self performSelectorOnMainThread: @selector(didReceiveData) withObject: nil waitUntilDone: YES];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([response isKindOfClass: [NSHTTPURLResponse class]]) 
    {
        totalBytes = [response expectedContentLength];
        httpResp = (NSHTTPURLResponse*)[response retain];
        NSLog(@"response: %d", httpResp.statusCode);
        if (httpResp.statusCode == 444) {
            abort();
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSString* str = [NSString stringWithUTF8String: [receivedData bytes]];
    NSLog(@"%@ length: %.2fk",[self class], [receivedData length] / 1000.0);
    
    [self finish];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@ didFailWithError",[[self class] description]);
    [receivedData release];
    receivedData = nil;
    [self finish];
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    totalBytes = totalBytesExpectedToWrite;
    writtenBytes = totalBytesWritten;
    if ( [self respondsToSelector:@selector(didSendBodyData)] )
    {
        [self performSelectorOnMainThread: @selector(didSendBodyData) withObject: nil waitUntilDone: YES];
    }
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"didReceiveAuthenticationChallenge %@ %zd", [[challenge protectionSpace] authenticationMethod], (ssize_t) [challenge previousFailureCount]);
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        [[challenge sender]  useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        
        [[challenge sender]  continueWithoutCredentialForAuthenticationChallenge: challenge];
    }
}

@end
