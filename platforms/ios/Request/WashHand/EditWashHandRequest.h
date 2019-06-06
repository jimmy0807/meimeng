//
//  EditWashHandRequest.h
//  meim
//
//  Created by jimmy on 2017/6/27.
//
//

#import "ICRequest.h"

@interface EditWashHandRequest : ICRequest

@property(nonatomic, strong)NSMutableDictionary* params;
@property(nonatomic, strong)CDPosWashHand* wash;
@property(nonatomic)BOOL isCancel;
@property(nonatomic)BOOL notGoNext;
@property(nonatomic, strong)NSMutableArray* uploadArray;

@end
