//
//  XmlRpcPacket.h
//  WeiReport
//
//  Created by XiaXianBing on 14-6-13.
//
//

#ifndef __WeiReport__XmlRpcPacket__
#define __WeiReport__XmlRpcPacket__

#include <iostream>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

class XmlRpcPacket
{
public:
    static std::string Packet(const char *method, const char *json);
    static std::string JsonStringWithXmlString(const char *xml);
    static NSObject * NSObjectWithXmlString(const char *xml);
    static NSDictionary *errorArrayWithXmlString(const char *xml);
};

#endif
