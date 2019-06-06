//
//  BSYimeiEditPosOperateRequest.h
//  ds
//
//  Created by jimmy on 16/10/28.
//
//

#import "ICRequest.h"

@interface BSYimeiEditPosOperateRequest : ICRequest

@property (nonatomic, strong)NSDictionary *params;
@property (nonatomic, strong)NSString* errorMesasge;
- (id) initWithPosOperate:(CDPosOperate *)operate params:(NSDictionary *)params;
- (id) initWithPosOperateID:(NSNumber *)operateID params:(NSDictionary *)params;

@end
