//
//  HFetchWxShopQrCodeRequest.m
//  meim
//
//  Created by jimmy on 2017/5/22.
//
//

#import "HFetchWxShopQrCodeRequest.h"

@implementation HFetchWxShopQrCodeRequest

- (BOOL)willStart
{
    self.tableName = @"born.wxshop.template";
    NSMutableArray *filters = [NSMutableArray array];
    
    [filters addObject:@[@"internal_type", @"=", @"wxmedical"]];
    
    self.filter = filters;
    self.field = @[@"qr_image_url"];
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

-(void)didFinishOnMainThread
{
    NSArray *resultList = [BNXmlRpc arrayWithXmlRpc:resultStr];
#pragma mark - 9月份新修改
    //NSLog(@"resultList :%@",resultList);
    ///假设后台配置了二维码 发通知出去
    //[[NSNotificationCenter defaultCenter] postNotificationName:kHFetchWxShopQrCodeResponse object:self userInfo:@{@"url":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505892618069&di=1a43339245cc7f32a3840d60513fb221&imgtype=0&src=http%3A%2F%2Fbizhi.zhuoku.com%2F2011%2F08%2F29%2Fjingxuan%2Fjingxuan165.jpg"}];
    //后台配的是一张二维码的图片地址XXX.jpg/png 而不是链接地址 所以能用imageV sd_URL...直接显示
    if ([resultList isKindOfClass:[NSArray class]] && resultList.count > 0 )
    {
        if ( resultList.count > 0 )
        {
            NSDictionary* params = resultList[0];
            NSString* url = params[@"qr_image_url"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kHFetchWxShopQrCodeResponse object:self userInfo:@{@"url":url}];
        }
    }
}

@end
