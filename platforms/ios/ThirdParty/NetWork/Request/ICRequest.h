//
//  ICRequest.h
//  BetSize
//
//  Created by jimmy on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICAuthentication.h"
#import "ICRequestDef.h"
#import "ICCommunicationManager.h"
#import "NSDictionary+NullObj.h"

#ifdef Xml_RPC_Request
#import "BNXmlRpc.h"
#import "PersonalProfile.h"
enum
{
    rpc_request_searchRead = 0,
    rpc_request_write = 1,
    rpc_request_create = 2,
    rpc_request_searchCount = 3
};

#endif

typedef enum BNRequestType
{
    BNRequestJson,
    BNRequestXml,
    BNRequestXmlImage,
    BNRequestNoResponseDecode
}BNRequestType;

@interface ICRequest : NSObject
{
    NSURLConnection* _connection;
    NSMutableData* receivedData;
    NSHTTPURLResponse* httpResp;
    NSString *resultStr;
    NSDictionary*  resultDictionary;
    BOOL    isCancelled;
    ICAuthentication* _auth;
    NSInteger totalBytes;
    NSInteger writtenBytes;
    NSInteger readBytes;
}

- (void)startDownloadWithUrl:(NSString*)url;
- (void)sendJsonCommand:(NSString *)command params:(NSDictionary *)params httpMethod:(NSString *)method;
- (void)sendJsonPHPCommand:(NSString *)command params:(NSDictionary *)params httpMethod:(NSString *)method;
- (void)sendJsonCommand:(NSString*)command params: (NSDictionary *)params httpMethod:(NSString *)method fileDataArray:(NSArray*)fileDataArray;
- (void)sendXmlCommand:(NSString *)command params:(NSString *)params;
- (void)sendWePOSUrl:(NSString *)url body:(NSString *)body;
- (void)sendJsonUrl:(NSString*)command params:(id)params;
- (void)sendJsonUrl:(NSString*)command params:(id)params httpMethod:(NSString *)method;

#ifdef Xml_RPC_Request
- (void)sendShopAssistantXmlSearchCountCommand;
- (void)sendShopAssistantXmlSearchReadCommand;
- (void)sendShopAssistantXmlSearchReadCommand:(NSArray*)params;
- (void)sendShopAssistantXmlCreateCommand;
- (void)sendShopAssistantXmlCreateCommand:(NSArray*)params;
- (void)sendShopAssistantXmlCreateMultiCommand:(NSArray*)params;
- (void)sendShopAssistantXmlWriteCommand;
- (void)sendShopAssistantXmlWriteExtCommand:(NSArray*)params;
- (void)sendShopAssistantXmlWriteCommand:(NSArray*)params;
- (void)sendShopAssistantXmlStandardCommand:(NSString*)command params:(NSArray*)params method:(NSString*)method;


- (void)sendRpcXmlStyle:(NSString *)xmlStyle params:(NSArray *)params;
- (void)sendCustomRpcXmlStyle:(NSString *)xmlStyle params:(NSArray *)params;
- (void)sendRpcXmlCommand:(NSString *)command method:(NSString *)method params:(NSArray *)params;
- (void)sendCustomRpcXmlCommand:(NSString *)command method:(NSString *)method params:(NSArray *)params;

@property(nonatomic, retain)NSArray* additionalParams;

- (NSMutableDictionary*)generateResponse;
- (NSMutableDictionary*)generateResponse:(NSString*)defaultString;
//9月份修改登录新增
- (NSMutableDictionary*)generateResponse:(NSString*)defaultString andErrorRet:(NSInteger)errorRet;
- (NSMutableDictionary*)generateDsApiResponse:(NSDictionary*)dict;
//- (void)sendXmlWriteCommand;
#endif

- (BOOL)execute;
- (void)finish;
- (void)cancel;

- (BOOL)willStart;

- (BOOL)didFinish;
- (void)didFinishOnMainThread;


@property (nonatomic, retain, readonly) NSHTTPURLResponse* httpResp;
@property (nonatomic, retain) ICAuthentication* auth;
@property (nonatomic, assign) BNRequestType requestType;
@property (nonatomic, retain) NSString *resultStr;
@property (nonatomic, retain) NSDictionary* resultDictionary;
@property (nonatomic)CGFloat timeOut;

#ifdef Xml_RPC_Request

@property (nonatomic, retain) NSString* tableName;
@property (nonatomic, retain) NSString* xmlStyle;
@property (nonatomic, retain) NSArray *field;
@property (nonatomic, retain) NSArray* filter;
@property (nonatomic, assign) NSInteger xmlRpcType;
@property (nonatomic, assign) BOOL needCompany;
@property (nonatomic, copy, nullable)void (^finished)(NSDictionary* params);

#endif

- (void)sendWeVipCommend:(NSString*)command params:(NSDictionary *)params;

- (void)sendWeVipCommend:(NSString*)command params:(NSDictionary *)params nosignKeys:(NSArray *)keys;

@end

