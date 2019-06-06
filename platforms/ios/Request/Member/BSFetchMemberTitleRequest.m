//
//  BSFetchMemberTitleRequest.m
//  Boss
//
//  Created by lining on 16/4/5.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "BSFetchMemberTitleRequest.h"

@implementation BSFetchMemberTitleRequest

- (BOOL)willStart
{
    [super willStart];
    
    self.tableName = @"res.partner.title";
    
    [self sendShopAssistantXmlSearchReadCommand];
    return TRUE;
}


- (void)didFinishOnMainThread
{
    NSArray *retArray = [BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([retArray isKindOfClass:[NSArray class]]) {
        NSMutableArray *oldTitles = [NSMutableArray arrayWithArray:[[BSCoreDataManager currentManager] fetchItems:@"CDMemberTitle"]];
        for (NSDictionary *params in retArray) {
            NSNumber *title_id = [params numberValueForKey:@"id"];
            CDMemberTitle *title = [[BSCoreDataManager currentManager] findEntity:@"CDMemberTitle" withValue:title_id forKey:@"title_id"];
            if (title == nil) {
                title = [[BSCoreDataManager currentManager] insertEntity:@"CDMemberTitle"];
                title.title_id = title_id;
            }
            else
            {
                [oldTitles removeObject:title];
            }
            
            title.title_name = [params stringValueForKey:@"name"];
            title.shortcut = [params stringValueForKey:@"shortcut"];
        }
        [[BSCoreDataManager currentManager] deleteObjects:oldTitles];
        [[BSCoreDataManager currentManager] save:nil];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchMemberTitleResponse object:nil userInfo:dict];
}

@end
