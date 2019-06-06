//
//  combiEditController.h
//  Boss
//
//  Created by jiangfei on 16/6/14.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductProjectBaseController.h"
@class CDProjectRelated;
@protocol combiEditControllerDelegate <NSObject>

@optional
//改变数量;
-(void)combiEditControllerNumChang:(NSInteger)num andRelated:(CDProjectRelated*)related andTemp:(CDProjectTemplate*)temp;

@end
@interface combiEditController : ProductProjectBaseController
/** projectRelated BSProjectRelatedItemRequest*/
@property (nonatomic,strong)CDProjectRelated *related;
/**  tage*/
@property (nonatomic,assign)NSUInteger combiTage;
/** delegate*/
@property (nonatomic,weak)id<combiEditControllerDelegate>delegate;
@end
