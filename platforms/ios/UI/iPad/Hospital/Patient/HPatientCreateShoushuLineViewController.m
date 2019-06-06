//
//  HPatientCreateShoushuLineViewController.m
//  meim
//
//  Created by jimmy on 2017/5/10.
//
//

#import "HPatientCreateShoushuLineViewController.h"
#import "UIImage+Resizable.h"
#import "SeletctListViewController.h"
#import "PadDatePickerView.h"
#import "SeletctListViewController.h"
#import "H9ShoushuEditRequest.h"
#import "CBLoadingView.h"
#import "CBMessageView.h"
#import "HPatientRecipeCreateTableViewCell.h"

@interface HPatientCreateShoushuLineViewController ()
@property(nonatomic, strong)SeletctListViewController* selectVC;
@property(nonatomic, weak)IBOutlet UITableViewCell* cancelCell;
//@property(nonatomic, strong)NSMutableArray* reviewDateArray;
@property(nonatomic, strong)NSMutableArray* dateIDArray;
//@property(nonatomic, strong)NSMutableArray* removeIDArray;
@end

@implementation HPatientCreateShoushuLineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    self.itemBgImageView.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
    self.tagBgImageView.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
    self.noteBgImageView.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
    self.operateDateBgImageView.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
    self.reviewDayBgImageView.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
    self.reviewDateBgImageView.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
    self.doctorBgImageView.image = [[UIImage imageNamed:@"pad_text_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
    //[self.tableView registerNib:[UINib nibWithNibName:@"HPatientRecipeCreateTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecipeCreateTableViewCell"];

    self.itemTextField.text = self.shoushuLine.name;
    self.operateDateTextField.text = self.shoushuLine.operate_date;
    self.noteTextView.text = self.shoushuLine.note;
    self.reviewDayTextField.text = [NSString stringWithFormat:@"%@",self.shoushuLine.review_days];
    self.reviewDateTextField.text = self.shoushuLine.review_date;
    
    self.reviewDateArray = [[NSMutableArray alloc] init];
    self.dateIDArray = [[NSMutableArray alloc] init];
    self.addDateArray = [[NSMutableArray alloc] init];
    self.isReviewDateChanged = NO;

    if (![self.shoushuLine.review_date isEqualToString:@""])
    {
        NSArray *dateStrArray = [self.shoushuLine.review_date componentsSeparatedByString:@","];
        if (dateStrArray.count > 0)
        {
            for (int i = 0; i < dateStrArray.count; i++)
            {
                NSArray *detailArray = [dateStrArray[i] componentsSeparatedByString:@"@"];
                if (detailArray.count > 1){
                    [self.dateIDArray addObject:detailArray[0]];
                    [self.reviewDateArray addObject:detailArray[1]];
                }
            }
        }
    }
    self.removeIDArray = [[NSMutableArray alloc] init];

    if ( self.shoushuLine.doctor_name.length > 0 )
    {
        self.doctorTextField.text = self.shoushuLine.doctor_name;
    }
    else
    {
        NSArray* array = [[BSCoreDataManager currentManager] fetchDoctorStaffsWithShopID:[PersonalProfile currentProfile].bshopId];
        for ( CDStaff* staff in array )
        {
            if ( [[PersonalProfile currentProfile].employeeID isEqual:staff.staffID] )
            {
                self.doctorTextField.text = staff.name;
                self.shoushuLine.doctor_name = staff.name;
                self.shoushuLine.doctor_id = staff.staffID;
            }
        }
    }
    
    if ( [self.shoushuLine.line_id integerValue] == 0 || [self.shoushuLine.state isEqualToString:@"cancel"] )
    {
        self.cancelCell.hidden = TRUE;
    }
    else
    {
        self.cancelCell.hidden = FALSE;
    }
    
    [self reloadTags];
}

- (void)reloadTags
{
    self.tagTextField.text = self.shoushuLine.operate_tags_names;
}

- (IBAction)didOperateDateButtonPressed:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    PadDatePickerView* v = [[PadDatePickerView alloc] init];
    v.datePickerMode = UIDatePickerModeDateAndTime;
    
    WeakSelf;
    v.selectFinished = ^(NSDate *date) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"yyyy-MM-dd HH:mm";
        NSString *dateString = [dateFormat stringFromDate:date];
        weakSelf.operateDateTextField.text = [dateString stringByAppendingString:@":00"];
        weakSelf.shoushuLine.operate_date = [dateString stringByAppendingString:@":00"];
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:v];
}

