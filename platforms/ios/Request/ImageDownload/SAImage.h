//
//  SAImage.h
//  ShopAssistant
//
//  Created by jimmy on 15/3/6.
//  Copyright (c) 2015年 jimmy. All rights reserved.
//

#import "ICRequest.h"
typedef void(^SAImageComplete)(UIImage* image);

@interface SAImageManager : NSObject

InterfaceSharedManager(SAImageManager)
@property(nonatomic, strong)NSMutableDictionary* retryTimesParams;
@property(nonatomic, strong)NSMutableDictionary* downloadingRequestParams;
@end

@interface SAImage : ICRequest

@property (nonatomic, strong) NSString *imageName;

+(UIImage*)getImageWithName:(NSString*)imageName tableName:(NSString*)tableName filter:(NSNumber*)filter fieldName:(NSString*)fieldName writeDate:(NSString*) writeDate userData:(NSObject*)userData;
+(UIImage*)getImageWithName:(NSString*)imageName tableName:(NSString*)tableName filter:(NSNumber*)filter fieldName:(NSString*)fieldName writeDate:(NSString*) writeDate completion:(SAImageComplete)completion;

+ (UIImage *)getImageWithName:(NSString*)imageName;

+(void)cancelDownload:(NSString*)imageName;


- (UIImage*)getImageWithName:(NSString*)imageName tableName:(NSString*)tableName filter:(NSNumber*)filter fieldName:(NSString*)fieldName writeDate:(NSString*) writeDate userData:(NSObject*)userData;

- (UIImage*)getImageWithName:(NSString*)imageName tableName:(NSString*)tableName filter:(NSNumber*)filter fieldName:(NSString*)fieldName writeDate:(NSString*) writeDate completion:(SAImageComplete)completion;

@end
