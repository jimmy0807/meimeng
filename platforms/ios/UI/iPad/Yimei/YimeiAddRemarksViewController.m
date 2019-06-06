//
//  YimeiAddRemarksViewController.m
//  meim
//
//  Created by jimmy on 16/12/26.
//
//

#import "YimeiAddRemarksViewController.h"

@interface YimeiAddRemarksViewController ()
@property(nonatomic, weak)IBOutlet UITextView* remarkTextView;
@end

@implementation YimeiAddRemarksViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.remarkTextView.text = self.remark;
    
    self.remarkTextView.layer.borderColor = COLOR(234, 234, 234, 1).CGColor;
    self.remarkTextView.layer.borderWidth = 1;
    self.remarkTextView.layer.masksToBounds = TRUE;
}

- (IBAction)didCloseButtonPressed:(id)sender
{
    [self.delegate didYimeiAddRemarksViewControllerFinsish:self.remarkTextView.text];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
