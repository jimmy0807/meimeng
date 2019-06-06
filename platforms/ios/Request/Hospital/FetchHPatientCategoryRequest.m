//
//  FetchHPatientCategoryRequest.m
//  meim
//
//  Created by jimmy on 2017/7/21.
//
//

#import "FetchHPatientCategoryRequest.h"

@implementation FetchHPatientCategoryRequest

- (BOOL)willStart
{
    PersonalProfile *profile = [PersonalProfile currentProfile];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:profile.userID forKey:@"user_id"];
   
    [self sendRpcXmlCommand:@"/xmlrpc/2/ds_api" method:@"get_diagnosis_category" params:@[params]];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSDictionary *resultList = [BNXmlRpc dictionaryWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (resultStr.length != 0 && resultList != nil && [resultList isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *resuntDitc = (NSDictionary *)resultList;
        NSDictionary *data = [resuntDitc objectForKey:@"data"];
        
        NSInteger index = 0;
        
        if ([data isKindOfClass:[NSArray class]])
        {
            NSArray* array = [[BSCoreDataManager currentManager] fetchAllHuizhenCategory];
            [[BSCoreDataManager currentManager] deleteObjects:array];
            
            for (NSDictionary *params in data)
            {
                NSNumber *categoryID = [params objectForKey:@"id"];
                
                CDHHuizhenCategory *category = [[BSCoreDataManager currentManager] insertEntity:@"CDHHuizhenCategory"];
                category.cateogry_id = categoryID;
                category.parent_id = [params numberValueForKey:@"parent_id"];
                category.image_url = [params stringValueForKey:@"image_url"];
                category.name = [params stringValueForKey:@"name"];
                category.sort_index = @(index++);
                
                if ( [category.parent_id integerValue] > 0 )
                {
                    CDHHuizhenCategory *parent_category = [[BSCoreDataManager currentManager] findEntity:@"CDHHuizhenCategory" withValue:category.parent_id forKey:@"cateogry_id"];
                    category.parent = parent_category;
                }
            }
            
            [[BSCoreDataManager currentManager] save:nil];
        }
        else
        {
            dict = [self generateResponse:@"请求数据错误"];
        }
    }
}

@end
