//
//  moreSetupModel.h
//  Boss
//
//  Created by jiangfei on 16/6/14.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface moreSetupModel : NSObject
/** name */
@property (nonatomic,copy)NSString *name;
/** norImageName */
@property (nonatomic,copy)NSString *norImageName;
/** selImageName */
@property (nonatomic,copy)NSString *selImageName;
/** placeHold */
@property (nonatomic,copy)NSString *placeHold;
/** textContect*/
@property (nonatomic,strong)NSString *textContent;
/**  选中*/
@property (nonatomic,assign)BOOL imageSeleted;
+(instancetype)moreSetupModelWithDict:(NSMutableDictionary*)dict;
@end
