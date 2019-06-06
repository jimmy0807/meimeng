//
//  FetchYimeiPhotoImageRequest.m
//  ds
//
//  Created by jimmy on 16/11/9.
//
//

#import "FetchYimeiPhotoImageRequest.h"

@implementation FetchYimeiPhotoImageRequest

- (BOOL)willStart
{
    if ( self.ids.count == 0 )
        return FALSE;
    if ( self.requestTableName )
    {
        self.tableName = self.requestTableName;
    }
    else
    {
        self.tableName = @"born.member.image";
    }
    self.filter = @[@[@"id", @"in", self.ids]];
    self.field = @[@"image_url",@"take_time"];
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
        for (NSDictionary *params in resultArray)
        {
            NSNumber* imageID = [params numberValueForKey:@"id"];
            CDYimeiImage* a = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDYimeiImage" withValue:imageID forKey:@"imageID"];
            a.url = [params stringValueForKey:@"image_url"];
            a.small_url = [NSString stringWithFormat:@"%@?w=200",a.url];
            a.type = @"server";
            a.status = @"success";
            a.take_time = [params stringValueForKey:@"take_time"];
        }
        
        [dataManager save:nil];
    }
    else
    {
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchYimeiOperateActivityResponse object:nil userInfo:dict];
}

@end
