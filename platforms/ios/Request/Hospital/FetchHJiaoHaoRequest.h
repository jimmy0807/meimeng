//
//  FetchHJiaoHaoRequest.h
//  meim
//
//  Created by jimmy on 2017/4/27.
//
//

#import "ICRequest.h"

@interface FetchHJiaoHaoRequest : ICRequest

@property(nonatomic)BOOL isDone;
@property(nonatomic)BOOL isPrint;
@property(nonatomic)BOOL isMySelf;
@property(nonatomic)BOOL isCancel;
@property(nonatomic)BOOL isModify;
@property(nonatomic)NSString* keyword;

@end
