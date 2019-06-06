//
//  PadHospitalCreateCustomerContainerViewController.m
//  meim
//
//  Created by jimmy on 2017/4/26.
//
//

#import "PadHospitalCreateCustomerContainerViewController.h"
#import "PadHospitalCreateCustomerViewController.h"
#import "CBLoadingView.h"

@interface PadHospitalCreateCustomerContainerViewController ()
@property(nonatomic, strong)PadHospitalCreateCustomerViewController* childVc;
@end

@implementation PadHospitalCreateCustomerContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.noKeyboardNotification = YES;
    
    [self registerNofitificationForMainThread:kHCustomerCreateResponse];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PadHospitalCreateCustomerViewController* vc = [segue destinationViewController];
    vc.customer = self.customer;
    self.childVc = vc;
}

- (IBAction)didBackButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kHCustomerCreateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSString *message = [notification.userInfo stringValueForKey:@"rm"];
            if(message.length != 0)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:message
                                                                   delegate:nil
                                                          cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    }
}

- (IBAction)didSaveButtonPressed:(id)sender
{
    [self.childVc didConfirmButtonClick:nil];
}

@end
