//
//  YimeiCreateProjectItemViewController.m
//  ds
//
//  Created by jimmy on 16/11/7.
//
//

#import "YimeiCreateProjectItemViewController.h"
#import "CBLoadingView.h"
#import "BSProjectItemCreateRequest.h"

typedef enum YimeiCreateProjectItemRow
{
    YimeiCreateProjectItemRow_Name,
    YimeiCreateProjectItemRow_Price,
    YimeiCreateProjectItemRow_Count
}YimeiCreateProjectItem_Row;

@interface YimeiCreateProjectItemViewController ()
@property(nonatomic, weak)IBOutlet UITableView* tableView;
@end

@implementation YimeiCreateProjectItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)didCloseButtonPressed:(id)sender
{
    [self.maskView hidden];
}

- (IBAction)didOKButtonPressed:(id)sender
{
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UILabel* nameLabel = (UILabel*)[cell viewWithTag:101];
    if ( nameLabel.text.length == 0 )
    {
        UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"请输入项目名字" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [v show];
        return;
    }
    
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    UILabel* priceLabel = (UILabel*)[cell viewWithTag:101];
    if ( priceLabel.text.length == 0 )
    {
        UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"请输入金额" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [v show];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:nameLabel.text forKey:@"name"];
    [params setObject:priceLabel.text forKey:@"list_price"];
    [params setObject:@"service" forKey:@"type"];
    [params setObject:@(kPadBornCategoryProject) forKey:@"born_category"];
    if ( self.currentCategory.categoryID )
    {
        [params setObject:self.currentCategory.categoryID forKey:@"pos_categ_id"];
    }
    
    [[CBLoadingView shareLoadingView] show];
    
    BSProjectItemCreateRequest *request = [[BSProjectItemCreateRequest alloc] initWithParams:params];
    [request execute];
    
    [self registerNofitificationForMainThread:kBSProjectItemCreateResponse];
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ( [notification.name isEqualToString:kBSProjectItemCreateResponse] )
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            [self.maskView hidden];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return YimeiCreateProjectItemRow_Count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        UITextField *label = [[UITextField alloc] initWithFrame:CGRectMake(110, 0, self.tableView.frame.size.width - 160, 60)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16];
        label.placeholder = @"请输入";
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 101;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView* backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 0, self.tableView.frame.size.width - 140, 60)];
        backgroundImageView.tag = 102;
        backgroundImageView.image = [[UIImage imageNamed:@"pos_text_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
        [cell.contentView addSubview:backgroundImageView];
        [cell.contentView addSubview:label];
    }
    
    UITextField *nameTextField = (UITextField *)[cell.contentView viewWithTag:101];
    if ( indexPath.section == 0 )
    {
        nameTextField.keyboardType = UIKeyboardTypeDefault;
    }
    else
    {
        nameTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( section == 0 )
    {
        return 72;
    }
    else
    {
        return 106;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v = [[UIView alloc] initWithFrame:CGRectZero];
    v.backgroundColor = [UIColor whiteColor];
    if ( section == 0 )
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 32, 300, 20)];
        label.text = @"名称";
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = COLOR(153, 174, 175,1);
        label.backgroundColor = [UIColor clearColor];
        [v addSubview:label];
    }
    else if ( section == 1 )
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 69, 300, 20)];
        label.text = @"金额";
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = COLOR(153, 174, 175,1);
        label.backgroundColor = [UIColor clearColor];
        [v addSubview:label];
    }
    
    return v;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
