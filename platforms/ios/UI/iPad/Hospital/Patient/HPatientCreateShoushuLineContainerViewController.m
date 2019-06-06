//
//  HPatientCreateShoushuLineContainerViewController.m
//  meim
//
//  Created by jimmy on 2017/5/10.
//
//

#import "HPatientCreateShoushuLineContainerViewController.h"
#import "HPatientCreateShoushuLineViewController.h"
#import "HShoushuCreateRequest.h"
#import "HShoushuLineEditRequest.h"
#import "CBLoadingView.h"
#import "HPatientShoushuLineTagViewController.h"
#import "H9ShoushuEditRequest.h"
#import "CBMessageView.h"

@interface HPatientCreateShoushuLineContainerViewController ()
@property(nonatomic, weak)IBOutlet UILabel* titleLabel;
//@property(nonatomic, strong)HPatientCreateShoushuLineViewController* vc;
@property(nonatomic, strong)HPatientShoushuLineTagViewController* tagVC;
@property(nonatomic, strong)IBOutlet UIView* tagContainerView;
@end

@implementation HPatientCreateShoushuLineContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerNofitificationForMainThread:kHShoushuCreateResponse];
    [self registerNofitificationForMainThread:kHShoushuLinesResponse];
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kHShoushuCreateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            [[BSCoreDataManager currentManager] save:nil];
            [self.view removeFromSuperview];
        }
    }
    else if ([notification.name isEqualToString:kHShoushuLinesResponse])
    {
            [self.vc.tableView reloadData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.destinationViewController isKindOfClass:[HPatientCreateShoushuLineViewController class]] )
    {
        WeakSelf;
        self.vc = [segue destinationViewController];
        self.vc.shoushuLine = self.shoushuLine;
        self.vc.didTagButtonPressed = ^(void (^selectedFinished)(void)) {
            weakSelf.tagContainerView.hidden = NO;
            [weakSelf.tagVC showWithAnimation:[weakSelf.shoushuLine.operate_tags componentsSeparatedByString:@","]];
            weakSelf.tagVC.didTagSelectedFinsihed = ^(NSArray *ids, NSString *name) {
                weakSelf.shoushuLine.operate_tags = [ids componentsJoinedByString:@","];
                weakSelf.shoushuLine.operate_tags_names = name;
                selectedFinished();
            };
        };
        self.vc.didCancelFinsihed = ^{
            weakSelf.doReload();
        };
    }
    else
    {
        self.tagVC = [segue destinationViewController];
    }
}

- (IBAction)didSaveButtonPressed:(id)sender
{
    if ( self.vc.operateDateTextField.text.length == 0 )
    {
        [self showAlert:@"请输入手术时间"];
        return;
    }
    
    if ( [self.shoushuLine.product_id integerValue] == 0 )
    {
        [self showAlert:@"请选择手术项目"];
        return;
    }
    
    
    if ( [self.shoushuLine.shoushu.shoushu_id integerValue] == 0 )
    {
        //do nothing
        self.shoushuLine.name = self.vc.itemTextField.text;
        self.shoushuLine.note = self.vc.noteTextView.text;
        self.shoushuLine.review_days = @([self.vc.reviewDayTextField.text integerValue]);
        self.shoushuLine.has_confirm = @(TRUE);
        if ( self.doReload )
        {
            self.doReload();
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddSubShoushu" object:nil];

        [self.view removeFromSuperview];
    }
    else
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (self.vc.itemTextField.text.length != 0 )
        {
            self.shoushuLine.name = self.vc.itemTextField.text;
            [params setObject:self.vc.itemTextField.text forKey:@"name"];
        }
        
        if ( self.vc.operateDateTextField.text.length > 0  )
        {
            [params setObject:self.vc.operateDateTextField.text forKey:@"operate_date"];
        }
        
        if (self.vc.noteTextView.text.length != 0 )
        {
            self.shoushuLine.note = self.vc.noteTextView.text;
            [params setObject:self.vc.noteTextView.text forKey:@"note"];
        }
        
        if (self.vc.reviewDayTextField.text.length != 0 )
        {
            self.shoushuLine.review_days = @([self.vc.reviewDayTextField.text integerValue]);
            [params setObject:self.vc.reviewDayTextField.text forKey:@"review_days"];
        }
        
        if ( self.vc.reviewDateTextField.text.length > 0  )
        {
            [params setObject:self.vc.reviewDateTextField.text forKey:@"review_date"];
        }
        
        if ( [self.shoushuLine.doctor_id integerValue] > 0  )
        {
            [params setObject:self.shoushuLine.doctor_id forKey:@"doctor_id"];
        }
        
        if (self.vc.removeIDArray.count > 0)
        {
            [params setObject:[self.vc.removeIDArray componentsJoinedByString:@","] forKey:@"review_date_unlink_id"];
        }
        if (self.vc.addDateArray.count > 0 && self.vc.isReviewDateChanged)
        {
            self.reviewIDArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < self.vc.addDateArray.count; i++)
            {
                NSMutableArray *elementArray = [[NSMutableArray alloc] init];
                [elementArray addObject:@0];
                [elementArray addObject:@0];
                NSDictionary *reviewDateDict = [NSDictionary dictionaryWithObject:self.vc.addDateArray[i] forKey:@"review_date"];
                [elementArray addObject:reviewDateDict];
                [self.reviewIDArray addObject:elementArray];
            }
            [params setObject:self.reviewIDArray forKey:@"review_date_ids"];
        }
        
        [params setObject:self.shoushuLine.product_id forKey:@"product_id"];
        
        if (![self.shoushuLine.operate_tags isEqualToString:@""])
        {
            NSMutableArray* idsArray = [NSMutableArray array];
            for (NSString* n in [self.shoushuLine.operate_tags componentsSeparatedByString:@","] )
            {
                if ( n.length > 0 )
                {
                    [idsArray addObject:@(n.integerValue)];
                }
            }
            [params setObject:@[@[@(6),@(FALSE),@[idsArray]]] forKey:@"operate_tags_ids"];
        }
        [[CBLoadingView shareLoadingView] show];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddSubShoushu" object:nil];
        if ( [self.shoushuLine.line_id integerValue] == 0 )
        {
            HShoushuCreateRequest* request = [[HShoushuCreateRequest alloc] initWithShoushuID:self.shoushuLine.shoushu.shoushu_id params:@{@"line_ids":@[@[@(0),@(FALSE),params]]} isEdit:FALSE];
            [request execute];
        }
        else
        {
            HShoushuCreateRequest* request = [[HShoushuCreateRequest alloc] initWithShoushuID:self.shoushuLine.line_id params:params isEdit:YES];
            [request execute];
        }
    }
}

- (IBAction)didCloseButtonPressed:(id)sender
{
    if ( [self.shoushuLine.line_id integerValue] == 0 && ![self.shoushuLine.has_confirm boolValue] )
    {
        [[BSCoreDataManager currentManager] deleteObject:self.shoushuLine];
    }
    [self.view removeFromSuperview];
}

- (void)showAlert:(NSString*)str
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:str
                                                       delegate:nil
                                              cancelButtonTitle:LS(@"IKnewButtonTitle")
                                              otherButtonTitles:nil, nil];
    [alertView show];
}


@end
