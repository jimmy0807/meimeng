//
//  FetchHPatientRequest.m
//  meim
//
//  Created by jimmy on 2017/4/28.
//
//

#import "FetchHPatientRequest.h"
#import "ChineseToPinyin.h"

@implementation FetchHPatientRequest

- (BOOL)willStart
{
    PersonalProfile *profile = [PersonalProfile currentProfile];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:profile.userID forKey:@"user_id"];
    if ( self.keyword.length > 0 )
    {
        [params setObject:self.keyword forKey:@"keyword"];
    }
    
    if ( self.isMyPatient )
    {
        [params setObject:@(TRUE) forKey:@"filtered_other"];
    }
    
    if ( self.categoryString.length > 0 )
    {
        if ( [self.type isEqualToString:@"today"] )
        {
            [params setObject:self.categoryString forKey:@"today_keyword"];
        }
        else if ( [self.type isEqualToString:@"wait"] )
        {
            [params setObject:self.categoryString forKey:@"wait_keyword"];
        }
    }

    if ( [self.type isEqualToString:@"all"] )
    {
        [params setObject:@(self.offset) forKey:@"offset"];
        [params setObject:@(3) forKey:@"type"];
    }
    
    if ( [profile.medical_api_version isEqualToString:@"nine"] )
    {
        [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"medical_member_info_nine" params:@[params]];
    }
    else
    {
        [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"medical_member_info" params:@[params]];
    }
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSDictionary *resultList = [BNXmlRpc dictionaryWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray* searchArray = [NSMutableArray array];
    if (resultStr.length != 0 && resultList != nil && [resultList isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *resuntDitc = (NSDictionary *)resultList;
        NSDictionary *data = [resuntDitc objectForKey:@"data"];
    
    if ([data isKindOfClass:[NSArray class]])
    {
        NSArray* array = [[BSCoreDataManager currentManager] fetchAllPatientWithKeyword:nil type: self.listType isMyPatient:FALSE];
        NSMutableArray* oldMember = nil;
        if ( array.count > 0 && ( self.keyword.length == 0 && self.categoryString.length == 0 && self.offset == 0 ) )
        {
            oldMember = [NSMutableArray arrayWithArray:array];
        }
        
        NSInteger index = 0;
        
        for (NSDictionary *params in data)
        {
            NSNumber *memberID = [params objectForKey:@"id"];
            
            CDMember *member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:memberID forKey:@"memberID"];
            if( member == nil )
            {
                member = [[BSCoreDataManager currentManager] insertEntity:@"CDMember"];
                member.memberID = memberID;
            }
            else
            {
                [oldMember removeObject:member];
            }
            
            member.first_treat_date = [params stringValueForKey:@"first_treat_date"];
            member.doctor_id = [params numberValueForKey:@"doctor_id"];
            member.doctor_name = [params stringValueForKey:@"doctor_name"];
            member.image_url = [params stringValueForKey:@"image_url"];
            member.mobile = [params stringValueForKey:@"mobile"];
            member.memberName = [params stringValueForKey:@"name"];
            member.memberNameLetter = [ChineseToPinyin pinyinFromChiniseString:member.memberName];
            member.memberNameFirstLetter = [[ChineseToPinyin pinyinFirstLetterString:member.memberName] uppercaseString];
            member.status = [params stringValueForKey:@"status"];
            member.sortIndex = @(index++);
            member.showPatient = @(TRUE);
            member.record_note = [params stringValueForKey:@"record_note"];
            member.record_time = [params stringValueForKey:@"record_time"];
            member.record_id = [params numberValueForKey:@"record_id"];
            member.birthday = [params stringValueForKey:@"birth_date"];
            member.gender = [params stringValueForKey:@"gender"];
            member.astro = [params stringValueForKey:@"astro"];
            member.blood_type = [params stringValueForKey:@"blood_type"];
            
            NSInteger type = [[params numberValueForKey:@"type"] integerValue];
            if ( type == 1 )
            {
                member.h_patient_type = @(HPatientListType_Wait);
            }
            else if ( type == 2 )
            {
                member.h_patient_type = @(HPatientListType_Today);
            }
            else if ( type == 3 )
            {
                member.h_patient_type = @(HPatientListType_Recent);
            }
            
            [searchArray addObject:member];
        }
        
        [[BSCoreDataManager currentManager] deleteObjects:oldMember];
        [[BSCoreDataManager currentManager] save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求数据错误"];
    }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kHPatientResponse object:( self.keyword.length > 0 || self.categoryString.length > 0 ) ? searchArray : nil userInfo:dict];
}


@end
