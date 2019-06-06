//
//  FetchHMemberVisitRequest.m
//  meim
//
//  Created by jimmy on 2017/4/28.
//
//

#import "FetchHMemberVisitRequest.h"
#import "ChineseToPinyin.h"
#import "FetchYimeiPhotoImageRequest.h"

#define FETCH_COUNT  30

@interface FetchHMemberVisitRequest ()
@property(nonatomic, strong)NSString* category;
@end


@implementation FetchHMemberVisitRequest

- (BOOL)willStart
{
    self.tableName = @"born.member.visit";
    NSMutableArray *filters = [NSMutableArray array];
    if (self.type == HMemberVisitQianzai)
    {
        self.category = @"potential";
        [filters addObject:@[@"category", @"=", @"potential"]];
    }
    else if (self.type == HMemberVisitShuhou)
    {
        self.category = @"operate";
        [filters addObject:@[@"category", @"=", @"operate"]];
    }
    else if (self.type == HMemberVisitLaoke)
    {
        self.category = @"old";
        [filters addObject:@[@"category", @"=", @"old"]];
    }
    else if (self.type == HMemberVisitRichang)
    {
        self.category = @"day";
        [filters addObject:@[@"category", @"=", @"day"]];
    }
    else if (self.type == HMemberVisitTousu)
    {
        self.category = @"festival";
        [filters addObject:@[@"category", @"=", @"festival"]];
    }
    
    if ( self.keyword )
    {
        [filters addObject:@[@"name", @"like", self.keyword]];
    }
    
    self.filter = filters;
    self.field = @[@"advisory_id", @"category", @"create_date", @"customer_id", @"name", @"is_success", @"member_id", @"operate_id", @"plant_visit_date", @"plant_visit_user_id",@"state", @"visit_date",@"visit_user_id",@"write_date",@"levle_id",@"product_names",@"visit_image_ids"];
    
    NSArray *params = [NSArray array];
    if ( self.keyword.length == 0 )
    {
        params = @[[NSNumber numberWithInteger:self.startIndex], [NSNumber numberWithInteger:FETCH_COUNT], @"id desc"];
    }
    
    [self sendShopAssistantXmlSearchReadCommand:params];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableArray *searchList = nil;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([resultList isKindOfClass:[NSArray class]])
    {
        if ( self.keyword == nil && self.startIndex == 0 )
        {
            NSArray* visitArray = [[BSCoreDataManager currentManager] fetchMemberVisit:self.category keyword:self.keyword];
            [[BSCoreDataManager currentManager] deleteObjects:visitArray];
        }
        else
        {
            searchList = [NSMutableArray array];
        }
        
        NSInteger index = 0;
        for (NSDictionary *params in resultList)
        {
            NSNumber* visitID = [params numberValueForKey:@"id"];
            CDMemberVisit* visit = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDMemberVisit" withValue:visitID forKey:@"visit_id"];
            visit.advisory_id = [params arrayIDValueForKey:@"advisory_id"];
            visit.advisory_name = [params arrayNameValueForKey:@"advisory_id"];
            visit.category = [params stringValueForKey:@"category"];
            visit.create_date = [params stringValueForKey:@"create_date"];
            visit.customer_id = [params arrayIDValueForKey:@"customer_id"];
            visit.customer_name = [params arrayNameValueForKey:@"customer_id"];
            visit.lastUpdate = [params stringValueForKey:@"write_date"];
            visit.name = [params stringValueForKey:@"name"];
            visit.operate_id = [params arrayIDValueForKey:@"operate_id"];
            visit.operate_name = [params arrayNameValueForKey:@"operate_id"];
            visit.plant_visit_date = [params stringValueForKey:@"plant_visit_date"];
            
            visit.plant_visit_user_id = [params arrayIDValueForKey:@"plant_visit_user_id"];
            visit.plant_visit_user_name = [params arrayNameValueForKey:@"plant_visit_user_id"];
            visit.day = [params arrayNameValueForKey:@"levle_id"];
            visit.member_id = [params arrayIDValueForKey:@"member_id"];
            visit.member_name = [params arrayNameValueForKey:@"member_id"];
            visit.state = [params stringValueForKey:@"state"];
            
            visit.nameLetter = [ChineseToPinyin pinyinFromChiniseString:visit.member_name];
            visit.nameFirstLetter = [[ChineseToPinyin pinyinFirstLetterString:visit.member_name] uppercaseString];
            visit.product_names = [params stringValueForKey:@"product_names"];
            visit.visit_date = [params stringValueForKey:@"visit_date"];
            visit.visit_user_name = [params arrayNameValueForKey:@"visit_user_id"];
            visit.visit_user_id = [params arrayIDValueForKey:@"visit_user_id"];
            
            NSArray* image_ids = [params arrayValueForKey:@"visit_image_ids"];
            visit.photos = [NSMutableOrderedSet orderedSet];
            for ( NSNumber* photoID in image_ids )
            {
                CDYimeiImage* yimeiImage = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDYimeiImage" withValue:photoID forKey:@"imageID"];
                yimeiImage.huifang = visit;
            }
            
            if ( image_ids.count > 0 )
            {
                FetchYimeiPhotoImageRequest* request = [[FetchYimeiPhotoImageRequest alloc] init];
                request.ids = image_ids;
                request.tableName = @"born.visit.image";
                [request execute];
            }
            
            visit.sortIndex = @(index++);
            [searchList addObject:visit];
        }

        [[BSCoreDataManager currentManager] save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求数据错误"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFetchHMemberResponse object:searchList userInfo:dict];
}

@end
