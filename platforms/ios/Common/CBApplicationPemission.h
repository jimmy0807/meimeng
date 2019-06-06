//
//  CBApplicationPemission.h
//  CardBag
//
//  Created by lining on 15/6/19.
//  Copyright (c) 2015年 Everydaysale. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBApplicationPemission : NSObject<UIAlertViewDelegate>
+(id)sharePermission;
-(BOOL)canLocation;
-(BOOL)canLoadCamera;
-(BOOL)canLoadPhotoLibrary;
-(BOOL)canLoadContact;
@end
