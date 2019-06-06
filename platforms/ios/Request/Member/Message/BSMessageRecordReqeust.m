//
//  BSMessageRecordReqeust.m
//  meim
//
//  Created by lining on 2016/11/30.
//
//

#import "BSMessageRecordReqeust.h"


#define kFetchCount 20

@interface BSMessageRecordReqeust ()
@property (nonatomic, assign) NSInteger startIndex;
@end

@implementation BSMessageRecordReqeust

- (instancetype)initWithStartIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        self.startIndex = index/kFetchCount + 1;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.startIndex = 1;
    }
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    
    NSString *cmd = [NSString stringWithFormat:@"%@%@", SERVER_IP ,@"/xmlrpc/2/ds_api"];
 
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       [PersonalProfile currentProfile].companyUUID,@"company_born_uuid",
                       [PersonalProfile currentProfile].shopUUID,@"shop_born_uuid",
                       [PersonalProfile currentProfile].born_uuid,@"user_born_uuid",nil];
    
    params[@"current_page"] = @(self.startIndex);
    params[@"page_size"] = @(kFetchCount);
    NSString *jsonString = [BNXmlRpc jsonWithArray:@[params]];
    NSString *xmlString = [BNXmlRpc xmlMethod:@"get_sms_message_records" jsonString:jsonString];
    [self sendXmlCommand:cmd params:xmlString];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSDictionary *retDict = (NSDictionary *)[BNXmlRpc arrayWithXmlRpc:self.resultStr];
    NSLog(@"retDict: %@",retDict);
    NSMutableDictionary *dict;
    NSNumber *ret = [retDict numberValueForKey:@"errcode"];
    if (ret.integerValue == 0) {
        NSArray *retData = [retDict objectForKey:@"data"];
        
        NSMutableArray *oldMessageRecords;
        if (self.startIndex == 1) {
            oldMessageRecords = [[NSMutableArray alloc] initWithArray:[[BSCoreDataManager currentManager] fetchMemberMessageRecords]];
        }
        
        
        for (NSDictionary *params in retData) {
            NSString *send_no = [params stringValueForKey:@"no"];
            CDMessageRecord *messageRecord = [[BSCoreDataManager currentManager] findEntity:@"CDMessageRecord" withValue:send_no forKey:@"send_no"];
            if (messageRecord) {
                [oldMessageRecords removeObject:messageRecord];
            }
            else
            {
                messageRecord = [[BSCoreDataManager currentManager] insertEntity:@"CDMessageRecord"];
                messageRecord.send_no = send_no;
            }
            
            messageRecord.send_date = [params stringValueForKey:@"sent_date"];
            messageRecord.template_content = [params stringValueForKey:@"template_content"];
            messageRecord.phones = [params stringValueForKey:@"phone"];
            messageRecord.born_uuid = [PersonalProfile currentProfile].born_uuid;
            messageRecord.shop_uuid = [PersonalProfile currentProfile].shopUUID;
            messageRecord.company_uuid = [PersonalProfile currentProfile].companyUUID;
        }
        
        [[BSCoreDataManager currentManager] deleteObjects:oldMessageRecords];
    }
    else
    {
        dict = [self generateResponse:[retDict stringValueForKey:@"errmsg"]];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:kBSMessageRecordResponse object:nil userInfo:dict];
}

@end
