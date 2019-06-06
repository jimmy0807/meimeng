//
//  HPatientBinglikaViewController.h
//  meim
//
//  Created by jimmy on 2017/4/27.
//
//

#import "ICCommonViewController.h"
#import "HPatientBingliLeftViewController.h"

@interface HPatientBinglikaViewController : ICCommonViewController

@property(nonatomic, strong)HPatientBingliLeftViewController* leftChildVc;
@property(nonatomic, strong)CDMember* member;
@property(nonatomic)BOOL hideShoushu;
@property(nonatomic, copy)void (^shoushuListPressed)(CDHShoushu* shoushu, NSInteger index);

- (void)shouShoushuView:(NSInteger)index;

@end

