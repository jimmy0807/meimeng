//
//  HPatientNewRecipeViewController.m
//  meim
//
//  Created by 波恩公司 on 2017/9/21.
//
//

#import "HPatientNewRecipeViewController.h"
#import "SeletctListViewController.h"
#import "CBLoadingView.h"
#import "HPatientRecipeCreateTableViewCell.h"
#import "PadSideBarViewController.h"
#import "HPatientBinglikaViewController.h"

@interface HPatientNewRecipeViewController ()

//@property(nonatomic, strong)SeletctListViewController* selectVC;
@property(nonatomic, weak)IBOutlet UILabel* countLabel;
@property (nonatomic, assign) NSInteger medicineCountNumber;
@property(nonatomic, weak)IBOutlet UIView* bgView;
@property(nonatomic, weak)IBOutlet UITextField* yongfaTextField;
//@property(nonatomic, weak)IBOutlet UILabel* officeLabel;
//@property(nonatomic, weak)IBOutlet UILabel* zhenduanLabel;
//@property(nonatomic, weak)IBOutlet UITextField* zhenduanTextField;
//@property(nonatomic, weak)IBOutlet UITextView* noteTextView;
//@property(nonatomic, weak)IBOutlet UILabel* memzhenLabel;
//@property(nonatomic, weak)IBOutlet UITableView* createRecipeTableView;
//@property(nonatomic, strong)NSMutableOrderedSet* indexSet;
@end

@implementation HPatientNewRecipeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.medicineCountNumber = 1;
    self.countLabel.text = [NSString stringWithFormat:@"%d",self.medicineCountNumber];
}

- (IBAction)didMinusButtonPressed:(id)sender
{
    if (self.medicineCountNumber > 1) {
        self.medicineCountNumber -= 1;
    }
    self.countLabel.text = [NSString stringWithFormat:@"%d",self.medicineCountNumber];
}

- (IBAction)didPlusButtonPressed:(id)sender
{
    self.medicineCountNumber +=1;
    self.countLabel.text = [NSString stringWithFormat:@"%d",self.medicineCountNumber];
}

- (IBAction)didBackButtonPressed:(id)sender
{
    [self hideWithAnimation];
}

- (void)showWithAnimation
{
//    __block CGRect frame = self.bgView.frame;
//    frame.origin.y = 768;
//    self.bgView.frame = frame;
//    
//    [UIView animateWithDuration:0.15 animations:^{
//        frame.origin.y = 0;
//        self.bgView.frame = frame;
//    }];
}

- (void)hideWithAnimation
{
//    [UIView animateWithDuration:0.15 animations:^{
//        CGRect frame = self.bgView.frame;
//        frame.origin.y = 768;
//        self.bgView.frame = frame;
//    } completion:^(BOOL finished) {
//        [self.view removeFromSuperview];
//    }];
    [self.view removeFromSuperview];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //self.memberCardNum = textField.text;
}

- (IBAction)didOKButtonPressed:(id)sender
{
    [self didBackButtonPressed:nil];
}

@end
