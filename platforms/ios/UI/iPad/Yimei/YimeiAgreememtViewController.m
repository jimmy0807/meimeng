//
//  YimeiAgreememtViewController.m
//  ds
//
//  Created by jimmy on 16/10/28.
//
//

#import "YimeiAgreememtViewController.h"

@interface YimeiAgreememtViewController ()
@property(nonatomic, weak)IBOutlet UITextView* promiseTextView;
@property (strong, nonatomic) IBOutlet UIWebView *promiseWebView;
@end

@implementation YimeiAgreememtViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.promiseTextView.text = self.promise;
    self.promiseWebView.backgroundColor = [UIColor whiteColor];
    [self.promiseWebView loadHTMLString:self.promise baseURL:nil];
}

- (IBAction)didCloseButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
