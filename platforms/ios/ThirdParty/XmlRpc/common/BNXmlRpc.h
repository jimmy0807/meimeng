//
//  BNXmlRpc.h
//  ShopAssistant
//
//  Created by XiaXianBing on 14-7-2.
//  Copyright (c) 2014年 jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface BNXmlRpc : NSObject <NSXMLParserDelegate>

+ (NSString *)jsonWithArray:(NSArray *)array;
+ (NSString *)xmlLoginWithJsonString:(NSString *)jsonstr;
//+ (NSString *)xmlCreateWithJsonString:(NSString *)jsonstr;
+ (NSString *)xmlExecuteWithJsonString:(NSString *)jsonstr;
+ (NSString *)xmlMethod:(NSString *)method jsonString:(NSString *)jsonstr;
+ (NSArray *)arrayWithXmlRpc:(NSString *)xmlstr;
+ (NSDictionary *)errorArrayWithXmlRpc:(NSString *)xmlstr;
+ (NSDictionary *)dictionaryWithXmlRpc:(NSString *)xmlstr;
+ (NSString *)stringWithXmlRpc:(NSString *)xmlStr;
@end
