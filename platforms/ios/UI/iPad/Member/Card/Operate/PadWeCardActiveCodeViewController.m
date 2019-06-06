//
//  PadWeCardActiveCodeViewController.m
//  Boss
//
//  Created by XiaXianBing on 2016-4-8.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PadWeCardActiveCodeViewController.h"
#import "PadProjectConstant.h"
#import "PadCardOperateCell.h"

@interface PadWeCardActiveCodeViewController ()

@property (nonatomic, strong) CDMemberCard *memberCard;
@property (nonatomic, strong) UITableView *activeTableView;

@end

@implementation PadWeCardActiveCodeViewController

- (id)initWithMemberCard:(CDMemberCard *)memberCard
{
    self = [super initWithNibName:@"PadWeCardActiveCodeViewController" bundle:nil];
    if (self)
    {
        self.memberCard = memberCard;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0.0, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
    
    self.activeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, self.view.frame.size.width, IC_SCREEN_HEIGHT - kPadNaviHeight) style:UITableViewStylePlain];
    self.activeTableView.backgroundColor = [UIColor clearColor];
    self.activeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.activeTableView.delegate = self;
    self.activeTableView.dataSource = self;
    self.activeTableView.showsVerticalScrollIndicator = NO;
    self.activeTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.activeTableView];
    
    UIImage *naviImage = [UIImage imageNamed:@"pad_navi_background"];
    UIImageView *navi = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, naviImage.size.height)];
    navi.backgroundColor = [UIColor clearColor];
    navi.image = naviImage;
    navi.userInteractionEnabled = YES;
    [self.view addSubview:navi];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, kPadNaviHeight, kPadNaviHeight);
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_close_n"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"pad_navi_close_h"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(didBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    backButton.alpha = 1.0;
    [navi addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadNaviHeight, 0.0, self.view.frame.size.width - 2 * kPadNaviHeight, kPadNaviHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    titleLabel.text = LS(@"PadWeCardActiveCode");
    [navi addSubview:titleLabel];
}

- (void)didBackButtonClick:(id)sender
{
    [self.maskView hidden];
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPadCardOperateCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PadCardOperateCellIdentifier";
    PadCardOperateCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[PadCardOperateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.contentTextField.enabled = NO;
    cell.contentTextField.textAlignment = NSTextAlignmentLeft;
    
    cell.titleLabel.text = LS(@"PadWeCardActiveCode");
    cell.contentTextField.text = self.memberCard.captcha;
    cell.contentTextField.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

@end
