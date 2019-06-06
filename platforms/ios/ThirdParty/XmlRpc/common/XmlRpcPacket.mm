//
//  XmlRpcPacket.cpp
//  WeiReport
//
//  Created by XiaXianBing on 14-6-13.
//
//

#include "XmlRpc.h"
#include "XmlRpcPacket.h"
#include "jsoncpp.h"

using namespace Json;
using namespace XmlRpc;

XmlRpc::XmlRpcValue XmlRpcValueWithJsonValue(Json::Value params)
{
    XmlRpcValue value;
    switch (params.type())
    {
        case nullValue:
            break;
            
        case intValue:
            value = (int)params.asInt64();
            break;
            
        case uintValue:
            value = (int)params.asUInt64();
            break;
            
        case realValue:
            value = params.asDouble();
            break;
            
        case stringValue:
            value = params.asCString();
            break;
            
        case booleanValue:
            value = params.asBool();
            break;
            
        case arrayValue:
        {
            XmlRpcValue subvar;
            if ( params.size() == 0 )
            {
                value[0] = subvar;
            }
            else
            {
                for (int i = 0; i < params.size(); i++)
                {
                    subvar = XmlRpcValueWithJsonValue(params[i]);
                    value[i] = subvar;
                }
            }
        }
            break;
            
        case objectValue:
        {
            Json::Value::Members members(params.getMemberNames());
            XmlRpcValue subvar;
            for (Json::Value::Members::iterator it = members.begin(); it != members.end(); ++it)
            {
                const std::string &key = *it;
                subvar = XmlRpcValueWithJsonValue(params[key]);
                value[key] = subvar;
            }
        }
            break;
            
        default:
            break;
    }
    
    return value;
}

std::string XmlRpcPacket::Packet(const char *method, const char *json)
{
    Json::Value jsonValue;
    Reader reader;
    reader.parse(json, jsonValue);
    XmlRpc::XmlRpcValue params = XmlRpcValueWithJsonValue(jsonValue);
    
    std::string body = XmlRpcClient::REQUEST_BEGIN;
    body += method;
    body += XmlRpcClient::REQUEST_END_METHODNAME;
    
    if (params.valid())
    {
        body += XmlRpcClient::PARAMS_TAG;
        if (params.getType() == XmlRpcValue::TypeArray)
        {
            for (int i=0; i<params.size(); ++i)
            {
                body += XmlRpcClient::PARAM_TAG;
                body += params[i].toXml();
                body += XmlRpcClient::PARAM_ETAG;
            }
        }
        else
        {
            body += XmlRpcClient::PARAM_TAG;
            body += params.toXml();
            body += XmlRpcClient::PARAM_ETAG;
        }
        body += XmlRpcClient::PARAMS_ETAG;
    }
    body += XmlRpcClient::REQUEST_END;
    
    return body;
}

