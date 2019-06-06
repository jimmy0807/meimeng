//
//  FetchHJiaoHaoRequest.m
//  meim
//
//  Created by jimmy on 2017/4/27.
//
//

#import "FetchHJiaoHaoRequest.h"
#import "ChineseToPinyin.h"

@implementation FetchHJiaoHaoRequest

- (BOOL)willStart
{
    PersonalProfile *profile = [PersonalProfile currentProfile];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = profile.userID;
    if ( self.isDone )
    {
        params[@"state"] = @"done";
    }
    
    if ( self.isPrint )
    {
        params[@"is_print"] = @(TRUE);
    }
    
    if ( self.isMySelf )
    {
        params[@"is_myself"] = @(TRUE);
    }
    
    if ( self.isCancel )
    {
        params[@"state"] = @"cancel";
    }
    
    if ( self.isModify )
    {
        params[@"is_update_add_operate"] = @(TRUE);
    }
    
    if ( self.keyword.length > 0 )
    {
        params[@"keyword"] = self.keyword;
    }
    
    [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"order_info" params:@[params]];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSDictionary *resultList = [BNXmlRpc dictionaryWithXmlRpc:resultStr];
    NSMutableArray *searchList = nil;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (resultStr.length != 0 && resultList != nil && [resultList isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *resuntDitc = (NSDictionary *)resultList;
        NSDictionary *data = [resuntDitc objectForKey:@"data"];
     
        NSInteger index = 0;
        if ([data isKindOfClass:[NSArray class]])
        {
            if ( self.keyword.length == 0 )
            {
                if ( self.isDone )
                {
                    [[BSCoreDataManager currentManager] deleteObjects:[[BSCoreDataManager currentManager] fetchAllJiaoHao:nil isDepart:self.isMySelf isFinish:TRUE isPrint:self.isPrint]];
                }
                else
                {
                    [[BSCoreDataManager currentManager] deleteObjects:[[BSCoreDataManager currentManager] fetchAllJiaoHao:nil isDepart:self.isMySelf isFinish:FALSE isPrint:self.isPrint]];
                }
            }
            else
            {
                searchList = [NSMutableArray array];
            }
            
            for (NSDictionary *params in data)
            {
                NSNumber *jiaohaoID = [params objectForKey:@"id"];
                CDHJiaoHao *jiaohao = [[BSCoreDataManager currentManager] findEntity:@"CDHJiaoHao" withValue:jiaohaoID forKey:@"jiaohao_id"];
                if( jiaohao == nil )
                {
                    jiaohao = [[BSCoreDataManager currentManager] insertEntity:@"CDHJiaoHao"];
                    jiaohao.jiaohao_id = jiaohaoID;
                }
                
                jiaohao.state = [params stringValueForKey:@"activity"];
                jiaohao.customer_name = [params stringValueForKey:@"customer_name"];
                jiaohao.customer_id = [params numberValueForKey:@"member_id"];
                jiaohao.memberNameLetter = [ChineseToPinyin pinyinFromChiniseString:jiaohao.customer_name];
                jiaohao.memberNameFirstLetter = [[ChineseToPinyin pinyinFirstLetterString:jiaohao.customer_name] uppercaseString];
                jiaohao.keshi_name = [params stringValueForKey:@"department"];
                jiaohao.doctor_name = [params stringValueForKey:@"doctor_name"];
                jiaohao.doctor_id = [params numberValueForKey:@"doctor_id"];
                jiaohao.peitai_nurse_name = [params stringValueForKey:@"peitai_nurse_name"];
                jiaohao.peitai_nurse_id = [params numberValueForKey:@"peitai_nurse_id"];
                jiaohao.xunhui_nurse_name = [params stringValueForKey:@"xunhui_nurse_name"];
                jiaohao.xunhui_nurse_id = [params numberValueForKey:@"xunhui_nurse_id"];
                jiaohao.anesthetist_name = [params stringValueForKey:@"anesthetist_name"];
                jiaohao.anesthetist_id = [params numberValueForKey:@"anesthetist_id"];
                jiaohao.queue = [params stringValueForKey:@"sort"];
                jiaohao.advisory_product_names = [params stringValueForKey:@"product_names"];
                jiaohao.queue_no = [params stringValueForKey:@"queue_no"];
                jiaohao.progre_status = [params stringValueForKey:@"progre_status"];
                jiaohao.departments_id = [params numberValueForKey:@"departments_id"];
                jiaohao.keshi_id = [params numberValueForKey:@"departments_id"];
                jiaohao.jump_name = [params stringValueForKey:@"jump_name"];
                jiaohao.is_update = [params numberValueForKey:@"is_update"];
                jiaohao.current_workflow_activity_id = [params numberValueForKey:@"current_workflow_activity_id"];
                jiaohao.is_print = @(self.isPrint);
                jiaohao.member_type = [params stringValueForKey:@"member_type"];
                jiaohao.create_uid = [params numberValueForKey:@"create_uid"];
                jiaohao.sort_index = @(index++);
                
                [searchList addObject:jiaohao];
            }
            
            [[BSCoreDataManager currentManager] save:nil];
        }
        else
        {
            dict = [self generateResponse:@"请求数据错误"];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFetchHJiaoHaoResponse object:searchList userInfo:dict];
}

@end
