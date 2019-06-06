//
//  PadHospitalCustomerListViewController.h
//  meim
//
//  Created by jimmy on 2017/4/14.
//
//

#import "ICCommonViewController.h"

#import "PadProjectConstant.h"


@protocol PadHospitalCustomerListViewControllerDelegate <NSObject>

- (void)didMemberSelectCancel;
- (void)didMemberCreateButtonClick;

@end

@interface PadHospitalCustomerListViewController : ICCommonViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate>

@property (nonatomic, assign) id<PadHospitalCustomerListViewControllerDelegate> delegate;

- (void)didTextFieldEditDone:(UITextField *)textField;

@end
