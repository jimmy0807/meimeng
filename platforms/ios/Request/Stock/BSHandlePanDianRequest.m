//
//  BSHandlePanDianRequest.m
//  Boss
//
//  Created by lining on 15/7/23.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "BSHandlePanDianRequest.h"
#import "PersonalProfile.h"
#import "BSAutoPandianRequest.h"

@interface BSHandlePanDianRequest ()
@property(nonatomic, strong) CDPanDian *panDian;
@end

@implementation BSHandlePanDianRequest
- (id) initWithPanDian:(CDPanDian *)panDian type:(HandlePanDian)type
{
    self = [super init];
    if (self) {
        self.panDian = panDian;
        self.type = type;
    }
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"stock.inventory";
    if (self.type == HandlePanDian_create) {
        [self sendShopAssistantXmlCreateCommand:@[self.params]];
    }
    else if (self.type == HandlePanDian_edit)
    {
        [self sendShopAssistantXmlWriteCommand:@[@[self.panDian.pd_id],self.params]];
    }
    else if (self.type == HandlePanDian_cancel)
    {

        [self sendRpcXmlStyle:@"action_cancel_draft" params:@[@[self.panDian.pd_id]]];

    }
    else if (self.type == HandlePanDian_confirmed)
    {
        self.xmlStyle = @"action_done";

        [self sendRpcXmlStyle:@"action_done" params:@[@[self.panDian.pd_id]]];
    }
    else if (self.type == HandlePanDian_delete)
    {
        self.xmlStyle = @"unlink";
        [self sendRpcXmlStyle:@"unlink" params:@[@[self.panDian.pd_id]]];
    }
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (self.type == HandlePanDian_create) {
        
        if([retArray isKindOfClass:[NSNumber class]])
        {
            
            NSNumber *panDianId = (NSNumber *)retArray;
            self.panDian.pd_id = panDianId;
            [[BSCoreDataManager currentManager] save:nil];
            [dict setObject:@0 forKey:@"rc"];
        }
        else
        {
//           [[BSCoreDataManager currentManager] deleteObject:self.panDian];
//           [[BSCoreDataManager currentManager] save:nil];
            dict = [self generateResponse:@"创建失败，请稍后重试"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSCreatePanDianResponse object:nil userInfo:dict];
    }
    else if (self.type == HandlePanDian_edit)
    {
        if([retArray isKindOfClass:[NSNumber class]])
        {
            [dict setObject:@0 forKey:@"rc"];
        }
        else
        {
            dict = [self generateResponse:@"保存失败，请稍后重试"];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSEditPanDianResponse object:nil userInfo:dict];
       
    }
    else if (self.type == HandlePanDian_cancel)
    {
        if([retArray isKindOfClass:[NSNumber class]])
        {
            [dict setObject:@0 forKey:@"rc"];
            self.panDian.state = @"draft";
            [[BSCoreDataManager currentManager] save:nil];
        }
        else
        {
            dict = [self generateResponse:@"取消失败，请稍后重试"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSCancelConfirmPanDianResponse object:nil userInfo:dict];
    }
    else if (self.type == HandlePanDian_confirmed)
    {
        if([retArray isKindOfClass:[NSNumber class]])
        {
            [dict setObject:@0 forKey:@"rc"];
            self.panDian.state = @"done";
            [[BSCoreDataManager currentManager] save:nil];

        }
        else
        {
            dict = [self generateResponse:@"审核失败，请稍后重试"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSConfirmPanDianResponse object:nil userInfo:dict];
    }
    else if (self.type == HandlePanDian_delete)
    {
        if([retArray isKindOfClass:[NSNumber class]])
        {
            [dict setObject:@0 forKey:@"rc"];
            
        }
        else
        {
            dict = [self generateResponse:@"删除失败，请稍后重试"];
        }
         [[NSNotificationCenter defaultCenter] postNotificationName:kBSDeletePurchaseOrderResponse object:nil userInfo:dict];
    }
    
}

@end
