//
//  PadBookRightContainerViewController.m
//  meim
//
//  Created by jimmy on 2017/5/24.
//
//

#import "PadBookRightContainerViewController.h"
#import "PadBookRightViewController.h"
#import "CBMessageView.h"
#import "NSDate+Formatter.h"
#import "BSHandleBookRequest.h"
#import "UIView+Extension.h"
#import "BSFetchMemberRequest.h"
@interface PadBookRightContainerViewController ()
@property(nonatomic, strong)PadBookRightViewController* vc;
@end

@implementation PadBookRightContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
}

//新建，编辑 调出右侧填写框都走这里 而该控制器的book模型又是点右上角确定拿到的
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"ContainVC..prepareForSegue");
    WeakSelf;
    self.vc = [segue destinationViewController];
    self.vc.book = self.book;
    self.vc.deleteButtonPressed = ^{
        weakSelf.didDeleteButtonPressed(weakSelf.book);
    };
}

- (IBAction)didCancelButtonPressed:(id)sender
{
    if (self.vc.infoDidChanged || self.vc.nameTextField.text.length > 0 || self.vc.phoneNumberTextField.text.length > 0 || self.vc.remarkTextView.text.length > 0) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"现在关闭将不会保存预约信息" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            WeakSelf
            weakSelf.didCancelButtonPressed(weakSelf.book);
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        self.didCancelButtonPressed(self.book);
    }
    //[self.view removeFromSuperview];
}


- (IBAction)didConfirmButtonPressed:(id)sender
{
    NSLog(@"save book - phone = %@",self.vc.phoneNumberTextField.text);
    if (self.vc.phoneNumberTextField.text.length!=11) {
        CBMessageView *mobileNumberError = [[CBMessageView alloc]initWithTitle:@"手机号码不是11位无法提交"];
        if ([self.vc.nameTextField isFirstResponder]) {
            [self.vc.nameTextField resignFirstResponder];
        }
        [mobileNumberError show];
        return;
    }
    
    self.book.mark = self.vc.remarkTextView.text;
    self.book.booker_name = self.vc.nameTextField.text;
    self.book.telephone = self.vc.phoneNumberTextField.text;
    
    
    //2017年9月预约新增推荐人修改 这里是填好预约信息 点击右上角保存按钮
    //self.book.recommend_member_phone = @"18856425363";
    
//    {
//        ///如果是保存新的会员 发请求给后台新创建会员
//        NSLog(@"save button=%@",self.vc.nameTextField.text);
//        BSFetchMemberRequest *request = [[BSFetchMemberRequest alloc] init];
//        
//        [request execute];
//    }
    
    [[UIApplication sharedApplication].keyWindow endEditing:true];
    if (self.book.booker_name.length == 0)
    {
        CBMessageView *msgView = [[CBMessageView alloc] initWithTitle:@"预约者名字不能为空"];
        [msgView showInView:self.view];
        return;
    }
    
    if (self.book.telephone.length == 0)
    {
        CBMessageView *msgView = [[CBMessageView alloc] initWithTitle:@"预约者的电话号码不能为空"];
        [msgView showInView:self.view];
        return;
    }
    
    if ([PersonalProfile currentProfile].isTable.boolValue)
    {
        if ([self.book.table_id integerValue] == 0) {
            CBMessageView *msgView = [[CBMessageView alloc] initWithTitle:@"预约的桌子不能为空"];
            [msgView showInView:self.view];
            return;
        }
    }
    else
    {
        if ([self.book.technician_id integerValue] == 0)
        {
            CBMessageView *msgView = [[CBMessageView alloc] initWithTitle:@"预约的技师不能为空"];
            [msgView showInView:self.view];
            return;
        }
    }
    
    NSDate *startDate = [NSDate dateFromString:self.book.start_date];
    NSDate *endDate = [NSDate dateFromString:self.book.end_date];
    if (!((startDate.year == endDate.year) && (startDate.month == endDate.month) && (startDate.day == endDate.day)))
    {
        CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:@"亲，预约的时间应该在同一天哦"];
        [messageView showInView:self.view];
        return;
    }
    
    NSTimeInterval timeInterval = [endDate timeIntervalSinceDate:startDate];
    if (timeInterval <= 0)
    {
        CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:@"亲，预约的结束时间大于预约的开始时间"];
        [messageView showInView:self.view];
        return;
    }
    
    if (startDate.hour < 7)
    {
        CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:@"亲，门店是七点开始营业的，您预约的开始时间大于门店开门的时间了呢"];
        [messageView showInView:self.view];
        return;
    }
    //NSLog(@"填写预约信息完毕点确定按钮=%@-%@",self.book.booker_name,self.book.telephone);
    
//    ///验证手机号码格式
//    if ([self checkoutPhoneNum:self.vc.phoneNumberTextField.text]==YES) {
//
//        self.didConfirmButtonPressed(self.book);
//    } else {
//        CBMessageView *mobileNumberError = [[CBMessageView alloc]initWithTitle:@"手机号码格式错误"];
//        [mobileNumberError show];
//        return;
//    }
    self.didConfirmButtonPressed(self.book);

    
    [self.view removeFromSuperview];
}

////判断手机号
//- (BOOL)checkoutPhoneNum: (NSString *)phoneNum {
//    NSString *regexStr = @"^1[3,8]\\d{9}|14[5,7,9]\\d{8}|15[^4]\\d{8}|17[^2,4,9]\\d{8}$";
//    NSError *error;
//    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
//    if (error) return NO;
//    NSInteger count = [regular numberOfMatchesInString:phoneNum options:NSMatchingReportCompletion range:NSMakeRange(0, phoneNum.length)];
//    if (count > 0) {
//        return YES;
//    } else {
//        return NO;
//    }
//}

///只能判断是否是11位
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length == 11) {
        return true;
    }
    else
    {
        return false;
    }
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


@end