- (IBAction)didReviewDateButtonPressed:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    PadDatePickerView* v = [[PadDatePickerView alloc] init];
    v.datePickerMode = UIDatePickerModeDateAndTime;
    
    WeakSelf;
    v.selectFinished = ^(NSDate *date) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"yyyy-MM-dd HH:mm";
        NSString *dateString = [dateFormat stringFromDate:date];
        //weakSelf.reviewDateTextField.text = [dateString stringByAppendingString:@":00"];
        NSString *reviewDate = [NSString stringWithFormat:@"0@%@",[dateString stringByAppendingString:@":00"]];
        if(weakSelf.reviewDateArray.count == 0)
        {
            weakSelf.shoushuLine.review_date = [NSString stringWithFormat:@"%@",reviewDate];
        }
        else
        {
            weakSelf.shoushuLine.review_date = [NSString stringWithFormat:@"%@,%@",weakSelf.shoushuLine.review_date,reviewDate];
        }
        [weakSelf.reviewDateArray addObject:[dateString stringByAppendingString:@":00"]];
        [weakSelf.addDateArray addObject:[dateString stringByAppendingString:@":00"]];
        [weakSelf.tableView reloadData];
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:v];
}

- (IBAction)didDoctorButtonPressed:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    
    NSArray* doctorArray = [[BSCoreDataManager currentManager] fetchDoctorStaffsWithShopID:[PersonalProfile currentProfile].bshopId];
    
    WeakSelf;
    self.selectVC.countOfTheList = ^NSInteger{
        return doctorArray.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = doctorArray[index];
        return staff.name;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        CDStaff* staff = doctorArray[index];
        weakSelf.shoushuLine.doctor_id = staff.staffID;
        weakSelf.shoushuLine.doctor_name = staff.name;
        weakSelf.doctorTextField.text = staff.name;
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (IBAction)didItemButtonPressed:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    NSArray* itemArray = [[BSCoreDataManager currentManager] fetchProjectItemsWithType:kProjectItemDefault bornCategorys:[NSArray arrayWithObject:[NSNumber numberWithInt:kPadBornCategoryProject]] categoryIds:nil existItemIds:nil keyword:nil priceAscending:YES];
    
    WeakSelf;
    self.selectVC.countOfTheList = ^NSInteger{
        return itemArray.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDProjectItem* item = itemArray[index];
        return item.itemName;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        CDProjectItem* item = itemArray[index];
        weakSelf.shoushuLine.product_id = item.itemID;
        weakSelf.shoushuLine.product_name = item.itemName;
        weakSelf.itemTextField.text = item.itemName;
        //[weakSelf.tableView reloadData];
    };
    
    [self.parentViewController.view addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (IBAction)didCancelButtonPressed:(id)sender
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"确定要取消吗" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"operate_line_id"] = self.shoushuLine.line_id;
        params[@"is_cancel"] = @(TRUE);
        params[@"user_id"] = [PersonalProfile currentProfile].userID;
        H9ShoushuEditRequest* request = [[H9ShoushuEditRequest alloc] init];
        request.params = params;
        [request execute];
        [[CBLoadingView shareLoadingView] show];
        request.finished = ^(NSDictionary *params) {
            [[CBLoadingView shareLoadingView] hide];
            if ( [params[@"rc"] integerValue] == 0 )
            {
                self.shoushuLine.state = @"cancel";
                self.didCancelFinsihed();
                [self.view.superview removeFromSuperview];
            }
            else
            {
                [[[CBMessageView alloc] initWithTitle:params[@"rm"]] show];
            }
        };
    }]];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (IBAction)didTestButtonPressed:(id)sender
{
    WeakSelf;
    if ( self.didTagButtonPressed )
    {
        self.didTagButtonPressed(^{
            [weakSelf reloadTags];
        });
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1) {
        return 70;
    }
    else {
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 1) {
        return 30;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 724, 50)];

        UILabel * reviewLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 25, 200, 18)];
        reviewLabel.text = @"计划复查时间";
        reviewLabel.textColor = COLOR(154, 174, 174, 1);
        reviewLabel.font = [UIFont systemFontOfSize:17];
        view.backgroundColor = [UIColor whiteColor];
        [view addSubview:reviewLabel];