inline NSObject * NSObjectWithXmlRpcValue(XmlRpc::XmlRpcValue params)
{
    switch (params.getType())
    {
        case XmlRpcValue::TypeInt:
            return [NSNumber numberWithInt:params.asInt()];
            break;
            
        case XmlRpcValue::TypeDouble:
            return [NSNumber numberWithDouble:params.asDouble()];
            break;
            
        case XmlRpcValue::TypeBoolean:
            return [NSNumber numberWithBool:params.asBoolean()];
            break;
            
        case XmlRpcValue::TypeString:
            return [NSString stringWithUTF8String:params.asString().c_str()];
            break;
            
        case XmlRpcValue::TypeDateTime:
        {
            struct tm *dateTime = params.asDateTime();
            NSString *datestr = [NSString stringWithFormat:@"%d-%d-%d %d:%d:%d", dateTime->tm_year, dateTime->tm_mon + 1, dateTime->tm_mday, dateTime->tm_hour, dateTime->tm_min, dateTime->tm_sec];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            return [dateFormatter dateFromString:datestr];
        }
            break;
            
        case XmlRpcValue::TypeBase64:
        {
            std::vector<char> array = params.asBinaryData();
            std::string str = "";
            for (char &subvar : array)
            {
                str.append(&subvar);
            }
            return [NSString stringWithUTF8String:str.c_str()];
        }
            break;
            
        case XmlRpcValue::TypeStruct:
        {
            NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
            
            std::map<std::string, XmlRpcValue> map = params.asValueStruct();
            for (auto iter = map.begin(); iter != map.end(); ++iter)
            {
                NSString *key = [NSString stringWithUTF8String:iter->first.c_str()];
                XmlRpcValue subvar = iter->second;
                [result setObject:NSObjectWithXmlRpcValue(subvar) forKey:key];
            }
            return [NSDictionary dictionaryWithDictionary:result];
        }
            break;
            
        case XmlRpcValue::TypeArray:
        {
            NSMutableArray *result = [[NSMutableArray alloc] init];
            
            std::vector<XmlRpcValue> array = params.asValueArray();
            for (XmlRpcValue &subvar : array)
            {
                [result addObject:NSObjectWithXmlRpcValue(subvar)];
            }
            return [NSArray arrayWithArray:result];
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

NSObject * XmlRpcPacket::NSObjectWithXmlString(const char *xml)
{
    int offset = 0;
    XmlRpc::XmlRpcValue value;
    if (XmlRpcUtil::findTag(XmlRpcClient::METHODRESPONSE_TAG, xml, &offset))
    {
        if (!XmlRpcUtil::nextTagIs(XmlRpcClient::FAULT_TAG, xml, &offset))
        {
            if (XmlRpcUtil::nextTagIs(XmlRpcClient::PARAMS_TAG, xml, &offset))
            {
                XmlRpcUtil::nextTagIs(XmlRpcClient::PARAM_TAG, xml, &offset);
            }
        }
        else
        {
            return nil;
        }
    }
    
    XmlRpcValue params(xml, &offset);
    
    NSObject *result = NSObjectWithXmlRpcValue(params);
    
    return result;
}

NSDictionary * XmlRpcPacket::errorArrayWithXmlString(const char *xml)
{
    int offset = 0;
    XmlRpc::XmlRpcValue value;
    if (XmlRpcUtil::findTag(XmlRpcClient::METHODRESPONSE_TAG, xml, &offset))
    {
        if ( XmlRpcUtil::nextTagIs(XmlRpcClient::FAULT_TAG, xml, &offset))
        {
            XmlRpcValue params(xml, &offset);
            NSObject *result = NSObjectWithXmlRpcValue(params);
            return (NSDictionary*)result;
        }
    }
    
    return nil;
}

inline Json::Value JsonValueWithXmlRpcValue(XmlRpc::XmlRpcValue params)
{
    Json::Value value;
    switch (params.getType())
    {
        case XmlRpcValue::TypeInt:
            return params.asInt();
            break;
            
        case XmlRpcValue::TypeDouble:
            return params.asDouble();
            break;
            
        case XmlRpcValue::TypeBoolean:
            return params.asBoolean();
            break;
            
        case XmlRpcValue::TypeString:
            return params.asString();
            break;
            
        case XmlRpcValue::TypeDateTime:
            return params.asDateTime();
            break;
            
        case XmlRpcValue::TypeBase64:
        {
            std::vector<char> array = params.asBinaryData();
            for (char &subvar : array)
            {
                value.append(JsonValueWithXmlRpcValue(subvar));
            }
        }
            break;
            
        case XmlRpcValue::TypeStruct:
        {
            std::map<std::string, XmlRpcValue> map = params.asValueStruct();
            for (auto iter = map.begin(); iter != map.end(); ++iter)
            {
                XmlRpcValue subvar = iter->second;
                value[iter->first.c_str()] = JsonValueWithXmlRpcValue(subvar);
            }
        }
            break;
            
        case XmlRpcValue::TypeArray:
        {
            std::vector<XmlRpcValue> array = params.asValueArray();
            for (XmlRpcValue &subvar : array)
            {
                value.append(JsonValueWithXmlRpcValue(subvar));
            }
        }
            break;
            
        default:
            return Json::nullValue;
            break;
    }
    
    return value;
}

std::string XmlRpcPacket::JsonStringWithXmlString(const char *xml)
{
    int offset = 0;
    XmlRpc::XmlRpcValue value;
    if (XmlRpcUtil::findTag(XmlRpcClient::METHODRESPONSE_TAG, xml, &offset))
    {
        if (!XmlRpcUtil::nextTagIs(XmlRpcClient::FAULT_TAG, xml, &offset))
        {
            if (XmlRpcUtil::nextTagIs(XmlRpcClient::PARAMS_TAG, xml, &offset))
            {
                XmlRpcUtil::nextTagIs(XmlRpcClient::PARAM_TAG, xml, &offset);
            }
        }
        else
        {
            return "";
        }
    }
    
    XmlRpcValue params(xml, &offset);
    Json::Value jsonValue = JsonValueWithXmlRpcValue(params);
    
    FastWriter writer;
    return writer.write(jsonValue);
}

std::string StringValueWithXmlRpcValue(XmlRpc::XmlRpcValue params, const char *key)
{
    if (params.getType() == XmlRpcValue::TypeStruct)
    {
        std::map<std::string, XmlRpcValue> map = params.asValueStruct();
        for (auto iter = map.begin(); iter != map.end(); ++iter)
        {
            if (iter->first.compare(key) == 0)
            {
                XmlRpcValue subvar = iter->second;
                if (subvar.getType() == XmlRpcValue::TypeString)
                {
                    return subvar.asString();
                }
            }
        }
    }
    else if (params.getType() == XmlRpcValue::TypeArray)
    {
        std::vector<XmlRpcValue> array = params.asValueArray();
        for (XmlRpcValue &subvar : array)
        {
            if (subvar.getType() == XmlRpcValue::TypeArray)
            {
                return StringValueWithXmlRpcValue(subvar, key);
            }
            else if (subvar.getType() == XmlRpcValue::TypeStruct)
            {
                return StringValueWithXmlRpcValue(subvar, key);
            }
        }
    }
    
    return "";
}

