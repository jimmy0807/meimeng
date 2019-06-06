//
//  BSPrintPosOperateRequestNew.m
//  meim
//
//  Created by jimmy on 17/3/21.
//
//

#import "BSPrintPosOperateRequestNew.h"
#import "MBProgressHUD.h"
#import "BSPrintOpenCashBoxRequest.h"
#import "CBLoadingView.h"
#import "PrintSettingView.h"
//#import "meim-Swift.h"
#ifdef meim_dev
#import "meim_dev-Swift.h"
#else
#import "meim-Swift.h"
#endif
typedef enum PrintStep
{
    PrintStep_FetchData = 0,
    PrintStep_Print
}PrintStep;

@interface BSPrintPosOperateRequestNew ()
@property(nonatomic, strong)NSString* sendData;
@property(nonatomic)PrintStep step;
@property(nonatomic)BOOL notShowLoadingView;
@end

@implementation BSPrintPosOperateRequestNew

- (BOOL)willStart
{
    if ( self.openCashBox )
    {
        [[[BSPrintOpenCashBoxRequest alloc] init] execute];
    }
    
    
    PersonalProfile* profile = [PersonalProfile currentProfile];
    if ( self.step == PrintStep_FetchData )
    {
        //MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        //HUD.label.text = @"正在获取打印数据 请稍后...";
        if ( self.hand )
        {
            if ( self.hand.print_url.length < 2 )
            {
                return FALSE;
            }
            //[self sendJsonUrl:[NSString stringWithFormat:@"%@/%@/print/born_prescription/%@",profile.baseUrl,profile.sql,self.hand.operate_id] params:nil httpMethod:@"GET"];

            NSString *urlString = [[NSString stringWithFormat:@"%@/%@/print/born_prescription/%@",profile.baseUrl,profile.sql,self.hand.operate_id] stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
            [self sendJsonUrl:urlString params:nil httpMethod:@"GET"];
        }
        else if ( self.jiaohao )
        {
            if ( self.jiaohao.print_url.length < 2 )
            {
                return FALSE;
            }
            //[self sendJsonUrl:[NSString stringWithFormat:@"%@/%@/print/born_prescription/%@",profile.baseUrl,profile.sql,self.jiaohao.jiaohao_id] params:nil httpMethod:@"GET"];

            NSString *urlString = [[NSString stringWithFormat:@"%@/%@/print/born_prescription/%@",profile.baseUrl,profile.sql,self.jiaohao.jiaohao_id] stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
            [self sendJsonUrl:urlString params:nil httpMethod:@"GET"];
        }
        else if (self.isYaofang && self.printUrl.length > 2)
        {
            NSString *urlString = [[NSString stringWithFormat:@"%@/%@",profile.baseUrl,self.printUrl] stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
            [self sendJsonUrl:urlString params:nil httpMethod:@"GET"];
        }
        else if (self.printUrl.length > 2)
        {
            [self sendJsonUrl:self.printUrl params:nil httpMethod:@"GET"];
        }
        else if (self.isAfterPayment)
        {
            if ( [PersonalProfile currentProfile].printUrl.length < 2 )
            {
                PrintSettingView *printSet = [[PrintSettingView alloc] init];
                
                [printSet show];
                return FALSE;
            }
            //[self sendJsonUrl:[NSString stringWithFormat:@"%@/%@/operate_print/report_pos/%@",profile.baseUrl,profile.sql,self.operateID] params:nil httpMethod:@"GET"];

            NSString *urlString = [[NSString stringWithFormat:@"%@/%@/operate_print/report_pos/%@",profile.baseUrl,profile.sql,self.operateID] stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
            [self sendJsonUrl:urlString params:nil httpMethod:@"GET"];
        }
        else
        {
            if ( [PersonalProfile currentProfile].printIP.length < 2 )
            {
                return FALSE;
            }
            //[self sendJsonUrl:[NSString stringWithFormat:@"%@/%@/api/get_xml_receipt/%@/%@",profile.baseUrl,profile.sql,profile.printType,self.operateID] params:nil httpMethod:@"GET"];

            NSString *urlString = [[NSString stringWithFormat:@"%@/%@/api/get_xml_receipt/%@/%@",profile.baseUrl,profile.sql,profile.printType,self.operateID] stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
            [self sendJsonUrl:urlString params:nil httpMethod:@"GET"];
        }
    }
    else
    {
        if ( self.hand )
        {
            if ( self.hand.print_url.length < 2 )
            {
                return FALSE;
            }
            //[self sendJsonUrl:[NSString stringWithFormat:@"%@/hw_proxy/print_xml_receipt",self.hand.print_url] params:@{@"jsonrpc":@"2.0",@"method":@"call",@"params":@{@"receipt": self.sendData}}];

            NSString *urlString = [[NSString stringWithFormat:@"%@/hw_proxy/print_xml_receipt",self.hand.print_url] stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
            [self sendJsonUrl:urlString params:@{@"jsonrpc":@"2.0",@"method":@"call",@"params":@{@"receipt": self.sendData}}];
        }
        else if ( self.jiaohao )
        {
            if ( self.jiaohao.print_url.length < 2 )
            {
                return FALSE;
            }
            //[self sendJsonUrl:[NSString stringWithFormat:@"%@/hw_proxy/print_xml_receipt",self.jiaohao.print_url] params:@{@"jsonrpc":@"2.0",@"method":@"call",@"params":@{@"receipt": self.sendData}}];

            NSString *urlString = [[NSString stringWithFormat:@"%@/hw_proxy/print_xml_receipt",self.jiaohao.print_url] stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
            [self sendJsonUrl:urlString params:@{@"jsonrpc":@"2.0",@"method":@"call",@"params":@{@"receipt": self.sendData}}];
        }
        else if (self.isAfterPayment)
        {
            NSLog(@"%@",profile.printIP);
            NSLog(@"%@",profile.printUrl);
            NSLog(@"%@",self.sendData);
            if ( [PersonalProfile currentProfile].printUrl.length < 2 )
            {
                PrintSettingView *printSet = [[PrintSettingView alloc] init];
                
                [printSet show];
                return FALSE;
            }
            //[self sendJsonUrl:[NSString stringWithFormat:@"%@hw_proxy/print_xml_receipt",profile.printUrl] params:@{@"jsonrpc":@"2.0",@"method":@"call",@"params":@{@"receipt": self.sendData}}];

            NSString *urlString = [[NSString stringWithFormat:@"%@/hw_proxy/print_xml_receipt",profile.printUrl] stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
            [self sendJsonUrl:urlString params:@{@"jsonrpc":@"2.0",@"method":@"call",@"params":@{@"receipt": self.sendData}}];
        }
        else if (self.isYaofang && self.printUrl.length > 2)
        {
            NSLog(@"%@",profile.printIP);
            NSString *urlString = [NSString stringWithFormat:@"%@hw_proxy/print_xml_receipt",profile.printUrl];
            [self sendJsonUrl:urlString params:@{@"jsonrpc":@"2.0",@"method":@"call",@"params":@{@"receipt": self.sendData}}];
        }
        else
        {
            if ( [PersonalProfile currentProfile].printIP.length < 2 )
            {
                return FALSE;
            }
            //[self sendJsonUrl:[NSString stringWithFormat:@"%@/hw_proxy/print_xml_receipt",profile.printIP] params:@{@"jsonrpc":@"2.0",@"method":@"call",@"params":@{@"receipt": self.sendData}}];

            NSString *urlString = [[NSString stringWithFormat:@"%@/hw_proxy/print_xml_receipt",profile.printIP] stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
            [self sendJsonUrl:urlString params:@{@"jsonrpc":@"2.0",@"method":@"call",@"params":@{@"receipt": self.sendData}}];
        }
    }
    
    if ( !self.notShowLoadingView )
    {
        [[CBLoadingView shareLoadingView] show];
    }
    
    return YES;
}

-(void)didFinishOnMainThread
{
    [[CBLoadingView shareLoadingView] hide];
    if ( self.step == PrintStep_FetchData )
    {
        NSDictionary* data = [resultDictionary valueForKey: @"data"];
        if ( [data isKindOfClass:[NSDictionary class]] && data[@"receipt"] )
        {
            [[CBLoadingView shareLoadingView] show];
            BSPrintPosOperateRequestNew* r = [[BSPrintPosOperateRequestNew alloc] init];
            r.sendData = data[@"receipt"];
            r.step = PrintStep_Print;
            r.hand = self.hand;
            r.jiaohao = self.jiaohao;
            r.isAfterPayment = self.isAfterPayment;
            r.isYaofang = self.isYaofang;
            r.notShowLoadingView = TRUE;
            r.printUrl = self.printUrl;
            [r execute];
        }
        else
        {
            UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"从服务器获取单据失败" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [v show];
            //MBProgressHUD *HUD = [MBProgressHUD HUDForView:[UIApplication sharedApplication].keyWindow];
            //HUD.label.text = @"请求发生错误";
            //[HUD hide:YES afterDelay:1.5];
        }
    }
    else
    {
        if ( [resultDictionary stringValueForKey: @"jsonrpc"].length > 1 )
        {
            if (self.isAfterPayment || self.isYaofang) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kBSPrinterSuccessResponse object:nil userInfo:nil];
            }
            
            if (!self.isYaofang) {
                JumpWorkFlowRequest* request = [[JumpWorkFlowRequest alloc] init];
                NSMutableDictionary* params = [NSMutableDictionary dictionary];
                params[@"is_print_operate"] = @(TRUE);
                if ( self.hand )
                {
                    params[@"operate_id"] = self.hand.operate_id;
                }
                else if ( self.jiaohao )
                {
                    params[@"operate_id"] = self.jiaohao.jiaohao_id;
                }
                else
                {
                    params[@"operate_id"] = self.operateID;
                }
                request.params = params;
                [request execute];
                
                self.jiaohao.is_print = @(TRUE);
                
                request.finished = ^(NSDictionary *params) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kBSPrinterSuccessResponse object:nil userInfo:nil];
                };
            }
        }
        else
        {
            PrintSettingView *printSet = [[PrintSettingView alloc] init];
            
            [printSet show];
//            UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"打印失败" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
//            [v show];
        }
        
        //[MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    }
   // NSString* result = [resultDictionary valueForKey: @"result"];
   // [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchPrinterStatusResponse object:nil userInfo:resultDictionary];
}

@end
