//
//  MemberCardTurnShopViewController.m
//  Boss
//  转店
//  Created by lining on 16/4/12.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberCardTurnShopViewController.h"
#import "BSCommonSelectedItemViewController.h"
#import "CBMessageView.h"
#import "CBLoadingView.h"
#import "BSMemberCardTurnStoreRequest.h"

@interface MemberCardTurnShopViewController ()<BSCommonSelectedItemViewControllerDelegate>
@property (nonatomic, strong) CDStore *cardNewStore;
@property (nonatomic, strong) NSString *remark;
@end

@implementation MemberCardTurnShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *leftItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    leftItem.delegate = self;
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.title = @"转店";
    
    self.sureBtn.enabled = false;
    
    self.nameLabel.text = self.card.priceList.name;
    self.noLabel.text = self.card.cardNo;
    self.memberStoreLabel.text = self.card.member.store.storeName;
    self.oldStoreLabel.text = self.card.storeName;
    
    self.hideKeyBoardWhenClickEmpty = true;
    self.markTextField.delegate = self;
    
    [self registerNofitificationForMainThread:kBSMemberCardTurnStoreResponse];

}

#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kBSMemberCardTurnStoreResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            [[[CBMessageView alloc] initWithTitle:@"转店成功"] show];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
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
}
#pragma mark - button action
- (IBAction)changeShopBtnPressed:(UIButton *)sender {
    NSArray *stores = [[BSCoreDataManager currentManager] fetchAllStoreList];
    NSMutableArray *storeNames = [NSMutableArray array];
    NSInteger *currentIdx = -1;
    for (int i = 0;  i < stores.count; i++) {
        CDStore *store = [stores objectAtIndex:i];
        if (store.storeID.integerValue == self.cardNewStore.storeID.integerValue) {
            currentIdx = i;
        }
        [storeNames addObject:store.storeName];
    }
    
    BSCommonSelectedItemViewController *selectedItemVC = [[BSCommonSelectedItemViewController alloc] init];
    selectedItemVC.delegate = self;
    selectedItemVC.userData = stores;
    selectedItemVC.currentSelectIndex = currentIdx;
    selectedItemVC.dataArray = storeNames;
    [self.navigationController pushViewController:selectedItemVC animated:YES];
}

- (IBAction)sureBtnPressed:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.card.cardID forKey:@"card_id"];
    [params setObject:self.card.member.memberID forKey:@"member_id"];
    [params setObject:self.cardNewStore.storeID forKey:@"new_card_shop_id"];
    [params setObject:@(0) forKey:@"is_change_member_shop"];
    [params setObject:self.remark.length > 0 ?self.remark:@"" forKey:@"remark"];
    [[CBLoadingView shareLoadingView] show];
    BSMemberCardTurnStoreRequest *request = [[BSMemberCardTurnStoreRequest alloc] initWithParams:params];
    [request execute];
}

#pragma mark - BSCommonSelectedItemViewControllerDelegate
-(void)didSelectItemAtIndex:(NSInteger)index userData:(id)userData
{
    NSArray *stores = (NSArray *)userData;
    self.cardNewStore = [stores objectAtIndex:index];
    if (self.cardNewStore.storeID.integerValue == self.card.storeID.integerValue) {
        [[[CBMessageView alloc] initWithTitle:@"新旧门店一样，请重新选择"] show];
        self.sureBtn.enabled = false;
    }
    else
    {
        self.sureBtn.enabled = true;
    }
    self.storeLabel.text = self.cardNewStore.storeName;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.remark = textField.text;
    
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
