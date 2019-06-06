//
//  StaffCreateDepartmentViewController.m
//  Boss
//
//  Created by mac on 15/7/14.
//  Copyright (c) 2015年 BORN. All rights reserved.
//
#import "StaffDetailViewController.h"
#import "CBMessageView.h"
#import "BSCreateDepartmentRequest.h"
#import "BSCommonSelectedItemViewController.h"
#import "BSEditCell.h"
#import "StaffCreateDepartmentViewController.h"
#import "CBLoadingView.h"


typedef enum kSection
{
    kSection_one = 0,
    kSection_num
}kSection;

typedef enum section_one_row
{
    section_one_row_name = 0,
    section_one_row_parent,
    section_one_row_manager,
    section_one_row_num
}section_one_row;

@interface StaffCreateDepartmentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,BSCommonSelectedItemViewControllerDelegate>
{
    bool isFirstLoadView;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CDStaffDepartment *department;
@end

@implementation StaffCreateDepartmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR(242, 242, 242, 1.0);
   
    
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    
    BNRightButtonItem *rightBtnItem = [[BNRightButtonItem alloc]initWithTitle:@"保存"];
    rightBtnItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    self.navigationItem.title = @"新建部门";
    
    self.hideKeyBoardWhenClickEmpty = true;
    self.params = [NSMutableDictionary dictionary];
    self.department = [[BSCoreDataManager currentManager] insertEntity:@"CDStaffDepartment"];

    isFirstLoadView = true;
    [self registerNofitificationForMainThread:kBSDepartmentCreateResponse];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (isFirstLoadView) {
        [self initTableView];
    }
    isFirstLoadView = false;
    NSLog(@"%s",__FUNCTION__);
    
}

#pragma mark - initView
- (void) initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    //    self.tableView.bounces = false;
    self.tableView.autoresizingMask = 0xff;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
}


