//
//  HPatientCreateShoushuLineContainerViewController.h
//  meim
//
//  Created by jimmy on 2017/5/10.
//
//

#import "ICCommonViewController.h"
#import "HPatientCreateShoushuLineViewController.h"

@interface HPatientCreateShoushuLineContainerViewController : ICCommonViewController

@property(nonatomic, strong)CDHShoushuLine* shoushuLine;
@property(nonatomic, copy)void (^doReload)(void);
@property(nonatomic, strong)HPatientCreateShoushuLineViewController* vc;
@property(nonatomic, strong)NSMutableArray* reviewIDArray;

@end
