//
//  CreateH9ShoushuTagRequest.h
//  meim
//
//  Created by jimmy on 2017/8/22.
//
//

#import "ICRequest.h"

@interface CreateH9ShoushuTagRequest : ICRequest

@property(nonatomic, strong)NSMutableDictionary* params;
@property (nonatomic, copy, nullable)void (^requestFinished)(NSDictionary* params, NSNumber* tagID);

@end
