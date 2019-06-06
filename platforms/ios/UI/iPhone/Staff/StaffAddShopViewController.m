//
//  StaffAddShopViewController.m
//  Boss
//
//  Created by mac on 15/7/13.
//  Copyright (c) 2015年 BORN. All rights reserved.
//
#import "BSCreateShopRequest.h"
#import "BSCommonSelectedItemViewController.h"
#import "BSEditCell.h"
#import "SettingHeadCell.h"
#import "StaffAddShopViewController.h"
NS_ENUM(int, SectionNo)
{
    FirstSection = 0,
    SecondSection = 1,
    ThirdSection = 2,
};

NS_ENUM(int, RowNo)
{
    FirstRow = 0,
    SecondRow = 1,
    ThirdRow = 2,
};
@interface StaffAddShopViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,BSCommonSelectedItemViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation StaffAddShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    [self initData];
    // Do any additional setup after loading the view from its nib.
}

- (void)initData
{
    self.shopInfoArray = [[NSMutableArray alloc]init];
    self.infoTypeArray = [[NSMutableArray alloc]init];
    self.keyValueDic = [[NSMutableDictionary alloc]init];
    self.params = [[NSMutableDictionary alloc]init];
    self.selectedList = [[NSMutableDictionary alloc]init];
    NSMutableArray *accountArray = [[NSMutableArray alloc]initWithArray:@[@"LOGO",@"名称",@"门店类型"]];
    NSMutableArray *accountArray1 = [[NSMutableArray alloc]initWithArray: @[[NSNull null],@"",@"请选择"]];
    
    NSMutableArray *infoArray = [[NSMutableArray alloc]initWithArray: @[@"手机",@"编码",@"默认收银员"]];
    NSMutableArray *infoArray1 = [[NSMutableArray alloc]initWithArray:
                                  @[@"",@"",@"请选择"]];
    
    NSMutableArray *company = [[NSMutableArray alloc]initWithArray:@[@"公司"]];
    NSMutableArray *company1 = [[NSMutableArray alloc]initWithArray:@[@"请选择"]];
    [self.shopInfoArray addObject:accountArray1];
    [self.infoTypeArray addObject:accountArray];
    [self.shopInfoArray addObject:infoArray1];
    [self.infoTypeArray addObject:infoArray];
    
    [self.shopInfoArray addObject:company1];
    [self.infoTypeArray addObject:company];
    
    [self.keyValueDic setValue:@"logo" forKey:@"LOGO"];
    [self.keyValueDic setValue:@"name" forKey:@"名称"];
    [self.keyValueDic setValue:@"mobile" forKey:@"手机"];
    [self.keyValueDic setValue:@"company_id" forKey:@"公司"];
    [self.keyValueDic setValue:@"deafult_code" forKey:@"编码"];
    [self.keyValueDic setValue:@"type" forKey:@"门店类型"];
    [self.keyValueDic setValue:@"pos_user_id" forKey:@"默认收银员"];
    
    
    NSArray *accArray = [[BSCoreDataManager currentManager] fetchAllUser];
    for(CDUser *user in accArray)
    {
        [self.selectedList setObject:user.user_id forKey:user.name];
    }
    
    NSArray* storeList = [[BSCoreDataManager currentManager] fetchItems:@"CDStore" sortedByKey:@"storeID" ascending:YES];
    for (CDStore* s in storeList )
    {
        [self.selectedList setObject:s.storeID forKey:s.storeName];
    }
    [self.selectedList setObject:@"direct" forKey:@"直营店"];
    [self.selectedList setObject:@"affiliate" forKey:@"加盟店"];
}

