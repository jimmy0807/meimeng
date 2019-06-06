//
//  BNXmlRpc.m
//  ShopAssistant
//
//  Created by XiaXianBing on 14-7-2.
//  Copyright (c) 2014年 jimmy. All rights reserved.
//

#import "BNXmlRpc.h"
#import "NSArray+Json.h"
#import "NSDictionary+JSON.h"
#include "XmlRpcPacket.h"
#import "SBJson.h"

@implementation BNXmlRpc

+ (NSString *)jsonWithArray:(NSArray *)array
{
    Class jsonSerializationClass = NSClassFromString(@"NSJSONSerialization");
    //IOS > 5.0
    if (jsonSerializationClass) {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
        if ([data length] > 0 && error == nil)
        {
            return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];;
        }
    }
    else
    {
        return [array JSONRepresentation];
    }
    return nil;
}

+ (NSString *)xmlLoginWithJsonString:(NSString *)jsonstr
{
    const char *jsonchar = [jsonstr cStringUsingEncoding:NSUTF8StringEncoding];
    std::string xmlstr = XmlRpcPacket::Packet("login", jsonchar);
    NSString *xml = [NSString stringWithCString:xmlstr.c_str() encoding:NSUTF8StringEncoding];
    
    return xml;
}

//+ (NSString *)xmlCreateWithJsonString:(NSString *)jsonstr
//{
//    const char *jsonchar = [jsonstr cStringUsingEncoding:NSUTF8StringEncoding];
//    std::string xmlstr = XmlRpcPacket::Packet("create", jsonchar);
//    NSString *xml = [NSString stringWithCString:xmlstr.c_str() encoding:NSUTF8StringEncoding];
//    
//    return xml;
//}

+ (NSString *)xmlExecuteWithJsonString:(NSString *)jsonstr
{
    const char *jsonchar = [jsonstr cStringUsingEncoding:NSUTF8StringEncoding];
    std::string xmlstr = XmlRpcPacket::Packet("execute", jsonchar);
    NSString *xml = [NSString stringWithCString:xmlstr.c_str() encoding:NSUTF8StringEncoding];
    
    return xml;
}

+ (NSString *)xmlMethod:(NSString *)method jsonString:(NSString *)jsonstr
{
    const char *methodchar = [method cStringUsingEncoding:NSUTF8StringEncoding];
    const char *jsonchar = [jsonstr cStringUsingEncoding:NSUTF8StringEncoding];
    std::string xmlstr = XmlRpcPacket::Packet(methodchar, jsonchar);
    NSString *xml = [NSString stringWithCString:xmlstr.c_str() encoding:NSUTF8StringEncoding];
    
    return xml;
}

+ (NSArray *)arrayWithXmlRpc:(NSString *)xmlstr
{
    if (xmlstr.length == 0)
    {
        return nil;
    }
    
    const char *xmlchar = [xmlstr cStringUsingEncoding:NSUTF8StringEncoding];
    NSObject *object = XmlRpcPacket::NSObjectWithXmlString(xmlchar);
    
    return (NSArray *)object;
}

+ (NSDictionary *)errorArrayWithXmlRpc:(NSString *)xmlstr
{
    if (xmlstr.length == 0)
    {
        return nil;
    }
    
    const char *xmlchar = [xmlstr cStringUsingEncoding:NSUTF8StringEncoding];
    NSObject *object = XmlRpcPacket::errorArrayWithXmlString(xmlchar);
    
    if ( [object isKindOfClass:[NSDictionary class]] )
    {
        return (NSDictionary *)object;
    }
    
    return [NSDictionary dictionary];
}

+ (NSDictionary *)dictionaryWithXmlRpc:(NSString *)xmlstr
{
    if (xmlstr.length == 0)
    {
        return nil;
    }
    
    const char *xmlchar = [xmlstr cStringUsingEncoding:NSUTF8StringEncoding];
    NSObject *object = XmlRpcPacket::NSObjectWithXmlString(xmlchar);
    
    if ( [object isKindOfClass:[NSDictionary class]] )
    {
        return (NSDictionary *)object;
    }
    
    return [NSDictionary dictionary];
}

+ (NSString *)stringWithXmlRpc:(NSString *)xmlStr
{
    const char *xmlchar = [xmlStr cStringUsingEncoding:NSUTF8StringEncoding];
    std::string jsonStr = XmlRpcPacket::JsonStringWithXmlString(xmlchar);
    return [NSString stringWithUTF8String:jsonStr.c_str()];
}


@end
