//
//  ChangeYaopingCountViewController.m
//  meim
//
//  Created by 波恩公司 on 2018/4/10.
//

#import "ChangeYaopingCountViewController.h"

@interface ChangeYaopingCountViewController ()
@property(nonatomic,strong)IBOutlet UILabel *countLabel;
@end

@implementation ChangeYaopingCountViewController

- (id)initWithProduct
{
    self = [super initWithNibName:@"ChangeYaopingCountViewController" bundle:nil];
    if (self)
    {
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.frame = CGRectMake(0.0, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
        self.countLabel.text = [NSString stringWithFormat:@"%d",self.yaopinCount];

//        UIImageView *naviImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kPadMaskViewWidth, 75)];
//        naviImage.image = [UIImage imageNamed:@"pad_navi_background"];
//        [self.view addSubview:naviImage];
//        
//        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
//        [closeButton setImage:[UIImage imageNamed:@"pad_navi_close_n"] forState:UIControlStateNormal];
//        [closeButton addTarget:self action:@selector(didCloseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:closeButton];
//        
//        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, kPadMaskViewWidth - 200, 75)];
//        nameLabel.text = @"阿司匹林";
//        nameLabel.textAlignment = NSTextAlignmentCenter;
//        nameLabel.font = [UIFont systemFontOfSize:18];
//        [self.view addSubview:nameLabel];
//        
//        UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(kPadMaskViewWidth - 75, 0, 75, 72)];
//        [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
//        confirmButton.backgroundColor = COLOR(96, 211, 212, 1);
//        [confirmButton addTarget:self action:@selector(didConfirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:confirmButton];
//        
//        UILabel *nameTitle = [[UILabel alloc] initWithFrame:CGRectMake(70, 105, 100, 20)];
//        nameTitle.text = @"名称";
//        nameTitle.textColor = COLOR(149, 171, 171, 1);
//        nameTitle.font = [UIFont systemFontOfSize:16];
//        [self.view addSubview:nameTitle];
//        
//        UILabel *nameField = [[UILabel alloc] initWithFrame:CGRectMake(70, 137, 584, 60)];
//        nameField.text = @"阿司匹林";
//        nameField.textColor = COLOR(37, 37, 37, 1);
//        nameField.font = [UIFont systemFontOfSize:16];
//        nameField.textAlignment = NSTextAlignmentCenter;
//        nameField.layer.cornerRadius = 6;
//        nameField.layer.borderColor = COLOR(220, 224, 224, 1);
//        nameField.layer.borderWidth = 1;
//        [self.view addSubview:nameField];
        
        
    }
    return self;
}

- (IBAction)didCloseButtonClicked:(id)sender
{
    [self.maskView.navi popViewControllerAnimated:NO];
}

- (IBAction)didConfirmButtonClicked:(id)sender
{
    self.changeFinish(self.yaopinCount);
    [self.maskView.navi popViewControllerAnimated:NO];
}

- (IBAction)didAddButtonClicked:(id)sender
{
    if (self.yaopinCount < 100) {
        self.yaopinCount = self.yaopinCount + 1;
    }
    self.countLabel.text = [NSString stringWithFormat:@"%d",self.yaopinCount];
}

- (IBAction)didMinusButtonClicked:(id)sender
{
    if (self.yaopinCount > 1) {
        self.yaopinCount = self.yaopinCount - 1;
    }
    self.countLabel.text = [NSString stringWithFormat:@"%d",self.yaopinCount];
}

@end
