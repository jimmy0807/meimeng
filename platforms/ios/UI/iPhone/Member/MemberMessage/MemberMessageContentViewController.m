//
//  MemberMessageContentViewController.m
//  Boss
//
//  Created by lining on 16/5/27.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberMessageContentViewController.h"
#import "MessageContentCell.h"
#import "MessageInputCell.h"
#import "UILabel+LineSpace.h"
#import "BSSendMessageRequest.h"
#import "CBMessageView.h"
#import "CBLoadingView.h"
#import "BSMessageNavigationController.h"
#import "UILabel+LineSpace.h"
#import "NSArray+JSON.h"
#import "MemberMessageViewController.h"
#import "MemberFunctionViewController.h"

#define SYMBOL_START    @"{"
#define SYMBOL_END      @"}"

@interface MemberMessageContentViewController ()<MFMessageComposeViewControllerDelegate>
{
    NSInteger needInputCount;
}
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) MessageContentCell *cell;
@property (nonatomic, strong) NSMutableDictionary *valueDict;
@property (nonatomic, strong) NSArray *descs;
@end

@implementation MemberMessageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *leftBtnItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftBtnItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    self.navigationItem.title = @"编辑短信模板";
    
    self.hideKeyBoardWhenClickEmpty = true;
    
    self.items = [NSMutableArray array];
    [self seperateMessageString:self.messageTmplate.template_content];
    
    self.descs = [NSArray arrayWithJSONData:[self.messageTmplate.descs dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    self.valueDict = [NSMutableDictionary dictionary];
    
    needInputCount = 0;
    
    self.cell = [MessageContentCell createCell];
    self.cell.contentLabel.preferredMaxLayoutWidth = IC_SCREEN_WIDTH - 30;
    
    [self registerNofitificationForMainThread:kBSMemberQufaMessageResponse];
}

#pragma mark - initData
- (void)seperateMessageString:(NSString *)message
{
    MessageItem *item;
    NSRange range = [message rangeOfString:@"{"];
    if (range.location == NSNotFound) {
        item = [[MessageItem alloc] init];
        item.content = message;
        [self.items addObject:item];
        return;
    }
    NSString *content = [message substringToIndex:range.location];
    item = [[MessageItem alloc] init];
    item.content = content;
    [self.items addObject:item];
    
    message = [message substringFromIndex:range.location + 1];
    
    range = [message rangeOfString:@"}"];
    NSString *key = [message substringToIndex:range.location];
    item = [[MessageItem alloc] init];
    item.key = key;
    item.needInput = true;
    needInputCount++;
    [self.items addObject:item];

    
    message = [message substringFromIndex:range.location + 1];
    
    [self seperateMessageString:message];
    
}

#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([[notification.userInfo numberValueForKey:@"rc"] integerValue] == 0) {
        [[[CBMessageView alloc] initWithTitle:@"群发成功"] show];
        if (self.qunfa) {
            for (UIViewController *viewController in self.navigationController.viewControllers) {
                if ([viewController isKindOfClass:[MemberMessageViewController class]]) {
                    [self.navigationController popToViewController:viewController animated:YES];
                    return;
                }
            }
        }
        else
        {
            for (UIViewController *viewController in self.navigationController.viewControllers) {
                if ([viewController isKindOfClass:[MemberFunctionViewController class]]) {
                    [self.navigationController popToViewController:viewController animated:YES];
                    return;
                }
            }
        }
    }
    else
    {
        [[[CBMessageView alloc] initWithTitle:@"群发失败,请重新尝试"] show];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageItem *item = [self.items objectAtIndex:indexPath.row];
    if (item.needInput) {
        MessageInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageInputCell"];
        if (cell == nil) {
            cell = [MessageInputCell createCell];
            cell.textField.delegate = self;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textField.tag = 101 + indexPath.row;
        cell.textField.placeholder = [self paramsToDesc:item.key];
        cell.textField.text = item.content;
        return cell;
    }
    else
    {
        MessageContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageContentCell"];
        if (cell == nil) {
            cell = [MessageContentCell createCell];
        }
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentLabel setText:item.content lineSpace:6];
        return cell;
    }
}

