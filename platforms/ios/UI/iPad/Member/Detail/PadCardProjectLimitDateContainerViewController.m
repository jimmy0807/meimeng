//
//  PadCardProjectLimitDateContainerViewController.m
//  meim
//
//  Created by jimmy on 2017/8/17.
//
//

#import "PadCardProjectLimitDateContainerViewController.h"
#import "PadCardProjectLimitDateViewController.h"
#import "CBLoadingView.h"
#import "CBMessageView.h"
#import "EditCardProjectLimitDateRequest.h"

@interface PadCardProjectLimitDateContainerViewController ()

@end

@implementation PadCardProjectLimitDateContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PadCardProjectLimitDateViewController* vc = segue.destinationViewController;
    vc.project = self.project;
}


- (IBAction)didConfirmButtonPressed:(id)sender
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if ( self.project.isLimited.boolValue && self.project.limitedDate.length > 6 )
    {
        params[@"limited_date"] = self.project.limitedDate;
        params[@"line_id"] = self.project.productLineID;;
        EditCardProjectLimitDateRequest* request = [[EditCardProjectLimitDateRequest alloc] init];
        request.params = params;
        [request execute];
        [[CBLoadingView shareLoadingView] show];
        request.finished = ^(NSDictionary *params) {
            [[CBLoadingView shareLoadingView] hide];
            if ( [params[@"rc"] integerValue] == 0 )
            {
                [[[CBMessageView alloc] initWithTitle:@"修改成功"] show];
                [self hide];
            }
            else
            {
                [[[CBMessageView alloc] initWithTitle:params[@"rm"]] show];
            }
        };
        
        return;
    }
    
    [self hide];
}

- (IBAction)didCancelButtonPressed:(id)sender
{
    [self hide];
}

- (void)hide
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

- (void)show
{
    self.view.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 1;
    }];
}

@end
