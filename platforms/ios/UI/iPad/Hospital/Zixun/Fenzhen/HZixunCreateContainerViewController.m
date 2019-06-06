//
//  HZixunCreateContainerViewController.m
//  meim
//
//  Created by jimmy on 2017/4/27.
//
//

#import "HZixunCreateContainerViewController.h"
#import "HZixunCreateViewController.h"

@interface HZixunCreateContainerViewController ()
@property(nonatomic, strong)HZixunCreateViewController* childVc;
@property(nonatomic, weak)IBOutlet UILabel* titleLabel;
@end

@implementation HZixunCreateContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ( [self.categoryName isEqualToString:@"advisory"] )
    {
        self.titleLabel.text = @"咨询";
    }
    else if ( [self.categoryName isEqualToString:@"complaints"] )
    {
        self.titleLabel.text = @"投诉";
    }
    else if ( [self.categoryName isEqualToString:@"service"] )
    {
        self.titleLabel.text = @"客服";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.childVc = [segue destinationViewController];
    self.childVc.zixun = self.zixun;
    self.childVc.categoryName = self.categoryName;
}

- (IBAction)didBackButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didSaveButtonPressed:(id)sender
{
    [self.childVc didSaveButtonPressed];
}

@end