//        UIButton * templetButton = [[UIButton alloc] initWithFrame:CGRectMake(572, 24, 100, 16)];
//        [templetButton setTitle:@"选择处方模板" forState: UIControlStateNormal];
//        [templetButton addTarget:self action:@selector(didTempletButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//        [templetButton setTitleColor:COLOR(47, 143, 255, 1) forState:UIControlStateNormal];
//        templetButton.titleLabel.font = [UIFont systemFontOfSize:16];
//        templetButton.titleLabel.textAlignment = NSTextAlignmentRight;
//        [view addSubview:templetButton];

        return view;
    }
    return [super tableView:tableView viewForHeaderInSection:section];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == 1) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 724, 30)];
        view.backgroundColor = [UIColor whiteColor];
        return view;
    }
    return [super tableView:tableView viewForHeaderInSection:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 1) {
        return self.reviewDateArray.count + 1;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1) {
        return 60;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1) {
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReviewDateTableViewCell"];
        //HPatientRecipeCreateTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RecipeCreateTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.textLabel.text = self.reviewDateArray[indexPath.row];
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 0, 584, 60)];
        if ( indexPath.row == 0 )
        {
            if ( self.reviewDateArray.count == 0 )
            {
                bgImageView.image = [[UIImage imageNamed:@"pos_text_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
            }
            else
            {
                bgImageView.image = [[UIImage imageNamed:@"pos_cell_bg_t"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
            }
        }
        else if ( indexPath.row == self.reviewDateArray.count )
        {
            bgImageView.image = [[UIImage imageNamed:@"pos_cell_bg_b"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
        }
        else
        {
            bgImageView.image = [[UIImage imageNamed:@"pos_cell_bg_m"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
        }
        [cell addSubview:bgImageView];
        UIImageView *statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(90, 20, 20, 20)];
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(122, 20, 200, 20)];
        if (indexPath.row == 0) {
            //            cell.recipeStatusButtonPressed = ^{
            //
            //            }
            statusImageView.image = [UIImage imageNamed:@"pos_add"];
            timeLabel.text = @"添加复查时间";
            timeLabel.textColor = COLOR(155, 155, 155, 1);
        }
        else {
            statusImageView.image = [UIImage imageNamed:@"pad_delete_n"];
            timeLabel.text = self.reviewDateArray[indexPath.row-1];
            timeLabel.textColor = COLOR(37, 37, 37, 1);
            //cell.additionLabel.text = @"口服：每日三次，每次2片";
        }
        [cell addSubview:statusImageView];
        [cell addSubview:timeLabel];
        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    }
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1) {
        self.isReviewDateChanged = YES;
        if (indexPath.row > 0) {
            [self.reviewDateArray removeObjectAtIndex:indexPath.row-1];
            [self.tableView reloadData];
            [self.removeIDArray addObject:self.dateIDArray[indexPath.row-1]];
            [self.dateIDArray removeObjectAtIndex:indexPath.row-1];
            NSLog(@"Delete Row!");
            
            //            UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"HPatientBoard" bundle:nil];
            //            HPatientCreateRecipeContainerViewController* viewc = [tableViewStoryboard instantiateViewControllerWithIdentifier:@"createRecipeContainer"];
            //            UIViewController *vc = [[UIApplication sharedApplication] keyWindow].rootViewController;
            
        }
        else {
            [self didReviewDateButtonPressed:nil];
        }
    }
}

@end
