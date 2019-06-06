//
//  CreateProviderViewController.m
//  Boss
//
//  Created by lining on 15/6/23.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "CreateProviderViewController.h"
#import "BSEditCell.h"
#import "BSCoreDataManager.h"
#import "BSCreateProviderRequest.h"
#import "CBMessageView.h"
#import "CBLoadingView.h"
#import "BSImagePickerManager.h"


#define kPicCellHeight  90
#define kMarginSize  16
#define kLogoSize   40

@interface CreateProviderViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,BSImagePickerManagerDelegate>
{
    BOOL isFirstLoadView;
}

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic, strong) CDProvider *provider;
@property(nonatomic, strong) NSMutableDictionary *filterDict;

@end

@implementation CreateProviderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR(245, 245, 245, 1);
    CBBackButtonItem *buttonItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    buttonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = buttonItem;
    self.navigationItem.title = @"新建供应商";
    isFirstLoadView = true;
//    self.hideKeyBoardWhenClickEmpty = true;
    self.filterDict = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithBool:true] forKey:@"supplier"];
    [self initData];
    
    [self registerNofitificationForMainThread:kBSCreateProviderResponse];
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithTitle:@"完成"];
    rightButtonItem.delegate = self;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (isFirstLoadView) {
        [self initView];
        isFirstLoadView = false;
    }
}
#pragma mark - init view & data
- (void)initView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    //    self.tableView.bounces = false;
    self.tableView.autoresizingMask = 0xff;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
}

- (void) initData
{
    BSCoreDataManager *dataManager = [BSCoreDataManager currentManager];
    self.provider = [dataManager insertEntity:@"CDProvider"];
    
}

#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - CBBackButtonItemDelegate
-(void)didItemBackButtonPressed:(UIButton*)sender
{
    [[BSCoreDataManager currentManager] deleteObject:self.provider];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - BNRightButtonItemDelegate
- (void)didRightBarButtonItemClick:(id)sender
{
    NSLog(@"right button pressed");
    [[UIApplication sharedApplication].keyWindow endEditing:true];
    BSCreateProviderRequest *request = [[BSCreateProviderRequest alloc] initWithProvider:self.provider params:self.filterDict];
    [request execute];
    [[CBLoadingView shareLoadingView] show];
   
    
}


#pragma mark - Received Notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    NSDictionary *retDict = notification.userInfo;
    [[CBLoadingView shareLoadingView] hide];
    if ([notification.name isEqualToString:kBSCreateProviderResponse]) {
        if ([[retDict numberValueForKey:@"rc"] integerValue] == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSString *msg = [retDict stringValueForKey:@"rm"];
            CBMessageView *msgView = [[CBMessageView alloc] initWithTitle:msg];
            [msgView show];
        }
    }
}


#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ProviderSection_num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == ProviderSection_one) {
        return SectionRowOne_num;
    }
    else
    {
        return SectionRowTwo_num;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == ProviderSection_one && row == SectionRowOne_pic) {
        static NSString *pic_identifier = @"pic_identifier";
        UITableViewCell *picCell = [tableView dequeueReusableCellWithIdentifier:pic_identifier];
        if (picCell == nil) {
            picCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pic_identifier];
//            picCell.backgroundColor = [UIColor clearColor];
            UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0, IC_SCREEN_WIDTH, 0.5)];
            topLine.backgroundColor = [UIColor clearColor];
//            topLine.tag = 100;
            topLine.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
            [picCell.contentView addSubview:topLine];
            
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kMarginSize, (kPicCellHeight - 20)/2.0, 100, 20)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont boldSystemFontOfSize:16.0];
            label.textColor = COLOR(72.0, 72.0, 72.0, 1.0);
            label.text = @"头像";
            [picCell.contentView addSubview:label];
            
            
            UIImage *arrowImage = [UIImage imageNamed:@"project_item_arrow"];
            
            UIImageView *logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width - 15 - arrowImage.size.width-kLogoSize, (kPicCellHeight - kLogoSize)/2.0, kLogoSize, kLogoSize)];
            logoImgView.image = [UIImage imageNamed:@"order_provider_logo.png"];
            logoImgView.tag = 101;
            logoImgView.layer.cornerRadius = kLogoSize/2.0;
            logoImgView.layer.masksToBounds = YES;
            [picCell.contentView addSubview:logoImgView];
            
            
            UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, kPicCellHeight - 0.5, IC_SCREEN_WIDTH, 0.5)];
            bottomLine.backgroundColor = [UIColor clearColor];
            //            topLine.tag = 100;
            bottomLine.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
            [picCell.contentView addSubview:bottomLine];
           
        }
