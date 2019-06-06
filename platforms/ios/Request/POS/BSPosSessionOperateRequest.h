//
//  BSPosSessionOperateRequest.h
//  Boss
//
//  Created by XiaXianBing on 2016-3-3.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICRequest.h"

typedef enum kBSPosSessionOperateType
{
    kBSPosSessionOpen,
    kBSPosSessionClose,
    kBSPosSessionReOpen
}kBSPosSessionOperateType;

@interface BSPosSessionOperateRequest : ICRequest

- (id)initWithType:(kBSPosSessionOperateType)type;

@end
