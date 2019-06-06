//
//  SingletonManager.h
//  meim
//
//  Created by 波恩公司 on 2017/11/14.
//

#import <Foundation/Foundation.h>
#import "PadSideBarViewController.h"
////#import "meim-Swift.h"
//#ifdef meim_dev
//#import "meim_dev-Swift.h"
//#else
//#import "meim-Swift.h"
//#endif

@interface SingletonManager : NSObject
@property (nonatomic,strong)PadSideBarViewController *setttingVC;
//@property (nonatomic,strong)InkDevice *connectingInkDevice;
+ (instancetype)sharedInstance;
@end
