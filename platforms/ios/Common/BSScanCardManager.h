//
//  BSScanCardManager.h
//  Boss
//
//  Created by jimmy on 15/11/12.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBSScanCardManagerResponse   @"kBSScanCardManagerResponse"

@interface BSScanCardManager : NSObject

InterfaceSharedManager(BSScanCardManager)

-(void)fetchCardFromQRCode:(NSString*)code;

@end
