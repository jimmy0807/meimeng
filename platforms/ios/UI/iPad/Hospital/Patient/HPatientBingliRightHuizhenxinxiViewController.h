//
//  HPatientBingliRightHuizhenxinxiViewController.h
//  meim
//
//  Created by jimmy on 2017/4/27.
//
//

#import <UIKit/UIKit.h>

@interface HPatientBingliRightHuizhenxinxiViewController : UIViewController

@property(nonatomic, strong)CDMember* member;
@property(nonatomic, copy)void (^editItemBlcok)(void);

- (void)popNavi;
- (void)didCreateHuizhenButtonPressed;
- (void)didSaveHuizhenButtonPressed;
- (void)didBackButtonPressed;

@end
