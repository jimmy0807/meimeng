//
//  UpdatePrintServerRequest.h
//  meim
//
//  Created by 波恩公司 on 2017/12/22.
//

#import "ICRequest.h"

@interface UpdatePrintServerRequest : ICRequest

- (id)initWithAttribute:(NSString *)attribute attributeName:(NSString *)attributeName;
- (instancetype)initWithParams:(NSDictionary *)params;

@property(nonatomic, strong)NSNumber *userID;
@property(nonatomic, strong)NSString *attribute;
@property(nonatomic, strong)NSString *attributeName;

@property(nonatomic, strong)PersonalProfile* profile;
@property(nonatomic, strong)NSDictionary* params;

@end
