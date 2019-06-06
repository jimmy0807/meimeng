//
//  MessageViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/9/6.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "MessageViewController.h"
#import "BSMessageCell.h"
#import "BSCoreDataManager.h"
#import "ReadMessageRequest.h"
#import "CBWebViewController.h"
#import "NSData+Additions.h"
#import "FetchUnreadMessageRequest.h"

@interface MessageViewController ()
@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) UITableView *messageTableView;
@end

@implementation MessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self forbidSwipGesture];
    self.title = LS(@"MessageNaviTitle");
    self.view.backgroundColor = COLOR(245.0, 245.0, 245.0, 1.0);
    self.view.frame = CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT);
    
    BNBackButtonItem *backButtonItem = [[BNBackButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_back_n"] highlightedImage:[UIImage imageNamed:@"navi_back_h"]];
    backButtonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    [self registerNofitificationForMainThread:kFetchUnReadMessageResponse];
    
    self.messages = [[BSCoreDataManager currentManager] fetchAllMessage];
    
    self.messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.messageTableView.backgroundColor = [UIColor clearColor];
    self.messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.messageTableView.delegate = self;
    self.messageTableView.dataSource = self;
    self.messageTableView.showsVerticalScrollIndicator = NO;
    self.messageTableView.showsHorizontalScrollIndicator = NO;
    self.messageTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.messageTableView];
    
    FetchUnreadMessageRequest* request = [[FetchUnreadMessageRequest alloc] init];
    [request execute];
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kFetchUnReadMessageResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            self.messages = [[BSCoreDataManager currentManager] fetchAllMessage];
            [self.messageTableView reloadData];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kBSMessageCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BSMessageCellIdentifier";
    BSMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BSMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    CDMessage *message = [self.messages objectAtIndex:indexPath.row];
    cell.titleLabel.text = message.title;
    cell.detailLabel.text = message.content;
    cell.timeLabel.text = @"";
    if (message.time.length >= 16)
    {
        cell.timeLabel.text = [message.time substringToIndex:16];
    }
    
    if (!message.isRead.boolValue)
    {
        cell.backgroundColor = COLOR(255.0, 255.0, 255.0, 1.0);
        cell.titleLabel.textColor = COLOR(36.0, 36.0, 36.0, 1.0);
        cell.detailLabel.textColor = COLOR(160.0, 160.0, 160.0, 1.0);
        cell.timeLabel.textColor = COLOR(160.0, 160.0, 160.0, 1.0);
    }
    else
    {
        cell.backgroundColor = COLOR(248.0, 248.0, 248.0, 1.0);
        cell.titleLabel.textColor = COLOR(199.0, 199.0, 204.0, 1.0);
        cell.detailLabel.textColor = COLOR(199.0, 199.0, 204.0, 1.0);
        cell.timeLabel.textColor = COLOR(199.0, 199.0, 204.0, 1.0);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CDMessage *message = [self.messages objectAtIndex:indexPath.row];
    if ( !message.isRead.boolValue )
    {
        message.isRead = [NSNumber numberWithBool:YES];
        [[BSCoreDataManager currentManager] save:nil];
        
        BSMessageCell *cell = (BSMessageCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor = COLOR(245.0, 245.0, 245.0, 1.0);
        cell.titleLabel.textColor = COLOR(160.0, 160.0, 160.0, 1.0);
        
        ReadMessageRequest *request = [[ReadMessageRequest alloc] initWithMessageIds:@[message.messageID]];
        [request execute];
    }
    
    if ( [message.messageType integerValue] == 0 )
    {
        PersonalProfile* profile = [PersonalProfile currentProfile];
        NSString* sendParams =  [NSString stringWithFormat:@"login=%@&key=%@&redirect=reservation",profile.userName,profile.password];
        NSString* sendParamsSing =  [NSString stringWithFormat:@"login=%@password=%@",profile.userName,profile.password];
        
        NSString* prepareForSign = [NSString stringWithFormat:@"%@%@",sendParamsSing,[profile token]];
        
        NSData *userData = [prepareForSign dataUsingEncoding:NSUTF8StringEncoding];
        NSString* sign = [userData md5Hash];
        
        CBWebViewController* webViewController = [[CBWebViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/login?db=%@&%@&sign=%@&client_id=%@",profile.baseUrl,profile.sql,sendParams,sign,[profile deviceString]]];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
    else if ( [message.messageType integerValue] == 3 )
    {
        PersonalProfile* profile = [PersonalProfile currentProfile];
        NSString* sendParams =  [NSString stringWithFormat:@"login=%@&key=%@&redirect=mobile_report_commission",profile.userName,profile.password];
        NSString* sendParamsSing =  [NSString stringWithFormat:@"login=%@password=%@",profile.userName,profile.password];
        
        NSString* prepareForSign = [NSString stringWithFormat:@"%@%@",sendParamsSing,[profile token]];
        
        NSData *userData = [prepareForSign dataUsingEncoding:NSUTF8StringEncoding];
        NSString* sign = [userData md5Hash];
        
        CBWebViewController* webViewController = [[CBWebViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@/login?db=%@&%@&sign=%@&client_id=%@",profile.baseUrl,profile.sql,sendParams,sign,[profile deviceString]]];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}


@end