#pragma mark - left & right navigationItem action
-(void)didItemBackButtonPressed:(UIButton*)sender
{
    [[BSCoreDataManager currentManager] rollback];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didRightBarButtonItemClick:(id)sender
{
    [[CBLoadingView shareLoadingView] show];
    BSCreateDepartmentRequest *request = [[BSCreateDepartmentRequest alloc]initWithDepartment:self.department params:self.params];
    [request execute];
}

-(void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if([notification.name isEqualToString:kBSDepartmentCreateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {

            NSArray *departmentArray = [[BSCoreDataManager currentManager] fetchAllStaffDepartments];
            
            NSMutableArray *nameArray = [[NSMutableArray alloc]init];
            for(CDStaffDepartment *department in departmentArray)
            {
                [nameArray addObject:department.department_name];
                
            }
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:departmentArray forKey:@"userData"];
            [userInfo setObject:nameArray forKey:@"dataArray"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kBSCommomSelectedDataChanged object:nil userInfo:userInfo] ;
            CBMessageView *view = [[CBMessageView alloc]initWithTitle:@"添加成功" afterTimeHide:0.75];
            [view showInView:self.view];

            [self performSelector:@selector(popController) withObject:nil afterDelay:0.75];
        
        }
        else
        {
            CBMessageView *view = [[CBMessageView alloc]initWithTitle:@"添加失败" afterTimeHide:0.75];
            [view showInView:self.view];
        }
    }
}


#pragma mark - pop controller
-(void)popController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  section_one_row_num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"departmentCell"];
    if(cell==nil)
    {
        cell = [[BSEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"departmentCell"];
        cell.contentField.delegate = self;
    }
    cell.contentField.tag = indexPath.section * 100 + indexPath.row;
    if(indexPath.row == section_one_row_name)
    {
        cell.titleLabel.text = @"部门名称";
        cell.contentField.placeholder = @"请输入";
        cell.contentField.enabled = true;
        cell.contentField.text = self.department.department_name;
    }
    else if (indexPath.row == section_one_row_parent)
    {
        cell.titleLabel.text = @"父级部门";
        cell.contentField.placeholder = @"请选择";
        cell.contentField.enabled = false;
        cell.contentField.text = self.department.parentDepartment.department_name;
    }
    else if (indexPath.row == section_one_row_manager)
    {
        cell.titleLabel.text = @"部门经理";
        cell.contentField.placeholder = @"请选择";
        cell.contentField.enabled = false;
        cell.contentField.text = self.department.manager.name;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.selectedIndexPath = indexPath;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == section_one_row_parent)
    {
        NSInteger currentSelectedIndex = -1;
        BSCommonSelectedItemViewController *selectVC = [[BSCommonSelectedItemViewController alloc]initWithNibName:NIBCT(@"BSCommonSelectedItemViewController") bundle:nil];
        
        NSArray *departmentArray = [[BSCoreDataManager currentManager] fetchAllStaffDepartments];
        
        NSMutableArray *nameArray = [[NSMutableArray alloc]init];
        for(CDStaffDepartment *department in departmentArray)
        {
            if ([department.department_id integerValue] > 0) //防止我们本地自己新建空的部门被加进来
            {
                if ([department.department_id integerValue] == [self.department.parentDepartment.department_id integerValue]) {
                    currentSelectedIndex = [departmentArray indexOfObject:department];
                }
                [nameArray addObject:department.department_name];

            }
        }
        selectVC.delegate = self;
        selectVC.hasAddButton = YES;
        selectVC.title = @"上级部门";
        selectVC.dataArray = nameArray;
        selectVC.userData = departmentArray;
        selectVC.currentSelectIndex = currentSelectedIndex;
        [self.navigationController pushViewController:selectVC animated:YES];
        
    }
    else if (indexPath.row == section_one_row_manager)
    {
        NSInteger currentSelectedIndex = -1;
        BSCommonSelectedItemViewController *selectVC = [[BSCommonSelectedItemViewController alloc]initWithNibName:NIBCT(@"BSCommonSelectedItemViewController") bundle:nil];
        NSArray *staffArray = [[BSCoreDataManager currentManager] fetchAllStaffs];
        NSMutableArray *nameArray = [[NSMutableArray alloc]init];
        for(CDStaff *staff in staffArray)
        {
            if ([staff.staffID integerValue] > 0)//防止我们本地自己新建空的员工被加进来

            {
                if ([staff.staffID integerValue] == [self.department.manager.staffID integerValue]) {
                    currentSelectedIndex = [staffArray indexOfObject:staff];
                }
                [nameArray addObject:staff.name];
            }
        }
        selectVC.title = @"员工";
        selectVC.delegate = self;
//        selectVC.hasAddButton = YES;
        selectVC.dataArray = nameArray;
        selectVC.userData = staffArray;
        selectVC.currentSelectIndex = currentSelectedIndex;
        [self.navigationController pushViewController:selectVC animated:YES];
    }

}



#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger row = textField.tag % 100;
    if (row == section_one_row_name) {
        [self.params setObject:textField.text forKey:@"name"];
        self.department.department_name = textField.text;
    }
    
}

#pragma mark - BSCommonSelectItemViewControllerDelegate
-(void)didSelectItemAtIndex:(NSInteger)index userData:(id)userData
{
    BSEditCell *cell = (BSEditCell *)[self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
    
    NSInteger row = self.selectedIndexPath.row;
    if (row == section_one_row_parent) {
        NSArray *departments = userData;
        CDStaffDepartment *department = [departments objectAtIndex:index];
        self.department.parentDepartment = department;
        [self.params setObject:department.department_id forKey:@"parent_id"];
        cell.contentField.text = department.department_name;
    }
    else if (row == section_one_row_manager)
    {
        NSArray *staffs = userData;
        CDStaff *manager = [staffs objectAtIndex:index];
        self.department.manager = manager;
        [self.params setObject:manager.staffID forKey:@"manager_id"];
        cell.contentField.text = manager.name;
    }
}

-(void)didAddButtonPressed:(id)userData
{
    if(self.selectedIndexPath.row == section_one_row_parent)
    {
        StaffCreateDepartmentViewController *department = [[StaffCreateDepartmentViewController alloc]initWithNibName:NIBCT(@"StaffCreateDepartmentViewController") bundle:nil];
        [self.navigationController pushViewController:department animated:YES];
    }else if (self.selectedIndexPath.row == section_one_row_manager)
    {
        StaffDetailViewController *staffDetail = [[StaffDetailViewController alloc]initWithNibName:NIBCT(@"StaffDetailViewController") bundle:nil];
        staffDetail.type = StaffDetailType_create;
        [self.navigationController pushViewController:staffDetail animated:YES];
    }
}
@end
