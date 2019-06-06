//
//  YimeiSignBeforeOperationViewController.m
//  ds
//
//  Created by jimmy on 16/10/27.
//
//

#import "YimeiSignBeforeOperationViewController.h"
#import "YimeiSignBeforeTitleTableViewCell.h"
#import "YImeiSignBeforePriceTableViewCell.h"
#import "YImeiSignBeforeSignTableViewCell.h"
#import "BSFetchPosProductRequest.h"
#import "VLabel.h"
#import "UploadPicToZimg.h"
#import "MBProgressHUD.h"
#import "BSYimeiEditPosOperateRequest.h"
#import "UIImage+Scale.h"
#import "YimeiAgreememtViewController.h"
#import "FetchYimeiMedicalProvisionRequest.h"
#import "YimeiAddRemarksViewController.h"
#import "BSCreateAuthorizationRequest.h"

typedef enum YimeiSignBeforeOperation
{
    YimeiSignBeforeOperation_Title,
    YimeiSignBeforeOperation_Sign,
    YimeiSignBeforeOperation_Count,
    YimeiSignBeforeOperation_Price,
}YimeiSignBeforeOperation;

@interface YimeiSignBeforeOperationViewController ()<VLabelDelegate, YimeiAddRemarksViewControllerDelegate>
@property(nonatomic, weak)IBOutlet UITableView* tableView;
@property(nonatomic, weak)IBOutlet UIButton* confirmButton;
@property(nonatomic, weak)IBOutlet UIButton* checkedButton;
@property(nonatomic, weak)IBOutlet VLabel* confirmDetailLabel;
@property(nonatomic, strong)NSString* provisionString;
@property(nonatomic, strong)NSString* promiseString;
@property(nonatomic, strong)NSString* authorizationString;
@end

@implementation YimeiSignBeforeOperationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self forbidSwipGesture];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YimeiSignBeforeTitleTableViewCell" bundle:nil] forCellReuseIdentifier:@"YimeiSignBeforeTitleTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"YImeiSignBeforePriceTableViewCell" bundle:nil] forCellReuseIdentifier:@"YImeiSignBeforePriceTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"YImeiSignBeforeSignTableViewCell" bundle:nil] forCellReuseIdentifier:@"YImeiSignBeforeSignTableViewCell"];
    
    self.confirmDetailLabel.delegate = self;
    //[[[BSFetchPosProductRequest alloc] initWithPosOperate:self.operate] execute];
    [self registerNofitificationForMainThread:kEidtPosOperateResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberOperateResponse];
    //[self registerNofitificationForMainThread:kFetchYimeiMedicalProvisionResponse];
    //[self registerNofitificationForMainThread:kFetchPosOperateProductResponse];
    [self registerNofitificationForMainThread:kBSCreateAuthorizationResponse];
    
    self.provisionString = [PersonalProfile currentProfile].provisionString;
    self.promiseString = [PersonalProfile currentProfile].promiseString;
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ( [notification.name isEqualToString:kEidtPosOperateResponse] )
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            if ( self.YimeiSignBeforeOperationViewControllerFinished )
            {
                self.YimeiSignBeforeOperationViewControllerFinished();
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        else
        {
            self.operate.yimei_sign_before = @"";
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSString *message = [notification.userInfo stringValueForKey:@"rm"];
            if(message.length != 0)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:message
                                                                   delegate:nil
                                                          cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    }
    else if ( [notification.name isEqualToString:kBSFetchMemberOperateResponse] )
    {
//        FetchYimeiMedicalProvisionRequest* request = [[FetchYimeiMedicalProvisionRequest alloc] init];
//        request.provisionID = self.operate.yimei_provision_id;
//        [request execute];
    }
    else if ( [notification.name isEqualToString:kFetchYimeiMedicalProvisionResponse] )
    {
        //NSDictionary* params = notification.userInfo[@"info"];
        //self.provisionString = params[@"provision"];
        //self.promiseString = params[@"promise"];
        
        [self.tableView reloadData];
    }
    else if ( [notification.name isEqualToString:kFetchPosOperateProductResponse] )
    {
        [self.tableView reloadData];
    }
    else if ( [notification.name isEqualToString:kBSCreateAuthorizationResponse] )
    {
        [self editPosOperate:notification.userInfo[@"userInfo"]];
    }
}

