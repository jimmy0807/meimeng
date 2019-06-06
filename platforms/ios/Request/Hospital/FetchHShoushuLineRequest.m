//
//  FetchHShoushuLineRequest.m
//  meim
//
//  Created by jimmy on 2017/5/10.
//
//

#import "FetchHShoushuLineRequest.h"

@interface FetchHShoushuLineRequest ()
@property (nonatomic, strong)NSArray *shoushuIDs;
@end

@implementation FetchHShoushuLineRequest

-(id)initWithShoushuID:(NSArray*)shoushuIDs
{
    self = [super init];
    if (self)
    {
        self.shoushuIDs = shoushuIDs;
    }
    
    return self;
}

- (BOOL)willStart
{
    if ( self.shoushuIDs.count == 0 )
        return FALSE;
    
    self.tableName = @"born.medical.operate.line";
    NSMutableArray *filters = [NSMutableArray array];
    
    [filters addObject:@[@"id", @"in", self.shoushuIDs]];
    
    self.filter = filters;
    self.field = @[@"create_date", @"display_name", @"doctor_id", @"hospitalized_id", @"medical_operate_id", @"note",@"operate_date",@"review_date",@"review_days",@"write_date",@"write_uid",@"product_id",@"state",@"operate_tags_ids",@"review_date_ids_str"];
    
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
            NSNumber* shoushuID = [params numberValueForKey:@"id"];
            CDHShoushuLine* shoushu = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDHShoushuLine" withValue:shoushuID forKey:@"line_id"];
            shoushu.create_date = [params stringValueForKey:@"create_date"];
            shoushu.name = [params stringValueForKey:@"display_name"];
            shoushu.doctor_id = [params arrayIDValueForKey:@"doctor_id"];
            shoushu.doctor_name = [params arrayNameValueForKey:@"doctor_id"];
            shoushu.hospitalized_id = [params arrayIDValueForKey:@"hospitalized_id"];
            shoushu.hospitalized_name = [params arrayNameValueForKey:@"hospitalized_id"];
            shoushu.medical_operate_id = [params arrayIDValueForKey:@"medical_operate_id"];
            shoushu.medical_operate_name = [params arrayNameValueForKey:@"medical_operate_id"];
            shoushu.operate_date = [params stringValueForKey:@"operate_date"];
            //shoushu.review_date = [params stringValueForKey:@"review_date"];
            shoushu.review_date = [params stringValueForKey:@"review_date_ids_str"];
            shoushu.review_days = [params numberValueForKey:@"review_days"];
            shoushu.lastUpdate = [params stringValueForKey:@"write_date"];
            shoushu.write_uid = [params arrayIDValueForKey:@"write_uid"];
            shoushu.write_name = [params arrayNameValueForKey:@"write_uid"];
            shoushu.note = [params stringValueForKey:@"note"];
            shoushu.product_id = [params arrayIDValueForKey:@"product_id"];
            shoushu.product_name = [params arrayNameValueForKey:@"product_id"];
            shoushu.state = [params stringValueForKey:@"state"];
            
            if ( [shoushu.note isEqualToString:@"0"] )
            {
                shoushu.note = @"";
            }
            
            if ( [shoushu.review_date isEqualToString:@"0"] )
            {
                shoushu.review_date = @"";
            }
            
            if ( [shoushu.operate_date isEqualToString:@"0"] )
            {
                shoushu.operate_date = @"";
            }
            
            NSArray* operate_tags_ids = [params arrayValueForKey:@"operate_tags_ids"];
            shoushu.operate_tags = [operate_tags_ids componentsJoinedByString:@","];
            
            NSMutableArray* tagNames = [NSMutableArray array];
            NSMutableArray* tagArray = [NSMutableArray array];
            for ( NSNumber* n in operate_tags_ids )
            {
                CDH9ShoushuTag* tag = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDH9ShoushuTag" withValue:n forKey:@"tag_id"];
                [tagArray addObject:tag];
            }
            
            NSArray* objects = [tagArray sortedArrayUsingComparator:^NSComparisonResult(CDH9ShoushuTag*  _Nonnull obj1, CDH9ShoushuTag*  _Nonnull obj2) {
                return [obj1.memberNameLetter compare:obj2.memberNameLetter];
            }];
            
            for (CDH9ShoushuTag* tag in objects )
            {
                [tagNames addObject:tag.name];
            }
            shoushu.operate_tags_names = [tagNames componentsJoinedByString:@","];
        }
        
        [[BSCoreDataManager currentManager] save:nil];
    }
    else
    {
        dict = [self generateResponse:@"请求数据错误"];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:kHShoushuLinesResponse object:searchList userInfo:dict];
    
    if ( self.finished )
    {
        self.finished(dict);
    }
}

@end
