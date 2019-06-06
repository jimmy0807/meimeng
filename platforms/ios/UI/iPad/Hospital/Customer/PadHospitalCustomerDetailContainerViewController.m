//
//  PadHospitalCustomerDetailContainerViewController.m
//  meim
//
//  Created by jimmy on 2017/4/26.
//
//

#import "PadHospitalCustomerDetailContainerViewController.h"
#import "PadHospitalCustomerDetailViewController.h"

@interface PadHospitalCustomerDetailContainerViewController ()

@end

@implementation PadHospitalCustomerDetailContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PadHospitalCustomerDetailViewController* vc = [segue destinationViewController];
    vc.customer = self.customer;
}

- (IBAction)didBackButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
