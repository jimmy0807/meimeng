//
//  BSYimeiEditOperateActivityRequest.h
//  ds
//
//  Created by jimmy on 16/11/7.
//
//

#import "ICRequest.h"

@interface BSYimeiEditOperateActivityRequest : ICRequest

- (id)initWithOperateActivityToNextState:(CDOperateActivity *)activity;

@property(nonatomic)BOOL isBack;

@end
