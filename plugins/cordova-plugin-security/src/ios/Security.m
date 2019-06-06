/********* Security.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <CommonCrypto/CommonDigest.h>
#import "HistoryOperateViewController.h"
#import "ProductProjectMainController.h"
#import "GuadanViewController.h"
#import "HistoryOperateViewController.h"
#import "ProjectViewController.h"
#import "StaffViewController.h"
#import "PanDianViewController.h"

@interface Security : CDVPlugin {
    // Member variables go here.
}


@end


static NSString* TAG = @"Security";
static NSString* BASE_SALT = @"a1f538ec9cf94cf2220b34357ac44f5e7a05rt5a";
static NSString* SALT = @"c1f538ec9cf94cf5660b94357ac44f5e7a05817a";
static NSString* ERROR_INVALID_PARAMETERS = @"参数格式错误";
static NSString* KEY_MODE = @"device_mode";
static NSString* KEY_PLATFORM = @"platform";
static NSString* KEY_UUID = @"device_uuid";
static NSString* KEY_VERSION = @"version";
static NSString* KEY_LATITUDE = @"latitude";
static NSString* KEY_LONGITUDE = @"longitude";
static NSString* KEY_LOGIN = @"login";
static NSString* KEY_UID = @"uid";
static NSString* KEY_SIGN_DATA = @"data";
static NSString* KEY_SIGN_TYPE = @"type";
static NSString* ENCODING = @"UTF-8";
#ifdef DEBUG
static NSString* SERVER_URL = @"http://devtop.we-erp.com/MAST/api/app_init";
#else
static NSString* SERVER_URL = @"http://we-erp.com/MAST/api/app_init";
#endif
static NSString* KEY_URL = @"url";
static NSString* KEY_DB = @"db";
static NSString* _httpUrl = @"";
static NSString* _db = @"";
static NSString* _userSecret = @"";

static NSString* LAUNCH_KEY_URL = @"launch_url";
static NSString* LAUNCH_KEY_DB = @"launch_db";
static NSString* LAUNCH_KEY_CID = @"launch_cid";
static NSString* LAUNCH_KEY_CATEGORY = @"launch_category";
static NSString* LAUNCH_KEY_UID = @"launch_uid";
static NSString* LAUNCH_KEY_MOBILE = @"launch_mobile";
static NSString* LAUNCH_KEY_SID = @"launch_sid";
@implementation Security



- (void)launch:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        
        
        CDVPluginResult* pluginResult = nil;
        NSDictionary* params = [command.arguments objectAtIndex:0];
        
        NSString* launchUrl = params[LAUNCH_KEY_URL];
        NSString* launchDb = params[LAUNCH_KEY_DB];
        NSString* launchCid = params[LAUNCH_KEY_CID];
        NSString* launchCategory = params[LAUNCH_KEY_CATEGORY];
        NSString* launchUid = params[LAUNCH_KEY_UID];
        NSString* launchMobile = params[LAUNCH_KEY_MOBILE];
        NSString* launchSid = params[LAUNCH_KEY_SID];
        
        //会员管理  member
        //收银  pos
        //挂单  resting
        //业绩考核  follow
        //仓库 stock
        //员工 employee
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            PersonalProfile *profile = [PersonalProfile currentProfile];
            if ( ![profile.userName isEqualToString:launchMobile] )
            {
                [PersonalProfile deleteProfile];
                profile = [PersonalProfile currentProfile];
            }
            
            if ( ![profile.isLogin boolValue] )
            {
                PersonalProfile *profile = [[PersonalProfile alloc] init];
                profile.baseUrl = launchUrl;
                profile.sql = launchDb;
                profile.userID = @([launchUid integerValue]);
                profile.userName = launchMobile;
                profile.deviceString = launchCid;
                
                [profile save];
                
                [ICKeyChainManager setCurrentServiceName:[profile.userID stringValue]];
                [BSCoreDataManager setCurrentUserName:[profile.userID stringValue]];
                
                BSLoginRequestStep3 *request = [[BSLoginRequestStep3 alloc] init];
                request.isLogin = TRUE;
                [request execute];
            }
            
            profile.bshopId = @(launchSid.integerValue);
            profile.homeSelectedShopID = @(launchSid.integerValue);
            [profile save];
            
            if ( [launchCategory isEqualToString:@"member"] )
            {
                CDStore *store = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDStore" withValue:launchSid forKey:@"storeID"];
                MemberViewController *viewController = [[MemberViewController alloc] initWithStore:store];
                [(UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:viewController animated:YES];
                
                
                //                HistoryOperateViewController *historyPosVC = [[HistoryOperateViewController alloc] init];
                //                [(UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:historyPosVC animated:YES];
                
            }
            else if ([launchCategory isEqualToString:@"hr"])
            {
                StaffViewController *staffVC = [[StaffViewController alloc] initWithNibName:NIBCT(@"StaffViewController") bundle:nil];
                staffVC.isOnlyShop = true;
                NSNumber *storeId = [PersonalProfile currentProfile].homeSelectedShopID;
                staffVC.shop = [[BSCoreDataManager currentManager] findEntity:@"CDStore" withValue:storeId forKey:@"storeID"];
                [(UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:staffVC animated:YES];
            }
            else if ([launchCategory isEqualToString:@"product"])
            {
                ProductProjectMainController *procuctVC = [[ProductProjectMainController alloc] init];
                [(UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:procuctVC animated:YES];
            }
            else if ([launchCategory isEqualToString:@"pos"])
            {
                ProductProjectMainController *projectMainVC = [[ProductProjectMainController alloc] init];
                projectMainVC.controllerType = ProductControllerType_Sale;
                [(UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:projectMainVC animated:YES];
            }
            else if ([launchCategory isEqualToString:@"order"])
            {
                GuadanViewController *guaDanVC = [[GuadanViewController alloc] init];
                [(UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:guaDanVC animated:YES];
            }
            else if ([launchCategory isEqualToString:@"historypos"])
            {
                HistoryOperateViewController *historyPosVC = [[HistoryOperateViewController alloc] init];
                [(UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:historyPosVC animated:YES];
            }
            else if ([launchCategory isEqualToString:@"inventory"])
            {
                PanDianViewController *panDianVC = [[PanDianViewController alloc] initWithNibName:NIBCT(@"PanDianViewController") bundle:nil];
                [(UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:panDianVC animated:YES];
            }
        });
    }];
}

- (void)sign:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* pluginResult = nil;
        NSDictionary* params = [command.arguments objectAtIndex:0];
        
        NSArray* allkeys = [params.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        
        NSMutableString* signData = [[NSMutableString alloc] init];
        [allkeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString* value = params[key];
            [signData appendFormat:@"%@=%@",key,value];
            if ( idx != allkeys.count - 1 )
            {
                [signData appendString:@"&"];
            }
        }];
        
        if ( signData.length == 0 || _userSecret.length == 0)
        {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:ERROR_INVALID_PARAMETERS];
        }
        else
        {
            NSString* sign = [self md5Hash:[NSString stringWithFormat:@"%@%@",signData,_userSecret]];
            NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:params];
            dict[@"sign"] = sign;
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
        }
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}


- (void)signCommon:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* pluginResult = nil;
        NSDictionary* params = [command.arguments objectAtIndex:0];
        
        NSArray* allkeys = [params.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        
        NSMutableString* signData = [[NSMutableString alloc] init];
        [allkeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString* value = params[key];
            [signData appendFormat:@"%@=%@",key,value];
            if ( idx != allkeys.count - 1 )
            {
                [signData appendString:@"&"];
            }
        }];
        
        NSString* sign = [self md5Hash:[NSString stringWithFormat:@"%@%@",signData,SALT]];
        NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:params];
        dict[@"sign"] = sign;
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}


- (void)deviceInit:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* pluginResult = nil;
        NSDictionary* params = [command.arguments objectAtIndex:0];
        
        NSString* device_mode = params[KEY_MODE];
        NSString* platform = params[KEY_PLATFORM];
        NSString* device_uuid = params[KEY_UUID];
        NSString* version = params[KEY_VERSION];
        NSString* latitude = params[KEY_LATITUDE];
        NSString* longitude = params[KEY_LONGITUDE];
        NSString* login = params[KEY_LOGIN];
        
        
        NSString* data = [NSString stringWithFormat:@"device_mode=%@&device_uuid=%@&latitude=%@&login=%@&longitude=%@&platform=%@&version=%@",device_mode,device_uuid,latitude,login,longitude,platform,version];
        
        NSString* sign = [self md5Hash:[NSString stringWithFormat:@"%@%@",data,BASE_SALT]];
        
        NSString* sendData = [NSString stringWithFormat:@"<xml><platform>%@</platform><longitude>%@</longitude><latitude>%@</latitude><device_uuid>%@</device_uuid><device_mode>%@</device_mode><version>%@</version><login>%@</login><sign>%@</sign></xml>",platform,longitude,latitude,device_uuid,device_mode,version,login,sign];
        
        
        NSMutableURLRequest* rq = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:SERVER_URL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
        [rq setHTTPMethod: @"POST"];
        [rq setValue:[NSString stringWithFormat:@"%ld",[sendData length]] forHTTPHeaderField:@"Content-Length"];
        [rq setValue:@"text/*;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [rq setHTTPBody:[sendData dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSError *error = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:rq returningResponse:nil error:&error];
        if ( responseData == nil )
        {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:ERROR_INVALID_PARAMETERS
                            ];
        }
        else
        {
            NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSLog(@"response: %@", responseString);
            
            NSDictionary* params = [NSJSONSerialization JSONObjectWithData:responseData options: NSJSONReadingMutableContainers error:nil];
            NSInteger errcode = [params[@"errcode"] integerValue];
            if ( errcode == 0 )
            {
                NSDictionary* rdata = params[@"data"];
                _httpUrl = rdata[@"url"];
                _db = rdata[@"db"];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:rdata];
                
            }
            else
            {
                NSString* errmsg = params[@"errmsg"];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errmsg
                                ];
            }
        }
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}




- (void)deviceRegister:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* pluginResult = nil;
        NSDictionary* params = [command.arguments objectAtIndex:0];
        
        NSString* device_mode = params[KEY_MODE];
        NSString* platform = params[KEY_PLATFORM];
        NSString* device_uuid = params[KEY_UUID];
        NSString* version = params[KEY_VERSION];
        NSString* latitude = params[KEY_LATITUDE];
        NSString* longitude = params[KEY_LONGITUDE];
        NSString* uid = params[KEY_UID];
        NSString* login = params[KEY_LOGIN];
        NSString* url = params[KEY_URL];
        NSString* db = params[KEY_DB];
        
        if ( url.length > 0 ){
            _httpUrl = url;
        }
        if ( db.length > 0 ){
            _db = db;
        }
        
        NSString* data = [NSString stringWithFormat:@"device_mode=%@&device_uuid=%@&latitude=%@&login=%@&longitude=%@&platform=%@&uid=%@&version=%@",device_mode,device_uuid,latitude,login,longitude,platform,uid,version];
        
        NSString* sign = [self md5Hash:[NSString stringWithFormat:@"%@%@",data,SALT]];
        
        NSString* sendData = [NSString stringWithFormat:@"<xml><platform>%@</platform><longitude>%@</longitude><latitude>%@</latitude><device_uuid>%@</device_uuid><device_mode>%@</device_mode><version>%@</version><uid>%@</uid><login>%@</login><sign>%@</sign></xml>",platform,longitude,latitude,device_uuid,device_mode,version,uid,login,sign];
        
        NSString* apiUrl = [NSString stringWithFormat:@"%@/%@/ds/device",_httpUrl,_db];
        
        NSMutableURLRequest* rq = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:apiUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
        [rq setHTTPMethod: @"POST"];
        [rq setValue:[NSString stringWithFormat:@"%ld",[sendData length]] forHTTPHeaderField:@"Content-Length"];
        [rq setValue:@"text/*;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [rq setHTTPBody:[sendData dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSError *error = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:rq returningResponse:nil error:&error];
        if ( responseData == nil )
        {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:ERROR_INVALID_PARAMETERS
                            ];
        }
        else
        {
            NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSLog(@"response: %@", responseString);
            
            NSDictionary* params = [NSJSONSerialization JSONObjectWithData:responseData options: NSJSONReadingMutableContainers error:nil];
            NSInteger errcode = [params[@"errcode"] integerValue];
            if ( errcode == 0 )
            {
                NSDictionary* rdata = params[@"data"];
                NSString* secret = rdata[@"secret"];
                NSInteger cid = [rdata[@"id"] integerValue];
                _userSecret = secret;
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:(int)cid];
            }
            else
            {
                NSString* errmsg = params[@"errmsg"];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errmsg
                                ];
            }
        }
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (NSString*)md5Hash:(NSString*)signString
{
    NSData* sign = [signString dataUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([sign bytes], (unsigned int)[sign length], result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

@end
