//
//  StaffCreateJobViewController.m
//  Boss
//
//  Created by mac on 15/7/15.
//  Copyright (c) 2015年 BORN. All rights reserved.
//
#import "CBMessageView.h"
#import "BSCreateJobRequest.h"
#import "BSCommonSelectedItemViewController.h"
#import "BSEditCell.h"
#import "StaffCreateJobViewController.h"
#import "CBLoadingView.h"

typedef enum kSection
{
    kSection_one = 0,
    kSection_two,
    kSection_num
}kSection;

typedef enum section_one_row
{
    section_one_row_name = 0,
    section_one_row_department,
    section_one_row_currentcount,
    section_one_row_num
}section_one_row;

typedef enum section_two_row
{
    section_two_row_inspectcount = 0,
    section_two_row_num
}section_two_row;

@interface StaffCreateJobViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,BSCommonSelectedItemViewControllerDelegate>
{
    bool isFirstLoadView;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CDStaffJob *staffJob;

@end

@implementation StaffCreateJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR(242, 242, 242, 1.0);
    
    
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:@""];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    
    BNRightButtonItem *rightBtnItem = [[BNRightButtonItem alloc]initWithTitle:@"保存"];
    rightBtnItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    self.navigationItem.title = @"新建职位";
    
    self.hideKeyBoardWhenClickEmpty = true;
    self.params = [NSMutableDictionary dictionary];
    [self.params setObject:@0 forKey:@"no_of_employee"]; //默认当前员工数量为0
    
    self.staffJob = [[BSCoreDataManager currentManager] insertEntity:@"CDStaffJob"];

    
    isFirstLoadView = true;

    [self registerNofitificationForMainThread:kBSJobCreateResponse];
   
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
    BSCreateJobRequest *request = [[BSCreateJobRequest alloc] initWithStaffJob:self.staffJob params:self.params];
    [request execute];

}


#pragma mark - notification
-(void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if([notification.name isEqualToString:kBSJobCreateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
            {
                
                NSArray *jobsArray = [[BSCoreDataManager currentManager] fetchAllStaffJobs];
                
                NSMutableArray *nameArray = [[NSMutableArray alloc]init];
                for(CDStaffJob *job in jobsArray)
                {
                    [nameArray addObject:job.job_name];
                    
                }
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                [userInfo setObject:jobsArray forKey:@"userData"];
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
}


#pragma mark - pop controller
-(void)popController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kSection_num;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kSection_one) {
        return section_one_row_num;
    }
    else if (section == kSection_two)
    {
        return section_two_row_num;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    
    BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jobCell"];
    if(cell==nil)
    {
        cell = [[BSEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"jobCell"];
        cell.contentField.delegate = self;
    }
    cell.arrowImageView.hidden = false;
    cell.contentField.tag = indexPath.section * 100 + indexPath.row;
    if (section == kSection_one) {
        if (row == section_one_row_name) {
            cell.titleLabel.text = @"岗位名称";
            cell.contentField.placeholder = @"请输入";
            cell.contentField.enabled = true;
            cell.contentField.text = self.staffJob.job_name;
        }
        else if (row == section_one_row_department)
        {
            cell.titleLabel.text = @"部门";
            cell.contentField.placeholder = @"请选择";
            cell.contentField.enabled = false;
            cell.contentField.text = self.staffJob.department.department_name;
        }
        else if (row == section_one_row_currentcount)
        {
            cell.titleLabel.text = @"当前员工数量";
            cell.contentField.placeholder = @"请选择";
            cell.contentField.enabled = false;
            cell.contentField.text = @"0";//为0 不可更改
            
            cell.arrowImageView.hidden = true;
        }
    }
    else if (section == kSection_two)
    {
        if (row == section_two_row_inspectcount) {
            cell.titleLabel.text = @"期望员工数量";
            cell.contentField.placeholder = @"请输入";
            cell.contentField.enabled = true;
            if (self.staffJob.inspectCount) {
                 cell.contentField.text = [NSString stringWithFormat:@"%@",self.staffJob.inspectCount];
            }
        }
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
    if(section==0)
    {
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        return label;
    }else
    {
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.selectedIndexPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == kSection_one && indexPath.row == section_one_row_department)
    {
        NSInteger currentSelectedIndex = -1;
        NSArray *departmentsArray = [[BSCoreDataManager currentManager] fetchAllStaffDepartments];
        NSMutableArray *nameArray = [[NSMutableArray alloc]init];
        for(CDStaffDepartment *department in departmentsArray)
        {
            if ([self.staffJob.department.department_id integerValue] == [department.department_id integerValue]) {
                currentSelectedIndex = [departmentsArray indexOfObject:department];
            }
            [nameArray addObject:department.department_name];
        }
        BSCommonSelectedItemViewController *selectedView = [[BSCommonSelectedItemViewController alloc]initWithNibName:NIBCT(@"BSCommonSelectedItemViewController") bundle:nil];
        selectedView.dataArray = nameArray;
        selectedView.currentSelectIndex = currentSelectedIndex;
        selectedView.delegate = self;
        selectedView.userData = departmentsArray;
        [self.navigationController pushViewController:selectedView animated:YES];
    }

}

#pragma UITextFieldDelegate 
#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger section = textField.tag / 100;
    NSInteger row = textField.tag % 100;
   
    if (section == kSection_one && row == section_one_row_name) {
        [self.params setObject:textField.text forKey:@"name"];
        self.staffJob.job_name = textField.text;
    }
    else if (section == kSection_two && row == section_two_row_inspectcount)
    {
        self.staffJob.inspectCount = [NSNumber numberWithInteger:[textField.text integerValue]];
        [self.params setObject:self.staffJob.inspectCount forKey:@"no_of_recruitment"];
    }
    
}


#pragma mark - BSCommonSelectedItemViewController

-(void)didSelectItemAtIndex:(NSInteger)index userData:(id)userData
{
    BSEditCell *cell = (BSEditCell *)[self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
    
    NSInteger row = self.selectedIndexPath.row;
    if (row == section_one_row_department) {
        NSArray *departments = userData;
        CDStaffDepartment *department = [departments objectAtIndex:index];
        self.staffJob.department = department;
        [self.params setObject:department.department_id forKey:@"department_id"];
        cell.contentField.text = department.department_name;
    }
}


@end
