//
//  BSProjectRequest.h
//  Boss
//
//  Created by XiaXianBing on 15/9/14.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum RequestFinishedFetchType
{
    RequestFinishedType_ALL,
    RequestFinishedFetchType_ProjectItem,
    RequestFinishedFetchType_Template
}RequestFinishedFetchType;

@interface BSProjectRequest : NSObject

@property (nonatomic, strong) NSString *errorMessage;

+ (BSProjectRequest *)sharedInstance;

//@property (nonatomic, assign) RequestFinishedFetchType type;

- (void)startProjectRequest;
- (void)startProjectRequestNoErrorMSG;

@end
