//
//  BSFetchPayStatementRequest.h
//  Boss
//
//  Created by XiaXianBing on 15/11/3.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICRequest.h"

@interface BSFetchPayStatementRequest : ICRequest

- (id)initWithStatementIds:(NSArray *)statementIds;

@end
