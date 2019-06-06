//
//  BSImportMemberCardRequest.h
//  Boss
//
//  Created by XiaXianBing on 15/8/20.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"
#import "BSOverdraft.h"

typedef enum kImportMemberCardType
{
    kImportMemberCardEdit,
    kImportMemberCardCreate,
    kImportFetchMemberCardID,
    kImportMemberCardActive
}kImportMemberCardType;

@interface BSImportMemberCardRequest : ICRequest

- (id)initWithParams:(NSDictionary *)params;
- (id)initWithOperateID:(NSNumber *)operateID params:(NSDictionary *)params;
- (id)initWithOperateID:(NSNumber *)operateID;
- (id)initWithMemberCardID:(NSNumber *)cardID;

@end
