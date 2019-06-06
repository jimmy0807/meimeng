//
//  FetchWorkHandDetailRequest.m
//  meim
//
//  Created by jimmy on 2017/6/26.
//
//

#import "FetchWorkHandDetailRequest.h"
#import "FetchYimeiPhotoImageRequest.h"

@implementation FetchWorkHandDetailRequest

- (BOOL)willStart
{
    PersonalProfile *profile = [PersonalProfile currentProfile];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    params[@"user_id"] = profile.userID;
    params[@"operate_id"] = self.washHand.operate_id;
    NSLog(@"%@",profile.yimeiWorkFlowArray);
    if ( profile.yimeiWorkFlowArray.count > 0 )
    {
        [params setObject:profile.yimeiWorkFlowArray[0] forKey:@"workflow_item_id"];
    }
    
    [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"pos_operate_detail" params:@[params]];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSDictionary *resultList = [BNXmlRpc dictionaryWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [self generateDsApiResponse:resultList];
    
    if (resultStr.length != 0 && resultList != nil && [resultList isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *resuntDitc = (NSDictionary *)resultList;
        NSDictionary *params = [resuntDitc objectForKey:@"data"];

        if ([params isKindOfClass:[NSDictionary class]] && [resuntDitc[@"errcode"] integerValue] == 0 )
        {
            NSNumber *line_id = [params objectForKey:@"id"];
            CDPosWashHand *wash = [[BSCoreDataManager currentManager] findEntity:@"CDPosWashHand" withValue:line_id forKey:@"operate_id"];
            if( wash == nil )
            {
                wash = [[BSCoreDataManager currentManager] insertEntity:@"CDPosWashHand"];
                wash.operate_id = line_id;
            }
            
            wash.current_activity_id = [params numberValueForKey:@"current_activity_id"];
            wash.current_work_index = [params numberValueForKey:@"current_activity_index"];
            wash.state = [params stringValueForKey:@"current_activity_state"];
            wash.keshi_id = [params numberValueForKey:@"departments_id"];
            wash.keshi_name = [params stringValueForKey:@"departments_name"];
            wash.yimei_shejishiName = [params stringValueForKey:@"designers_name"];
            wash.yimei_shejizongjianName = [params stringValueForKey:@"director_employee_name"];
            wash.doctor_id = [params numberValueForKey:@"doctor_id"];
            wash.doctor_name = [params stringValueForKey:@"doctor_name"];
            wash.member_id = [params numberValueForKey:@"member_id"];
            wash.name = [params stringValueForKey:@"name"];
            wash.binglika_id = [params numberValueForKey:@"records_id"];
            wash.remark = [params stringValueForKey:@"remark"];
            wash.role_option = [params numberValueForKey:@"role_option"];
            wash.yimei_queueID = [params stringValueForKey:@"queue_no"];
            wash.member_name_detail = [params stringValueForKey:@"detail_customer_name"];
            wash.operate_date_detail = [params stringValueForKey:@"detail_create_date"];
            wash.operate_activity_id = [params numberValueForKey:@"operate_activity_id"];
            wash.flow_end = [params numberValueForKey:@"flow_end"];
            wash.sign_member_name = [params stringValueForKey:@"member_name"];
            wash.yimei_sign_after = [params stringValueForKey:@"after_sign_image_url"];
            wash.print_url = [params stringValueForKey:@"print_url"];
            wash.peitai_nurse_id = [params numberValueForKey:@"peitai_nurse_id"];
            wash.peitai_nurse_name = [params stringValueForKey:@"peitai_nurse_name"];
            wash.xunhui_nurse_id = [params numberValueForKey:@"xunhui_nurse_id"];
            wash.xunhui_nurse_name = [params stringValueForKey:@"xunhui_nurse_name"];
            wash.anesthetist_id = [params numberValueForKey:@"anesthetist_id"];
            wash.anesthetist_name = [params stringValueForKey:@"anesthetist_name"];
            NSMutableArray *preArray = [[NSMutableArray alloc] init];
            for (NSDictionary *prescription in [params arrayValueForKey:@"prescriptions"])
            {
                [preArray addObject:[NSString stringWithFormat:@"%@@%@%@", [prescription objectForKey:@"product_name"], [prescription objectForKey:@"qty"], [prescription objectForKey:@"uom_name"]]];
            }
            wash.prescriptions = [preArray componentsJoinedByString:@","];
            
            NSMutableArray *consumArray = [[NSMutableArray alloc] init];
            for (NSDictionary *consumable in [params arrayValueForKey:@"consumable_ids"])
            {
                [consumArray addObject:[NSString stringWithFormat:@"%@@%@@%@@%@@%@", [consumable objectForKey:@"name"], [consumable objectForKey:@"qty"], [consumable objectForKey:@"consume_true_qty"], [consumable objectForKey:@"product_id"], [consumable objectForKey:@"id"]]];
            }
            wash.consumable_ids = [consumArray componentsJoinedByString:@","];
            
            for (CDYimeiImage* image in wash.yimei_before )
            {
                if ( [image.type isEqualToString:@"server"] )
                {
                    image.washhand = nil;
                }
            }
            
            if ( wash.yimei_before.count == 0 )
            {
                wash.yimei_before = [NSMutableOrderedSet orderedSet];
            }
            //[[BSCoreDataManager currentManager] deleteObjects:wash.yimei_before.array];
            
            NSArray* smallArray = [params arrayValueForKey:@"thumb_local_name"];
            NSArray* nameArray = [params arrayValueForKey:@"image_local_name"];
            NSArray* imageIDS = [params arrayValueForKey:@"image_ids"];
            
            if ( imageIDS.count > 0 )
            {
                NSInteger index = 0;
                for ( NSArray* url in imageIDS )
                {
                    CDYimeiImage* a = [[BSCoreDataManager currentManager] insertEntity:@"CDYimeiImage"];
                    if ( [url isKindOfClass:[NSArray class]] )
                    {
                        a.url = url[0];
                        a.take_time = url[1];
                        a.small_url = [NSString stringWithFormat:@"%@?w=200",url[0]];
                    }
                    else
                    {
                        a.url = (NSString*)url;
                        a.small_url = [NSString stringWithFormat:@"%@?w=200",(NSString*)url];
                    }
                    
                    if ( index < smallArray.count )
                    {
                        NSArray* t = smallArray[index];
                        if ( [ t isKindOfClass:[NSArray class]] )
                        {
                            a.small_url = t[0];
                        }
                        else
                        {
                            a.small_url = (NSString*)t;
                        }
                    }
                    
                    if ( index < nameArray.count )
                    {
                        NSArray* t = nameArray[index];
                        if ( [ t isKindOfClass:[NSArray class]] )
                        {
                            a.bigImageUrl = t[0];
                        }
                        else
                        {
                            a.bigImageUrl = (NSString*)t;
                        }
                    }
                    
                    
                    a.type = @"server";
                    a.status = @"success";
                    a.washhand = wash;
                    
                    index++;
                }
            }
            else if ( smallArray.count > 0 )
            {
                NSInteger index = 0;
                for ( NSArray* url in smallArray )
                {
                    CDYimeiImage* a = [[BSCoreDataManager currentManager] insertEntity:@"CDYimeiImage"];
                    if ( [url isKindOfClass:[NSArray class]] )
                    {
                        a.small_url = url[0];
                        if ( url.count > 1 )
                        {
                            a.take_time = url[1];
                        }
                        
                        if ( index < nameArray.count )
                        {
                            NSArray* t = nameArray[index];
                            if ( [ t isKindOfClass:[NSArray class]] )
                            {
                                a.bigImageUrl = t[0];
                            }
                            else
                            {
                                a.bigImageUrl = (NSString*)t;
                            }
                        }
                    }
                    else
                    {
                        a.small_url = (NSString*)url;
                        if ( index < nameArray.count )
                        {
                            NSArray* t = nameArray[index];
                            if ( [ t isKindOfClass:[NSArray class]] )
                            {
                                a.bigImageUrl = t[0];
                            }
                            else
                            {
                                a.bigImageUrl = (NSString*)t;
                            }
                        }
                    }
                    a.type = @"server";
                    a.status = @"success";
                    a.washhand = wash;
                    index++;
                }
            }
            
            NSMutableArray* array = [NSMutableArray array];
            for ( NSArray* ids in [params arrayValueForKey:@"operate_employee_ids"] )
            {
                if ( [ids isKindOfClass:[NSArray class]] )
                {
                    [array addObject:ids[0]];
                }
                else
                {
                    [array addObject:ids];
                }
            }
            
            wash.yimei_operate_employee_ids = [array componentsJoinedByString:@","];
            wash.work_names = [params onlyStringValueForKey:@"workflow_ids"];
            
            wash.medical_note = [params stringValueForKey:@"medical_note"];
            wash.diagnose = [params stringValueForKey:@"diagnose"];
            wash.treatment = [params stringValueForKey:@"treatment"];
            NSArray* medicalItems = [params arrayValueForKey:@"prescriptions"];
            [[BSCoreDataManager currentManager] deleteObjects:wash.chufang_items.array];
            [[BSCoreDataManager currentManager] deleteObjects:wash.feichufang_items.array];
            for ( NSDictionary* params in medicalItems )
            {
                CDMedicalItem* item = [[BSCoreDataManager currentManager] insertEntity:@"CDMedicalItem"];
                item.is_prescription = [params numberValueForKey:@"is_prescription"];
                item.name = [params stringValueForKey:@"product_name"];
                item.uomName = [params stringValueForKey:@"uom_name"];
                item.uomID = [params numberValueForKey:@"uom_id"];
                item.count = [params numberValueForKey:@"qty"];
                item.itemID = [params numberValueForKey:@"product_id"];
                
                if ( [item.is_prescription boolValue] )
                {
                    item.chufang = wash;
                }
                else
                {
                    item.feichufang = wash;
                }
            }
            
            [[BSCoreDataManager currentManager] save:nil];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFetchWashHandDetailResponse object:nil userInfo:dict];
}

@end
