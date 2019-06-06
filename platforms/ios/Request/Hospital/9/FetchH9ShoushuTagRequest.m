//
//  FetchH9ShoushuTagRequest.m
//  meim
//
//  Created by jimmy on 2017/8/17.
//
//

#import "FetchH9ShoushuTagRequest.h"
#import "ChineseToPinyin.h"

@implementation FetchH9ShoushuTagRequest

- (BOOL)willStart
{
    PersonalProfile *profile = [PersonalProfile currentProfile];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = profile.userID;
    params[@"timestamp"] = [PersonalProfile currentProfile].shoushuTagModifyDate;
    
    [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"get_operate_tags" params:@[params]];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSDictionary *resultList = [BNXmlRpc dictionaryWithXmlRpc:resultStr];
    
    if (resultStr.length != 0 && resultList != nil && [resultList isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *resuntDitc = (NSDictionary *)resultList;
        NSDictionary *data = [resuntDitc objectForKey:@"data"];

        [PersonalProfile currentProfile].shoushuTagModifyDate = [data stringValueForKey:@"last_updated_time"];
        NSArray* insertArray = [data arrayValueForKey:@"insert_and_update"];
        
        for ( NSArray *params in insertArray)
        {
            NSNumber *tagID = params[0];
            CDH9ShoushuTag *tag = [[BSCoreDataManager currentManager] findEntity:@"CDH9ShoushuTag" withValue:tagID forKey:@"tag_id"];
            if( tag == nil )
            {
                tag = [[BSCoreDataManager currentManager] insertEntity:@"CDH9ShoushuTag"];
                tag.tag_id = tagID;
            }
            tag.name = params[1];
            tag.memberNameLetter = [ChineseToPinyin pinyinFromChiniseString:tag.name];
            tag.memberNameFirstLetter = [[ChineseToPinyin pinyinFirstLetterString:tag.name] uppercaseString];
        }
        
        NSArray* deleteArray = [data arrayValueForKey:@"unlink"];
        [[BSCoreDataManager currentManager] DeleteH9Shoushutag:deleteArray];
    }
}

@end
