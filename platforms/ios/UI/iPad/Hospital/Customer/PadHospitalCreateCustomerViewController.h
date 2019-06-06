//
//  PadHospitalCreateCustomerViewController.h
//  meim
//
//  Created by jimmy on 2017/4/12.
//
//

#import <UIKit/UIKit.h>

#import "ICCommonViewController.h"
#import "PadMaskView.h"
#import "BNActionSheet.h"
#import "PadMemberAndCardViewController.h"
#import "ICTableViewController.h"

@interface PadHospitalCreateCustomerViewController : ICTableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, BNActionSheetDelegate, UITextFieldDelegate>

@property (nonatomic, strong) PadMaskView *maskView;
@property (nonatomic, strong) PadMemberAndCardViewController *parent;

@property(nonatomic, strong)CDHCustomer* customer;

- (void)didConfirmButtonClick:(id)sender;

@end
