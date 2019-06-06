//
//  MemberRecordDataSourceProtocol.h
//  Boss
//
//  Created by lining on 16/4/11.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MemberRecordDataSourceProtocol <NSObject>
@optional
- (void)didItemSelectedwithType:(NSString *)type atIndexPath:(NSIndexPath *)indexPath ;
@end
