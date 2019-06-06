//
//  HPartnerCreateLeftViewController.h
//  meim
//
//  Created by jimmy on 2017/5/2.
//
//

#import "ICTableViewController.h"

@interface HPartnerCreateLeftViewController : ICTableViewController

@property(nonatomic, strong)CDPartner* partner;

- (void)didSaveButtonPressed;

@end