- (void)initNavigationBar
{
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    
    self.navigationItem.title = @"新建门店";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    /**
     *  设置frame只能控制按钮的大小
     */
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.frame= CGRectMake(0, 0, 40, 44);
    [btn addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = btn_right;
    
    
    
    self.view.backgroundColor = COLOR(242, 242, 242, 1.0);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma UITableView DataSource and delegate 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)self.infoTypeArray[section]).count;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.infoTypeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == FirstSection&&indexPath.row==FirstRow)
    {
        SettingHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"logoCell"];
        if(cell == nil)
        {
            cell = [[SettingHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"logoCell"];
        }
        cell.titleLabel.text = self.infoTypeArray[indexPath.section][indexPath.row];
        if([self.shopInfoArray[indexPath.section][indexPath.row] isKindOfClass:[NSNull class]])
        {
            cell.headImageView.image = [UIImage imageNamed:@"setting_profile.png"];
        }else{
            cell.headImageView.image = self.shopInfoArray[indexPath.section][indexPath.row];
        }
        return cell;
    }else{
        BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
        if(cell==nil)
        {
            cell = [[BSEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infoCell"];
        }
        cell.titleLabel.text = self.infoTypeArray[indexPath.section][indexPath.row];
        cell.contentField.text = self.shopInfoArray[indexPath.section][indexPath.row];
        cell.contentField.enabled = YES;
        cell.contentField.delegate = self;
        cell.contentField.placeholder = @"";
        if((indexPath.section==FirstSection&&indexPath.row==ThirdRow)||(indexPath.section==SecondSection&&indexPath.row==ThirdRow)||(indexPath.section == ThirdSection&&indexPath.row==FirstRow))
        {
            cell.contentField.enabled = NO;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == FirstSection&&indexPath.row == FirstRow)
    {
        return 80;
    }else{
        return 50;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == FirstSection&&indexPath.row==FirstRow)
    {
        
    }else if (indexPath.section == FirstSection&&indexPath.row==ThirdRow)
    {
        BSCommonSelectedItemViewController *select = [[BSCommonSelectedItemViewController alloc]initWithNibName:NIBCT(@"BSCommonSelectedItemViewController") bundle:nil];
        select.dataArray = [[NSMutableArray alloc]initWithArray:@[@"加盟店",@"直营店"]];
        if([self.params objectForKey:@"type"]!=nil&&[[self.params objectForKey:@"type"] isEqualToString:@"加盟店"])
        {
            select.currentSelectIndex = 0;
        }else if([self.params objectForKey:@"type"]!=nil&&[[self.params objectForKey:@"type"] isEqualToString:@"直营店"])
        {
            select.currentSelectIndex = 1;
        }else{
            select.currentSelectIndex = -1;
        }
        select.userData = select.dataArray;
        select.delegate = self;
        
        [self.navigationController pushViewController:select animated:YES];
    }else if (indexPath.section==SecondSection&&indexPath.row==ThirdRow)
    {
        BSCommonSelectedItemViewController *select = [[BSCommonSelectedItemViewController alloc]initWithNibName:NIBCT(@"BSCommonSelectedItemViewController") bundle:nil];
        NSArray* storeList = [[BSCoreDataManager currentManager] fetchAllUser];
        NSMutableArray* storeNameList = [NSMutableArray array];
        for (CDUser* s in storeList )
        {
            [storeNameList addObject:s.name];
        }

        //if([self.params objectForKey:@""])
        select.dataArray = storeNameList;
        select.userData = select.dataArray;
        select.delegate = self;
        select.currentSelectIndex = -1;
        [self.navigationController pushViewController:select animated:YES];
    }else if (indexPath.section==ThirdSection&&indexPath.row==FirstRow)
    {
        BSCommonSelectedItemViewController *select = [[BSCommonSelectedItemViewController alloc]initWithNibName:NIBCT(@"BSCommonSelectedItemViewController") bundle:nil];
        //PersonalProfile *profile = [PersonalProfile currentProfile];
        //select.dataArray = profile.shopIds;
        //select.userData = select.dataArray;
        //select.delegate = self;
        select.currentSelectIndex = -1;
        [self.navigationController pushViewController:select animated:YES];
    }
    self.selectedIndexPath = indexPath;
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma rightBarButtonItem,
- (void)buttonClicked
{
    [self.tableView reloadData];
    BSCreateShopRequest *request = [[BSCreateShopRequest alloc]initWithParams:self.params];
    [request execute];
    NSUInteger index = [self.navigationController.viewControllers indexOfObject:self];
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2] animated:YES]
    ;
}

#pragma UITextFieldDelegate 

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(![textField.text isEqualToString:@""]&&textField.text !=nil)
    {
        BSEditCell *cell = (BSEditCell *)textField.superview.superview;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [self.params setObject:textField.text forKey:[self.keyValueDic objectForKey:self.infoTypeArray[indexPath.section][indexPath.row]]];
        [self.shopInfoArray[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:textField.text];
    }
    [self textFieldShouldReturn:textField];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma BSCommonSelectedItemViewControllerDelegate

-(void)didSelectItemAtIndex:(NSInteger)index userData:(id)userData
{
    [self.shopInfoArray[self.selectedIndexPath.section] replaceObjectAtIndex:self.selectedIndexPath.row withObject:userData[index]];
    [self.params setObject:[self.selectedList objectForKey:userData[index]] forKey:[self.keyValueDic objectForKey:self.infoTypeArray[self.selectedIndexPath.section][self.selectedIndexPath.row]]];
    [self.tableView reloadData];
}
@end
