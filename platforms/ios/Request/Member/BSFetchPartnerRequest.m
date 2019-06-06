//
//  BSFetchPartnerRequest.m
//  ds
//
//  Created by jimmy on 16/10/18.
//
//

#import "BSFetchPartnerRequest.h"
#import "ChineseToPinyin.h"

@implementation BSFetchPartnerRequest

- (BOOL)willStart
{
    self.tableName = @"born.partner";
    self.field = @[@"display_name",@"id",@"partner_category",@"write_date",@"street",@"designer_employee_id",@"business_employee_id",@"sign_date",@"mobile",@"identification"];
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if ([resultArray isKindOfClass:[NSArray class]])
    {
        BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
        [dataManager deleteObjects:[dataManager fetchPartner]];
        
        for (NSDictionary *params in resultArray)
        {
            NSNumber* partnerID = [params numberValueForKey:@"id"];
            CDPartner *partner = [dataManager insertEntity:@"CDPartner"];
            partner.partner_id = partnerID;
            partner.name = [params stringValueForKey:@"display_name"];
            partner.partner_category = [params stringValueForKey:@"partner_category"];
            partner.lastUpdate = [params stringValueForKey:@"write_date"];
            
            partner.nameLetter = [ChineseToPinyin pinyinFromChiniseString:partner.name];
            partner.nameFirstLetter = [[ChineseToPinyin pinyinFirstLetterString:partner.name] uppercaseString];
            
            partner.designer_employee_id = [params arrayIDValueForKey:@"designer_employee_id"];
            partner.designer_employee_name = [params arrayNameValueForKey:@"designer_employee_id"];
            
            partner.business_employee_id = [params arrayIDValueForKey:@"business_employee_id"];
            partner.business_employee_name = [params arrayNameValueForKey:@"business_employee_id"];
            
            partner.street = [params stringValueForKey:@"street"];
            if ( [partner.street isEqualToString:@"0"] )
            {
                partner.street = @"";
            }
            
            partner.sign_date = [params stringValueForKey:@"sign_date"];
            partner.mobile = [params stringValueForKey:@"mobile"];
            partner.identification = [params stringValueForKey:@"identification"];
        }
        
        [dataManager save:nil];
    }
    else
    {
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchPartnerResponse object:nil userInfo:dict];
}

@end
