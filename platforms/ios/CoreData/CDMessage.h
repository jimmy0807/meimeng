//
//  CDMessage.h
//  Boss
//
//  Created by XiaXianBing on 15/9/7.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDMessage : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSNumber * isSend;
@property (nonatomic, retain) NSNumber * messageID;
@property (nonatomic, retain) NSNumber * messageType;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * state;

@end
