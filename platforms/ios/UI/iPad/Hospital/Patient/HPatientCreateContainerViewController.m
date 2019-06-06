//
//  HPatientCreateContainerViewController.m
//  meim
//
//  Created by jimmy on 2017/4/27.
//
//

#import "HPatientCreateContainerViewController.h"
#import "HPatientCreateViewController.h"
#import "CBLoadingView.h"

@interface HPatientCreateContainerViewController ()
@property(nonatomic, strong)HPatientCreateViewController* childVc;
@end

@implementation HPatientCreateContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerNofitificationForMainThread:kBSMemberCreateResponse];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    HPatientCreateViewController* vc = [segue destinationViewController];
    vc.member = self.member;
    self.childVc = vc;
}

- (IBAction)didBackButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSMemberCreateResponse])
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
    [self.childVc didSaveButtonPressed];
}

@end
