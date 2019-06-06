//
//  EditWashHandRequest.m
//  meim
//
//  Created by jimmy on 2017/6/27.
//
//

#import "EditWashHandRequest.h"
#import "NSArray+JSON.h"

@implementation EditWashHandRequest

- (id)init
{
    self = [super init];
    if ( self )
    {
        self.params = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (BOOL)willStart
{
    PersonalProfile *profile = [PersonalProfile currentProfile];
    [self.params setObject:profile.userID forKey:@"user_id"];
    
    if ( self.notGoNext )
    {
        [self.params setObject:self.wash.state forKey:@"state"];
    }
    else
    {
        if ( self.isCancel )
        {
            [self.params setObject:@"draft" forKey:@"state"];
        }
        else
        {
            if ( [self.wash.state isEqualToString:@"waiting"] )
            {
                [self.params setObject:@"doing" forKey:@"state"];
            }
            else if ( [self.wash.state isEqualToString:@"doing"] )
            {
                [self.params setObject:@"done" forKey:@"state"];
            }
            else if ( [self.wash.state isEqualToString:@"done"] )
            {
                [self.params setObject:@"done" forKey:@"state"];
            }
        }
    }
    if (self.wash.role_option != nil)
    {
        [self.params setObject:self.wash.role_option forKey:@"role_option"];
    }
    if (self.wash.operate_activity_id != nil)
    {
        [self.params setObject:self.wash.operate_activity_id forKey:@"operate_activity_id"];
    }
    if (self.wash.operate_id != nil)
    {
        [self.params setObject:self.wash.operate_id forKey:@"operate_id"];
    }
    if (self.wash.doctor_id != nil)
    {
        [self.params setObject:self.wash.doctor_id forKey:@"doctor_id"];
    }
    if (self.wash.peitai_nurse_id != nil)
    {
        [self.params setObject:self.wash.peitai_nurse_id forKey:@"peitai_nurse_id"];
    }
    if (self.wash.xunhui_nurse_id != nil)
    {
        [self.params setObject:self.wash.xunhui_nurse_id forKey:@"xunhui_nurse_id"];
    }
    if (self.wash.anesthetist_id != nil)
    {
        [self.params setObject:self.wash.anesthetist_id forKey:@"anesthetist_id"];
    }
    if (self.wash.yimei_operate_employee_ids != nil)
    {
        [self.params setObject:self.wash.yimei_operate_employee_ids forKey:@"operate_employee_ids"];
    }
    if (self.wash.medical_note != nil)
    {
        [self.params setObject:self.wash.medical_note forKey:@"medical_note"];
    }
    if (self.wash.diagnose != nil)
    {
        [self.params setObject:self.wash.diagnose forKey:@"diagnose"];
    }
    if (self.wash.treatment != nil)
    {
        [self.params setObject:self.wash.treatment forKey:@"treatment"];
    }
    if (self.wash.consumable_ids != nil && self.wash.consumable_ids.length > 0) {
        NSMutableArray *consumeArray = [NSMutableArray array];
        for (NSString *consumeProductString in [self.wash.consumable_ids componentsSeparatedByString:@","])
        {
            NSMutableDictionary *consumeProduct = [NSMutableDictionary dictionary];
            if ( [consumeProductString componentsSeparatedByString:@"@"].count > 3 )
            {
                [consumeProduct setObject:[consumeProductString componentsSeparatedByString:@"@"][1] forKey:@"qty"];
                [consumeProduct setObject:[consumeProductString componentsSeparatedByString:@"@"][2] forKey:@"consume_true_qty"];
                [consumeProduct setObject:[consumeProductString componentsSeparatedByString:@"@"][3] forKey:@"product_id"];
                [consumeProduct setObject:[consumeProductString componentsSeparatedByString:@"@"][4] forKey:@"id"];
                [consumeArray addObject:consumeProduct];
            }
            
//                            [consumArray addObject:[NSString stringWithFormat:@"%@@%@@%@@%@@%@", [consumable objectForKey:@"name"], [consumable objectForKey:@"qty"], [consumable objectForKey:@"consume_true_qty"], [consumable objectForKey:@"product_id"], [consumable objectForKey:@"id"]]];

        }
        [self.params setObject:[consumeArray toJsonString] forKey:@"consumable_ids"];
    }
    
    if ( profile.yimeiWorkFlowArray.count > 0 )
    {
        [self.params setObject:profile.yimeiWorkFlowArray[0] forKey:@"workflow_item_id"];
    }
    
    [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"pos_operate_update" params:@[self.params]];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSDictionary *resultList = [BNXmlRpc dictionaryWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [self generateDsApiResponse:resultList];
    
    if (resultStr.length != 0 && resultList != nil && [resultList isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *resuntDitc = (NSDictionary *)resultList;
        NSDictionary *data = [resuntDitc objectForKey:@"data"];
        if ( data && [resuntDitc[@"errcode"] integerValue] == 0 )
        {
            if ( self.notGoNext )
            {
                // do nothing
            }
            else if ( self.isCancel )
            {
                self.wash.state = @"draft";
            }
            else
            {
                if ( [self.wash.state isEqualToString:@"waiting"] )
                {
                    self.wash.state = @"doing";
                }
                else if ( [self.wash.state isEqualToString:@"doing"] || [self.wash.state isEqualToString:@"done"] )
                {
                    self.wash.state = @"temp";
                }
            }
            
            for (CDYimeiImage *yimeiImage in self.uploadArray)
            {
                yimeiImage.washhand = nil;
            }
            
            self.wash.yimei_before = [NSMutableOrderedSet orderedSet];
            
            [[BSCoreDataManager currentManager] save:nil];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kEditWashHandResponse object:nil userInfo:dict];
}

@end
