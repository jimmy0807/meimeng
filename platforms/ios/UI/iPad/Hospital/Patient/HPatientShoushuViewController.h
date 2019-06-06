//
//  HPatientShoushuViewController.h
//  meim
//
//  Created by jimmy on 2017/5/9.
//
//

#import <UIKit/UIKit.h>

@interface HPatientShoushuViewController : UIViewController

@property(nonatomic, strong)CDMember* member;
@property(nonatomic)NSInteger shoushuIndex;

- (void)didSaveHuizhenButtonPressed;

@end
