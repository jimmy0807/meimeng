//
//  HPatientShoushuLineTagViewController.h
//  meim
//
//  Created by jimmy on 2017/8/14.
//
//

#import "ICCommonViewController.h"

@interface HPatientShoushuLineTagViewController : ICCommonViewController

- (void)showWithAnimation:(NSArray*)tagIDs;

@property(nonatomic, copy)void (^didTagSelectedFinsihed)(NSArray* ids, NSString* name);

@end
