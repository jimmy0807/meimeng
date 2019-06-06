//
//  HPatientTypeFilterViewController.h
//  meim
//
//  Created by jimmy on 2017/7/18.
//
//

#import <UIKit/UIKit.h>

@interface HPatientTypeFilterViewController : ICCommonViewController

@property(nonatomic, copy) void (^selectFinished)(NSMutableSet* items, NSArray* filterIDArray);
@property(nonatomic, strong)NSMutableSet* set;

@end
