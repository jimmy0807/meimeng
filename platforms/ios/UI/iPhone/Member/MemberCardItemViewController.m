//
//  MemberCardItemViewController.m
//  Boss
//
//  Created by mac on 15/7/27.
//  Copyright (c) 2015年 BORN. All rights reserved.
//
#define kFilterHeight 70
#define Cellheight 50
#define Sectionheight 20
#import "ProjectViewController.h"
#import "UIImage+Resizable.h"
#import "CDMemberCardProject.h"
#import "MemberCardItemCell.h"
#import "MemberCardItemViewController.h"

NS_ENUM(int, ItemSection)
{
    ItemSectionZero = 0,
};

NS_ENUM(int, ItemRow)
{
    ItemRowZero = 0,
};
@interface MemberCardItemViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)UITableView *tableView;
@property (strong,nonatomic)UIImageView *emptyView;
@end

@implementation MemberCardItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationBar];
    [self initTableView];
}

- (void)initTableView
{
    self.view.backgroundColor = COLOR(242, 242, 242, 1.0);
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.autoresizingMask = 0xff;
    [self.view addSubview:self.tableView];
    if(!(self.cardProject.count>0))
    {
        [self initEmptyView];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)initEmptyView
{
    self.emptyView = [[UIImageView alloc]init];
    self.emptyView.image = [UIImage imageNamed:@"consumables_is_none"];
    self.emptyView.contentMode = UIViewContentModeScaleAspectFit;
    self.emptyView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.emptyView];
    
    NSMutableArray *constraint = [[NSMutableArray alloc]init];
    [constraint addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[emptyView]-(0)-|" options:0 metrics:nil views:@{@"emptyView":self.emptyView}]];
    [constraint addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[tableView]-(0)-[emptyView]-(0)-|" options:0 metrics:nil views:@{@"tableView":self.tableView,@"emptyView":self.emptyView}]];
    [self.view addConstraints:constraint];
    
}

- (void)initNavigationBar
{
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
}

#pragma UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cardProject.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberCardItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MemberCardItemCell" owner:self options:nil] lastObject];
    }
    if(indexPath.section==ItemSectionZero&&indexPath.row==ItemRowZero)
    {
        cell.nameLabel.text = @"总计";
        cell.countLabel.text = @"#";
        double totalPrice = 0;
        for(CDMemberCardProject *project in self.cardProject)
        {
            totalPrice = totalPrice + [project.projectTotalPrice floatValue];
        }
        cell.priceLabel.text = [NSString stringWithFormat:@"¥ %0.1f", totalPrice];
        return cell;
    }else{
        cell.nameLabel.text = ((CDMemberCardProject *)self.cardProject[indexPath.row-1]).projectName;
        cell.countLabel.text = [NSString stringWithFormat:@"x %@",((CDMemberCardProject *)self.cardProject[indexPath.row-1]).projectCount];
        cell.priceLabel.text  = [NSString stringWithFormat:@"¥ %0.1f",[((CDMemberCardProject *)self.cardProject[indexPath.row-1]).projectTotalPrice floatValue]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Sectionheight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return Sectionheight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Cellheight;
}


- (void)reloaData
{
    CDMemberCard *card = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCard" withValue:self.card.cardID forKey:@"cardID"];
    self.cardProject = [[card.projects objectEnumerator] allObjects];
    [self initTableView];
    [self.tableView reloadData];
}

@end
