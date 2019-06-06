//
//  FetchHHuizhenRequest.m
//  meim
//
//  Created by jimmy on 2017/5/2.
//
//

#import "FetchHHuizhenRequest.h"
#import "FetchYimeiPhotoImageRequest.h"

@interface FetchHHuizhenRequest ()
@property (nonatomic, strong)NSArray *huizhenIDs;
@end

@implementation FetchHHuizhenRequest

-(id)initWithBinglikaID:(NSArray*)huizhenIDs
{
    self = [super init];
    if (self)
    {
        self.huizhenIDs = huizhenIDs;
    }
    
    return self;
}

- (BOOL)willStart
{
    if ( self.huizhenIDs.count == 0 )
        return FALSE;
    
    self.tableName = @"born.medical.records.line";
    NSMutableArray *filters = [NSMutableArray array];
    
    [filters addObject:@[@"id", @"in", self.huizhenIDs]];
    
    self.filter = filters;
    self.field = @[@"create_date", @"display_name", @"doctors_id", @"doctors_note", @"reason", @"write_date",@"doctors_image_url",@"first_diagnosis_category_id",@"second_diagnosis_category_id",@"image_ids",@"second_diagnosis_category_str",@"description_str",@"source"];
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableArray *searchList = nil;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([resultList isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *params in resultList)
        {
            NSNumber* huizhenID = [params numberValueForKey:@"id"];
            CDHHuizhen* huizhen = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDHHuizhen" withValue:huizhenID forKey:@"huizhen_id"];
            huizhen.create_date = [params stringValueForKey:@"create_date"];
            huizhen.name = [params stringValueForKey:@"display_name"];
            huizhen.doctors_id = [params arrayIDValueForKey:@"doctors_id"];
            huizhen.doctors_name = [params arrayNameValueForKey:@"doctors_id"];
            huizhen.doctors_note = [params stringValueForKey:@"doctors_note"];
            huizhen.reason = [params stringValueForKey:@"reason"];
            huizhen.lastUpdate = [params stringValueForKey:@"write_date"];
            huizhen.doctor_url = [params stringValueForKey:@"doctors_image_url"];
            huizhen.source = [params stringValueForKey:@"source"];
            
            if ( [huizhen.reason isEqualToString:@"0"] )
            {
                huizhen.reason = @"";
            }
            
            if ( [huizhen.doctors_note isEqualToString:@"0"] )
            {
                huizhen.doctors_note = @"";
            }
            
            huizhen.first_category_id = [params arrayIDValueForKey:@"first_diagnosis_category_id"];
            huizhen.first_category_name = [params arrayNameValueForKey:@"first_diagnosis_category_id"];
            huizhen.second_category_ids = [[params arrayValueForKey:@"second_diagnosis_category_id"] componentsJoinedByString:@","];
            huizhen.description_str = [params stringValueForKey:@"description_str"];
#if 0
            NSMutableArray* array = [NSMutableArray array];
            for ( NSNumber* n in [params arrayValueForKey:@"second_diagnosis_category_id"] )
            {
                CDHHuizhenCategory* c = [[BSCoreDataManager currentManager] findEntity:@"CDHHuizhenCategory" withValue:n forKey:@"cateogry_id"];
                [array addObject:c.name];
            }
            huizhen.second_category_name = [array componentsJoinedByString:@","];
#else
            huizhen.second_category_name = [params stringValueForKey:@"second_diagnosis_category_str"];
            
#endif
            NSArray* image_ids = [params arrayValueForKey:@"image_ids"];
            [[BSCoreDataManager currentManager] deleteObjects:huizhen.photos.array];
            for ( NSNumber* image_id in image_ids )
            {
                CDYimeiImage* a = [[BSCoreDataManager currentManager] insertEntity:@"CDYimeiImage"];
                a.imageID = image_id;
                a.huizhen = huizhen;
            }
            
            if ( image_ids.count > 0 )
            {
                FetchYimeiPhotoImageRequest* request = [[FetchYimeiPhotoImageRequest alloc] init];
                request.ids = image_ids;
                request.requestTableName = @"born.medical.records.image";
                [request execute];
            }
        }
        
        [[BSCoreDataManager currentManager] save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求数据错误"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kHHuizhenLinesResponse object:searchList userInfo:dict];
}

@end
