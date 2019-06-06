//
//  HPatientDetailContainerViewController.m
//  meim
//
//  Created by jimmy on 2017/4/27.
//
//

#import "HPatientDetailContainerViewController.h"
#import "HPatientDetailViewController.h"

@interface HPatientDetailContainerViewController ()
@property(nonatomic, strong)HPatientDetailViewController* childVc;
@end

@implementation HPatientDetailContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)didBackButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.childVc = [segue destinationViewController];
    self.childVc.member = self.member;
}

@end
