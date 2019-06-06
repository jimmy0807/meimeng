//
//  BSHandlePanDianRequest.h
//  Boss
//
//  Created by lining on 15/7/23.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"
typedef enum HandlePanDian
{
    HandlePanDian_create,
    HandlePanDian_edit,
    HandlePanDian_confirmed,
    HandlePanDian_cancel,
    HandlePanDian_delete,
}HandlePanDian;
@interface BSHandlePanDianRequest : ICRequest
@property(nonatomic, strong) NSMutableDictionary *params;
@property(nonatomic, assign) HandlePanDian type;
@property(nonatomic, assign) BOOL needPandian;
@property(nonatomic, assign) BOOL needConfirm;
- (id) initWithPanDian:(CDPanDian *)panDian type:(HandlePanDian)type;
@end
