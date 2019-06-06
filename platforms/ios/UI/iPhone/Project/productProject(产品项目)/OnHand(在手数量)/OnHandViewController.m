//
//  OnHandViewController.m
//  ds
//
//  Created by lining on 2016/11/16.
//
//

#import "OnHandViewController.h"
#import "PosOperateBtnCell.h"
#import "ItemArrowCell.h"
#import "TextFieldCell.h"
#import "BSSelectedView.h"
#import "BSFetchStorageRequest.h"
#import "ProductOnHandReqeust.h"
#import "CBMessageView.h"
#import "CBLoadingView.h"


typedef enum kItemRow
{
    kItemRowProduct,
    kItemRowLoction,
    kItemRowCount,
    kItemRowBtn,
    kItemRowNum
}kTemplateListItemRow;

@interface OnHandViewController ()<UITextFieldDelegate,BtnCellDelegate,BSSelectedViewDelegate>
@property (nonatomic, strong) BSSelectedView *productSelectedView;
@property (nonatomic, strong) BSSelectedView *locationSelectedView;
@property (nonatomic, strong) NSArray *locations;
@property (nonatomic, strong) NSMutableArray *loactionNames;

@property (nonatomic, strong) NSArray *projectItems;

@property (nonatomic, strong) CDStorage *location;
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) NSIndexPath *currentSelectedIndexPath;

@end

@implementation OnHandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *backItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    backItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.navigationItem.title = @"在手数量";
    
    [self initView];
    
    BSFetchStorageRequest *reqeust = [BSFetchStorageRequest alloc];
    reqeust.storeId = [PersonalProfile currentProfile].bshopId;
    [reqeust execute];
    
    [self registerNofitificationForMainThread:kBSFetchStorageRequest];
    [self registerNofitificationForMainThread:kBSProductOnHandResponse];
}

- (void)initView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemArrowCell" bundle:nil] forCellReuseIdentifier:@"ItemArrowCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextFieldCell" bundle:nil] forCellReuseIdentifier:@"TextFieldCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PosOperateBtnCell" bundle:nil] forCellReuseIdentifier:@"PosOperateBtnCell"];
    
    UIView *view = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, 20.0)];
    view.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = view;
    self.tableView.tableFooterView = view;
    
    if (self.projectTemplate) {
        self.productSelectedView = [BSSelectedView createViewWithTitle:@"选择产品"];
        self.productSelectedView.tag = 101;
        self.productSelectedView.delegate = self;
        [self reloadProductView];
    }
    
    self.locationSelectedView = [BSSelectedView createViewWithTitle:@"选择库位"];
    self.locationSelectedView.tag = 102;
    self.locationSelectedView.delegate = self;
    [self reloadProductView];
}

- (void)reloadProductView
{
    NSMutableArray *productNames = [NSMutableArray array];
    if (self.projectItem == nil) {
        self.projectItem = [self.projectTemplate.projectItems objectAtIndex:0];
    }
    for (CDProjectItem *item in self.projectTemplate.projectItems) {
        [productNames addObject:item.itemName];
        if (self.projectItem.itemID.integerValue == item.itemID.integerValue) {
            self.productSelectedView.currentSelectedIdx = [self.projectItems indexOfObject:item];
            
        }
        
    }
    self.productSelectedView.stringArray = productNames;
}

- (void)reloadLoactionView
{
    self.loactionNames = [NSMutableArray array];
    self.locations = [[BSCoreDataManager currentManager] fetchAllStoreages];
    if (self.location == nil && self.locations.count > 0) {
        self.location = [self.locations firstObject];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kItemRowLoction inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    for (CDStorage *storage in self.locations) {
        [self.loactionNames addObject:storage.displayName];
        if (self.location.storage_id.integerValue == storage.storage_id.integerValue) {
            self.locationSelectedView.currentSelectedIdx = [self.locations indexOfObject:storage];
            
        }
    }
    self.locationSelectedView.stringArray = self.loactionNames;
}

- (void)setProjectItem:(CDProjectItem *)projectItem
{
    _projectItem = projectItem;
    self.count = projectItem.inHandAmount.integerValue;
}

#pragma mark - ReceivedNotification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchStorageRequest]) {
        [self reloadLoactionView];
    }
    else if ([notification.name isEqualToString:kBSProductOnHandResponse])
    {
        NSNumber *ret = [notification.userInfo numberValueForKey:@"rc"];
        if (ret.integerValue == 0) {
            [self.navigationController popViewControllerAnimated:YES];
            [[[CBMessageView alloc] initWithTitle:@"更新成功"] show];
        }
        else
        {
            [[[CBMessageView alloc] initWithTitle:[notification.userInfo stringValueForKey:@"rc"]] show];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kItemRowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == kItemRowProduct) {
        ItemArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemArrowCell"];
        cell.nameLabel.text = @"产品名称";
        cell.valueLabel.text = self.projectItem.itemName;
        return cell;
    }
    else if (indexPath.row == kItemRowLoction)
    {
        ItemArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemArrowCell"];
        cell.nameLabel.text = @"库位";
        
        cell.valueLabel.text = self.location.displayName;

        return cell;
    }
    else if (indexPath.row == kItemRowCount)
    {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
        cell.valueTextFiled.delegate = self;
        cell.valueTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        cell.valueTextFiled.tag = 1000 *indexPath.section + indexPath.row;
        cell.titleLabel.text = @"在手数量";
        cell.titleLabel.textColor = [UIColor blackColor];
        cell.titleLabel.font = [UIFont systemFontOfSize:15];
        cell.valueTextFiled.textColor = [UIColor grayColor];
        cell.lineImgView.hidden = true;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.valueTextFiled.placeholder = @"请输入";
        cell.valueTextFiled.text = [NSString stringWithFormat:@"%d",self.count];
        return cell;
    }
    else if (indexPath.row == kItemRowBtn)
    {
        PosOperateBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PosOperateBtnCell"];
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == kItemRowBtn) {
        return 90;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger row = indexPath.row;
    
    if (row == kItemRowProduct) {
        if (self.projectTemplate) {
            [self.productSelectedView show];
        }
    }
    else if (row == kItemRowLoction)
    {
        [self.locationSelectedView show];
    }
    
    self.currentSelectedIndexPath = indexPath;
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger row = textField.tag % 1000;
    if (row == kItemRowCount) {
        NSInteger count = textField.text.integerValue;
        self.count = count;
    }
}


#pragma mark - BSSelectedViewDelegate
- (void)didSelectedAtIndex:(NSInteger)index
{
    if (self.currentSelectedIndexPath.row == kItemRowLoction) {
        self.location = [self.locations objectAtIndex:index];
        
    }
    else if (self.currentSelectedIndexPath.row == kItemRowProduct)
    {
        self.projectItem = [self.projectTemplate.projectItems objectAtIndex:index];
        
    }
    [self.tableView reloadRowsAtIndexPaths:@[self.currentSelectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}

#pragma mark - BtnCellDelegate
- (void)didBtnPressed
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.location == nil) {
        [[[CBMessageView alloc] initWithTitle:@"库位不能为空"] show];
        return;
    }
    params[@"product_id"] = self.projectItem.itemID;
    params[@"new_quantity"] = @(self.count);
    params[@"location_id"] = self.location.storage_id;
    
    ProductOnHandReqeust *request = [[ProductOnHandReqeust alloc] initWithParams:params];
    [request execute];
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
