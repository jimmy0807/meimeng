//
//  HPatientCreateViewController.h
//  meim
//
//  Created by jimmy on 2017/4/27.
//
//

#import "ICTableViewController.h"

@interface HPatientCreateViewController : ICTableViewController

@property(nonatomic, strong)CDMember* member;

- (void)didSaveButtonPressed;

@end
