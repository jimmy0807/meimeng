//
//  GiveTemplateViewController.m
//  Boss
//
//  Created by lining on 16/4/15.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "GiveTemplateViewController.h"
#import "BSFetchCardTemplateRequest.h"
#import "TemplateCell.h"
#import "GiveTicketViewController.h"
#import "GiveCardViewController.h"
#import "UIView+Frame.h"
#import "GivePopupGiftCardDescription.h"

@interface GiveTemplateViewController ()
@property (nonatomic, strong) NSArray *templates;
@property (nonatomic, strong) NSFetchedResultsController *templateResultsController;
@end

@implementation GiveTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noKeyboardNotification = YES;
    
//    if (self.type == kTemplateType_coupon) {
//        self.titleLabel.text = @"礼品券模板";
//    }
//    else if (self.type == kTemplateType_card)
//    {
//        self.titleLabel.text = @"礼品卡模板";
//    }

    [self registerNofitificationForMainThread:kBSFetchCardTemplateResponse];
    
    BSFetchCardTemplateRequest *templateRequest = [[BSFetchCardTemplateRequest alloc] init];
    [templateRequest execute];
    
    [self reloadData];
}


- (void)reloadData
{
//    self.templates = [[BSCoreDataManager currentManager] fetchCardTemplatesWithType:self.type];
    
    self.templateResultsController = [[BSCoreDataManager currentManager] fetchCardTemplates];
    [self.tableView reloadData];
}


#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    [self reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.templateResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = self.templateResultsController.sections[section];
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TemplateCell *templateCell = [tableView dequeueReusableCellWithIdentifier:@"TemplateCell"];
    if (templateCell == nil) {
        templateCell = [TemplateCell createCell];
//        templateCell.backgroundColor = [UIColor redColor];
    }
    
//    CDCardTemplate *template = [self.templates objectAtIndex:indexPath.row];
    CDCardTemplate *template = [self.templateResultsController objectAtIndexPath:indexPath];
    UIImage *defaultImg = nil;
    if ([template.card_type integerValue] == kTemplateType_coupon) {
        defaultImg = [UIImage imageNamed:@"give_coupon_template_default.png"];
    }
    else
    {
        defaultImg = [UIImage imageNamed:@"give_card_template_default.png"];
    }
    [templateCell.imgView sd_setImageWithURL:[NSURL URLWithString:template.template_pic_url] placeholderImage:defaultImg completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        templateCell.imageView.image = image;
    }];
    templateCell.nameLabel.text = template.template_name;
    templateCell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[template.money floatValue]];
    
    return templateCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    CDCardTemplate *template = [self.templates objectAtIndex:indexPath.row];
    CDCardTemplate *template = [self.templateResultsController objectAtIndexPath:indexPath];
    if ([template.card_type integerValue] == kTemplateType_coupon) {
        GiveTicketViewController *ticketVC = [[GiveTicketViewController alloc] init];
        ticketVC.cardTemplate = template;
        ticketVC.givePeople = self.givePeople;
        [self.navigationController pushViewController:ticketVC animated:YES];
    }
    else
    {
        GiveCardViewController *cardVC = [[GiveCardViewController alloc] init];
        cardVC.cardTemplate = template;
        cardVC.givePeople = self.givePeople;
        [self.navigationController pushViewController:cardVC animated:YES];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 75;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 75)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15.0];
    [view addSubview:label];
    
//    pad_project_side_line.png
    UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 74, tableView.width, 1)];
    lineImgView.image = [UIImage imageNamed:@"pad_project_side_line.png"];
    [view addSubview:lineImgView];
    
    id<NSFetchedResultsSectionInfo>sectionInfo = self.templateResultsController.sections[section];
    if ([sectionInfo.name integerValue] == kTemplateType_coupon) {
        label.text = @"礼品券模板";
    }
    else
    {
        label.text = @"礼品卡模板";
    }
    
    return view;
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)helpBtnPressed:(UIButton *)sender {
    NSLog(@"helpBtnPressed");
    [GivePopupGiftCardDescription show];
}
@end
