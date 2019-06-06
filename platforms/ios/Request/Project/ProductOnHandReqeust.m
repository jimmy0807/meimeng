//
//  ProductOnHandReqeust.m
//  ds
//
//  Created by lining on 2016/11/17.
//
//

#import "ProductOnHandReqeust.h"

@interface ProductOnHandReqeust ()
@property (nonatomic, strong) NSDictionary *params;
@end

@implementation ProductOnHandReqeust
- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super init];
    if (self) {
        self.params = params;
    }
    return self;
}

- (BOOL)willStart
{
    [super willStart];
    self.tableName = @"stock.change.product.qty";
    
    [self sendShopAssistantXmlCreateCommand:@[self.params]];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSLog(@"%@",resultList);
    if ([resultList isKindOfClass:[NSNumber class]]) {
        
    }
    else
    {
        dict = [self generateResponse:@"在手数量设置失败"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSProductOnHandResponse object:nil userInfo:dict];
}

@end