- (NSString *)paramsToDesc:(NSString *)key
{
    for (NSDictionary *desc in self.descs) {
        if (desc[@"name"] == key) {
            return desc[@"desc"];
        }
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageItem *item = [self.items objectAtIndex:indexPath.row];
    if (item.needInput) {
        return 55;
    }
    else
    {
        [self.cell.contentLabel setText:item.content lineSpace:6];
        CGFloat height = [self.cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        NSLog(@"height: %d",height);
        return height;
    }
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger *idx = textField.tag - 101;
    MessageItem *item = [self.items objectAtIndex:idx];
    item.content = textField.text;
    if (textField.text.length > 0) {
        [self.valueDict setObject:textField.text forKey:item.key];
    }
    else
    {
        [self.valueDict removeObjectForKey:item.key];
    }
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)sendBtnPressed:(id)sender {
    
    for (MessageItem *item in self.items) {
        if (item.needInput && item.content.length == 0) {
            CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:@"请填写必要的模板内容"];
            [messageView show];
            return;
        }
    }
    if (self.member) {
        NSMutableString *sendString = [NSMutableString string];
        for (MessageItem *item in self.items)
        {
            [sendString appendString:item.content];
        }
        [self sendMsgWithMessage:sendString];
    }
    else
    {
        NSMutableArray *telephoneArray = [NSMutableArray array];
        
        for (CDMember *member in self.peoples) {
            [telephoneArray addObject:member.mobile];
        }
        
        //    NSMutableDictionary *valueDict = [NSMutableDictionary dictionary];
        //    [valueDict setObject:@"abc" forKey:@"param1"];
        
        NSMutableDictionary *valDict = [NSMutableDictionary dictionary];
        valDict[@"code"] = self.messageTmplate.template_id;
        valDict[@"values"] = self.valueDict;
        valDict[@"company_born_uuid"] = [PersonalProfile currentProfile].companyUUID;
        valDict[@"shop_born_uuid"] = [PersonalProfile currentProfile].shopUUID;
        valDict[@"user_born_uuid"] = [PersonalProfile currentProfile].born_uuid;
        
        BSSendMessageRequest *sendReqeust = [[BSSendMessageRequest alloc] initWithParamArray:@[telephoneArray,valDict]];
        [sendReqeust execute];
    }
}

#pragma mark - 发送短信
-(void)sendMsgWithMessage:(NSString *)message
{
    if ([BSMessageNavigationController canSendText])
    {
        __weak typeof(self) wself = self;
        [wself.navigationController.navigationBar setCustomizedNaviBar:NO];
        BSMessageNavigationController *messageVC = [[BSMessageNavigationController alloc] init];
        [messageVC.navigationBar setCustomizedNaviBar:YES];
        //        messageVC.view.backgroundColor = [UIColor clearColor];
        if ([messageVC.navigationBar respondsToSelector: @selector(setTitleTextAttributes:)])
        {
            NSDictionary* attrDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      COLOR(0, 165, 254,1), UITextAttributeTextColor,
                                      [UIFont boldSystemFontOfSize:20.0], UITextAttributeFont,
                                      nil];
            [messageVC.navigationBar setTitleTextAttributes: attrDict];
        }
        messageVC.recipients = [NSArray arrayWithObject:wself.member.mobile];
        [messageVC setBody:[NSString stringWithFormat:[NSString stringWithFormat:message]]];
        
        messageVC.messageComposeDelegate = wself;
        
        [wself.navigationController presentViewController:messageVC animated:YES completion:nil];
    }
}
#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (result == MessageComposeResultFailed) {
        [[[CBMessageView alloc] initWithTitle:@"短信发送失败"] show];
    }
    else if (result == MessageComposeResultSent)
    {
        [[[CBMessageView alloc] initWithTitle:@"短信发送成功"] show];
    }
    [self.navigationController.navigationBar setCustomizedNaviBar:YES];
    [self performSelector:@selector(dismissMessageVC:) withObject:controller afterDelay:1.25];
}

- (void)dismissMessageVC:(MFMessageComposeViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:^{
//        [self.navigationController popViewControllerAnimated:NO];
    }];
}

@end

#pragma mark - MessageItem Class
@implementation MessageItem

@end
