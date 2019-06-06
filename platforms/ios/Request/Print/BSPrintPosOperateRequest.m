//
//  BSPrintPosOperateRequest.m
//  meim
//
//  Created by jimmy on 16/11/24.
//
//

#import "BSPrintPosOperateRequest.h"
#import "CBLoadingView.h"
#import "MBProgressHUD.h"
#import "AsyncUdpSocket.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#include <sys/select.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <netdb.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <sys/select.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <netdb.h>
#include <sys/ioctl.h>
#include <unistd.h>
#import "BSUserDefaultsManager.h"

@interface BSPrintPosOperateRequest ()
{
    BOOL isPrint;
}
@property(nonatomic, copy) void (^finishedBlock)(BOOL, NSString*);
@property(nonatomic, strong)NSMutableData* receivedData;
@property(nonatomic, strong)NSNumber* posOperateID;
@end

@implementation BSPrintPosOperateRequest

- (void)printWithPosOperateID:(NSNumber*)posOperateID
{
    //MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    //HUD.label.text = @"正在获取打印数据 请稍后...";

    PersonalProfile* profile = [PersonalProfile currentProfile];
    
    NSMutableURLRequest* rq = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@/web/session/authenticate",profile.baseUrl]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
    [rq setHTTPMethod: @"POST"];
    
    self.posOperateID = posOperateID;
    
    NSString* sendJson = [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\",\"method\":\"call\",\"params\":{\"db\":\"%@\",\"login\":\"%@\",\"password\":\"%@\"}}",profile.sql,profile.userName,profile.password];
    
    [rq setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [rq setHTTPBody:[sendJson dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection connectionWithRequest: rq delegate: self];
    
    //self.finishedBlock = finished;
    self.receivedData = [NSMutableData data];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if ( isPrint )
        return;
    
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([response isKindOfClass: [NSHTTPURLResponse class]])
    {
        
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if ( isPrint )
        return;
    
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSDictionary* result = [NSDictionary dictionaryWithJSONData:self.receivedData];
    if ( result )
    {
        NSString* session_id = result[@"result"][@"session_id"];
        
        PersonalProfile* profile = [PersonalProfile currentProfile];
        //10538
        NSString* encodeString = [self encodeString:[NSString stringWithFormat:@"[\"/report/pdf/born_member_card.report_card_book/%@?enable_editor=1\",\"qweb-pdf\"]",self.posOperateID]];
        NSString* token = [NSString stringWithFormat:@"%lld",(long long)([[NSDate date] timeIntervalSince1970] * 1000)];
        NSString* url = [NSString stringWithFormat:@"%@/report/download?data=%@&token=%@",profile.baseUrl, encodeString,token];
        
        NSMutableURLRequest* rq = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
        [rq setHTTPMethod: @"GET"];
        
        
        [rq setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
        
        NSDictionary *dictCookieUId = [NSDictionary dictionaryWithObjectsAndKeys:@"session_id", NSHTTPCookieName,session_id, NSHTTPCookieValue,@"/",NSHTTPCookiePath,
                                       @"test.com", NSHTTPCookieDomain,nil];//生成cookie的方法是先将cookie的各个property作为键值对生成dictionary
        
        NSHTTPCookie *cookieUserId = [NSHTTPCookie cookieWithProperties:dictCookieUId];//调用cookieWIthProperties生成cookie
        
        NSArray *arrCookies = [NSArray arrayWithObjects: cookieUserId, nil];
        NSDictionary *dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:arrCookies];//将cookie设置到头中
        [rq setValue: [dictCookies objectForKey:@"Cookie"] forHTTPHeaderField: @"Cookie"];
        
        [NSURLConnection connectionWithRequest: rq delegate: self];
        
        //self.finishedBlock = finished;
        self.receivedData = [NSMutableData data];
    }
    else
    {
        //NSString *result = [[NSString alloc] initWithData:self.receivedData  encoding:NSUTF8StringEncoding];
        
        //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //NSString *documentsDirectory = [paths objectAtIndex:0];
        
        //NSMutableString * path = [[NSMutableString alloc]initWithString:documentsDirectory];
        //[path appendString:@"/df.pdf"];
//
//        [self.receivedData writeToFile:path atomically:true];
        
        [self print];
        [self getBoardcastIP];
    }
    
//    if ( self.finishedBlock )
//    {
//        if ( [result[@"ret"] boolValue] )
//        {
//            //self.finishedBlock(true, [NSString stringWithFormat:@"%@%@",UploadPicToZimgUrl,result[@"info"][@"md5"]]);
//        }
//        else
//        {
//            //self.finishedBlock(false,@"");
//        }
//    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ( isPrint )
        return;

    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    if ( self.finishedBlock )
    {
        self.finishedBlock(false,@"");
    }
}

-(NSString*)encodeString:(NSString*)unencodedString
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

- (void)print
{
#if 0
    UIPrintInteractionController* printController = [UIPrintInteractionController sharedPrintController];
    
    if(printController )
    {
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"打印卡本";
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        printController.printInfo = printInfo;
        printController.showsPageRange = NO;
        
        printController.printingItem = self.receivedData;
        
        printController.showsNumberOfCopies = YES;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
            if (completed)
            {
                // 执行成功后的处理
                
            }
            else if (!completed && error)
            {
                // 执行失败后的处理
            }
        };
        
        [printController presentAnimated:YES completionHandler:completionHandler];
    }
#else
    isPrint = TRUE;
    
    NSString* ip = [BSUserDefaultsManager sharedManager].mPrintIP;
    if ( ip.length > 2 && self.receivedData )
    {
        NSMutableURLRequest* rq = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:6634",ip]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
        [rq setHTTPMethod: @"POST"];
        
        [rq setHTTPBody:self.receivedData];
        
        [NSURLConnection connectionWithRequest: rq delegate: self];
        
        self.receivedData = nil;
    }
#endif
}

- (void)getBoardcastIP
{
    AsyncUdpSocket *socket=[[AsyncUdpSocket alloc]initWithDelegate:self];
    [socket localPort];
    NSTimeInterval timeout=1;//发送超时时间
    NSString *request=@"getip";//发送给服务器的内容
    NSData *data=[NSData dataWithData:[request dataUsingEncoding:NSASCIIStringEncoding]];
    UInt16 port=6633;//端口
    NSError *error;
    //发送广播设置
    [socket enableBroadcast:YES error:&error];
    
    BOOL _isOK = [socket sendData :data toHost:@"255.255.255.255" port:port withTimeout:timeout tag:1];
    if (_isOK) {
        //udp请求成功
    }else{
        //udp请求失败
    }
    
    [socket receiveWithTimeout:2 tag:0];//启动接收线程 - n?秒超时
}

//接受信息
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
    
    NSString* result;
    
    result = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    if ( result.length < 5 )
        return FALSE;
    
    NSString* ip = [BSUserDefaultsManager sharedManager].mPrintIP;
    if ( ip == nil || ![ip isEqualToString:result] )
    {
        [BSUserDefaultsManager sharedManager].mPrintIP = result;
        [self print];
    }

    return NO;
}

//接受失败
-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error{
    
    NSLog(@"没有收到啊 ");
}

//发送失败
-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    
    NSLog(@"%@",error);
    
    NSLog(@"没有发送啊");
    
}

//开始发送
-(void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    
    NSLog(@"发送啦");
}

//关闭广播
-(void)onUdpSocketDidClose:(AsyncUdpSocket *)sock{
    
    NSLog(@"关闭啦");
}

@end
