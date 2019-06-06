//
//  HPatientBingliLeftViewController.h
//  meim
//
//  Created by jimmy on 2017/4/27.
//
//

#import "ICTableViewController.h"

@interface HPatientBingliLeftViewController : UIViewController

@property(nonatomic, strong)CDMember* member;
@property(nonatomic)BOOL hideShoushu;

@property(nonatomic, copy)void (^huizhenPressed)(void);
@property(nonatomic, copy)void (^shoushuPressed)(void);
@property(nonatomic, copy)void (^shoushuCreatePressed)(void);
@property(nonatomic, copy)void (^shoushuItemPressed)(CDHShoushu* shoushu, NSInteger index);
@property(nonatomic, copy)void (^peiyaoPressed)(void);

@end