- (void)vLabel:(VLabel *)vLabel touchesWtihTag:(NSInteger)tag
{
    YimeiAgreememtViewController* vc = [[YimeiAgreememtViewController alloc] initWithNibName:@"YimeiAgreememtViewController" bundle:nil];
    vc.promise = self.promiseString;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == YimeiSignBeforeOperation_Title )
    {
        return 391;
    }
    else if ( indexPath.row == YimeiSignBeforeOperation_Price )
    {
        return 80;
    }
    else if ( indexPath.row == YimeiSignBeforeOperation_Sign )
    {
        return 240;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return YimeiSignBeforeOperation_Count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == YimeiSignBeforeOperation_Title )
    {
        return [self tableView:tableView cellForTitleRowAtIndexPath:indexPath];
    }
    else if ( indexPath.row == YimeiSignBeforeOperation_Price )
    {
        return [self tableView:tableView cellForPriceRowAtIndexPath:indexPath];
    }
    else if ( indexPath.row == YimeiSignBeforeOperation_Sign )
    {
        return [self tableView:tableView cellForSignRowAtIndexPath:indexPath];
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForTitleRowAtIndexPath:(NSIndexPath *)indexPath
{
    YimeiSignBeforeTitleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"YimeiSignBeforeTitleTableViewCell"];
    cell.operate = self.operate;
    cell.provision = self.provisionString;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForPriceRowAtIndexPath:(NSIndexPath *)indexPath
{
    YImeiSignBeforePriceTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"YImeiSignBeforePriceTableViewCell"];
    cell.operate = self.operate;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSignRowAtIndexPath:(NSIndexPath *)indexPath
{
    YImeiSignBeforeSignTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"YImeiSignBeforeSignTableViewCell"];
    cell.operate = self.operate;
    
    return cell;
}

- (IBAction)didCloseButtonPressed:(id)sender
{
    YimeiAddRemarksViewController* vc = [[YimeiAddRemarksViewController alloc] initWithNibName:@"YimeiAddRemarksViewController" bundle:nil];
    vc.remark = self.authorizationString;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didYimeiAddRemarksViewControllerFinsish:(NSString*)remark
{
    self.authorizationString = remark;
}

- (IBAction)didCheckedButtonPressed:(id)sender
{
    self.checkedButton.selected = !self.checkedButton.selected;
}

- (IBAction)didConfirmButtonPressed:(id)sender
{
    if ( !self.checkedButton.selected )
    {
        UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"请先同意知情书" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [v show];
    }
    else
    {
        YImeiSignBeforeSignTableViewCell* cell = (YImeiSignBeforeSignTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:YimeiSignBeforeOperation_Sign inSection:0]];
        
        if ( !cell.drawView.savedImage )
        {
            UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"请先签名" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [v show];
            return;
        }
        
        if ( self.authorizationString.length > 0 )
        {
            BSCreateAuthorizationRequest* request = [[BSCreateAuthorizationRequest alloc] initWithParams:@{@"name":self.authorizationString,@"type":@"price",@"user_id":[PersonalProfile currentProfile].userID}];
            [request execute];
        }
        else
        {
            [self editPosOperate:nil];
        }
    }
}

- (void)editPosOperate:(NSNumber*)authorization_id
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    CGFloat imageDestWidth = imageWidth;
    CGFloat imageDestHeight = imageHeight;
    if (imageWidth > 320)
    {
        imageDestWidth = 320;
        imageDestHeight = (imageDestWidth) * imageHeight / imageWidth;
    }
    
    UIImage* compressedImage = [image scaleToSize:CGSizeMake(imageDestWidth, imageDestHeight)];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.label.text = @"正在上传签名 请稍后...";
    
    UploadPicToZimg* v = [UploadPicToZimg alloc];
    [v uploadPic:compressedImage finished:^(BOOL ret, NSString *urlString)
     {
         if ( ret )
         {
             NSMutableDictionary* params = [NSMutableDictionary dictionary];
             params[@"before_sign_image_url"] = urlString;
             if ( [authorization_id integerValue] > 0 )
             {
                 params[@"authorization_id"] = authorization_id;
             }
             
             BSYimeiEditPosOperateRequest* request = [[BSYimeiEditPosOperateRequest alloc] initWithPosOperate:self.operate params:params];
             self.operate.yimei_sign_before = urlString;
             [request execute];
         }
         else
         {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                 message:@"图片上传失败,请稍后再试"
                                                                delegate:nil
                                                       cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                       otherButtonTitles:nil, nil];
             [alertView show];
             
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         }
     }];
}

@end
