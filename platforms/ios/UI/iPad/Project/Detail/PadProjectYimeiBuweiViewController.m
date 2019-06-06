//
//  PadProjectYimeiBuweiViewController.m
//  meim
//
//  Created by jimmy on 17/2/6.
//
//

#import "PadProjectYimeiBuweiViewController.h"

@interface PadProjectYimeiBuweiViewController ()
@property(nonatomic, weak)IBOutlet UIImageView* nameBgImageView;
@property(nonatomic, weak)IBOutlet UIImageView* countBgImageView;
@property(nonatomic, weak)IBOutlet UITextField* nameTextField;
@property(nonatomic, weak)IBOutlet UITextField* countTextField;
@end

@implementation PadProjectYimeiBuweiViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameBgImageView.image = [[UIImage imageNamed:@"pos_text_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
    self.countBgImageView.image = [[UIImage imageNamed:@"pos_text_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
    self.nameTextField.text = self.buwei.name;
    self.countTextField.text = [self.buwei.count stringValue];
}


- (IBAction)didBackButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    if ( self.nameTextField.text.length > 0 && self.countTextField.text.length > 0 )
    {
        if ( self.buwei )
        {
            
        }
        else
        {
            self.buwei = [[BSCoreDataManager currentManager] insertEntity:@"CDYimeiBuwei"];
        }
        
        self.buwei.name = self.nameTextField.text;
        self.buwei.count = @([self.countTextField.text floatValue]);
        [[BSCoreDataManager currentManager] save:nil];
        
        [self.delegate didBuweiEditFinished:self.buwei];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ( [textField.text floatValue] > self.totalCount )
    {
        textField.text = [NSString stringWithFormat:@"%d",self.totalCount];
    }
}

@end
