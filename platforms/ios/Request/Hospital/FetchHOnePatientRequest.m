//
//  FetchHOnePatientRequest.m
//  meim
//
//  Created by jimmy on 2017/8/10.
//
//

#import "FetchHOnePatientRequest.h"
#import "ChineseToPinyin.h"

@implementation FetchHOnePatientRequest

- (BOOL)willStart
{
    PersonalProfile *profile = [PersonalProfile currentProfile];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:profile.userID forKey:@"user_id"];
    if ( [self.memberID integerValue] > 0 )
    {
        [params setObject:self.memberID forKey:@"member_id"];
    }
    
    [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"medical_member_info_by_id" params:@[params]];
    
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

        NSNumber *memberID = [params objectForKey:@"id"];
        
        CDMember *member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:memberID forKey:@"memberID"];
        if( member == nil )
        {
            member = [[BSCoreDataManager currentManager] insertEntity:@"CDMember"];
            member.memberID = memberID;
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
        
        [[BSCoreDataManager currentManager] save:nil];
    }
    
    self.finished(dict);
}

@end