//        UIImageView *logoImgView = [picCell.contentView viewWithTag:101];
        
        return picCell;
    }
    else
    {
        static NSString *indentifier = @"common_identifier";
        BSEditCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (cell == nil) {
            cell = [[BSEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            cell.contentField.delegate = self;
            
            UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0, IC_SCREEN_WIDTH, 0.5)];
            topLine.backgroundColor = [UIColor clearColor];
            topLine.tag = 10001;
            topLine.image = [UIImage imageNamed:@"bs_table_view_cell_line"];
            [cell.contentView addSubview:topLine];
        }
        cell.contentField.tag = 100 * section + row;
        UIImageView *topLine = (UIImageView *)[cell.contentView viewWithTag:10001];
        topLine.hidden = YES;
        cell.contentField.enabled = true;
        cell.contentField.textColor = [UIColor grayColor];
        cell.contentField.placeholder = @"请输入...";
        cell.arrowImageView.hidden = NO;
        if (row == 0) {
            topLine.hidden = NO;
        }
        if (section == ProviderSection_one) {
            if (row == SectionRowOne_name) {
                cell.titleLabel.text = @"供应商名称";
                cell.contentField.text = self.provider.name;
            }
            else if (row == SectionRowOne_contact)
            {
                cell.titleLabel.text = @"联系人";
                cell.contentField.text = self.provider.contact;
            }
            else if (row == SectionRowOne_telePhone)
            {
                cell.titleLabel.text = @"电话";
                cell.contentField.text = self.provider.telephone;
            }

        }
        else if (section == ProviderSection_two)
        {
            if (row == SectionRowTwo_fax) {
                cell.titleLabel.text = @"传真";
                cell.contentField.text = self.provider.fax;
            }
            else if (row == SectionRowTwo_website)
            {
                cell.titleLabel.text = @"网址";
                cell.contentField.text = self.provider.website;
            }
            else if (row == SectionRowTwo_area)
            {
                cell.titleLabel.text = @"地区";
                cell.contentField.text = self.provider.address;
            }

        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == ProviderSection_one && row == SectionRowOne_pic) {
        return kPicCellHeight;
    }
    else
    {
        return 50.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //    return kSearchBarHeight;
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    CDProvider *provider = [self.dataArray objectAtIndex:indexPath.row];
    if (indexPath.row == SectionRowOne_pic && indexPath.section == ProviderSection_one) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从照片库选取", nil];
        [actionSheet showInView:self.view];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"clicked at index: %d",buttonIndex);
    if (buttonIndex == 2) {
        return;
    }
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (buttonIndex == 0) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    [[BSImagePickerManager shareManager] startImagePickerWithType:sourceType delegate:self allowEdit:true];
}

#pragma mark - BSImagePickerManagerDelegate
-(void)didSelectedImage:(UIImage *)image
{
    NSLog(@"didSelected");
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:SectionRowOne_pic inSection:ProviderSection_one]];
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:101];
    imgView.image = image;
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
    
//    self.filterDict[@"image"] = [[NSString alloc] initWithData:imageData encoding:NSUTF8StringEncoding];
    self.filterDict[@"image"] = [imageData base64Encoding];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    int section = textField.tag / 100;
    int row = textField.tag % 100;
    if (section == ProviderSection_one) {
        if (row == SectionRowOne_name) {
            self.provider.name = textField.text;
            self.filterDict[@"name"] = self.provider.name;
        }
        else if (row == SectionRowOne_contact)
        {
            self.provider.contact = textField.text;
//            [self.filterDict setObject:self.provider.contact forKey:@""] //OE无这个字段
        }
        else if (row == SectionRowOne_telePhone)
        {
            self.provider.telephone = textField.text;
            self.filterDict[@"mobile"] = self.provider.telephone;
        }
    }
    else if (section == ProviderSection_two)
    {
        if (row == SectionRowTwo_fax) {
            self.provider.fax = textField.text;
            self.filterDict[@"fax"] = self.provider.fax;
        }
        else if (row == SectionRowTwo_website)
        {
            self.provider.website = textField.text;
            self.filterDict[@"website"] = self.provider.website;
        }
        else if (row == SectionRowTwo_area)
        {
            self.provider.address = textField.text;
            self.filterDict[@"street"] = self.provider.address;
        }
    }
    NSLog(@"----");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return true;
}

@end
