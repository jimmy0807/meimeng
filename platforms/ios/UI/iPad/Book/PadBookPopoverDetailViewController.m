 //
//  PadBookPopoverDetailViewController.m
//  Boss
//
//  Created by lining on 15/12/10.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadBookPopoverDetailViewController.h"
#import "UIView+Frame.h"
#import "NSDate+Formatter.h"
#import "PadBookProjectViewController.h"
#import "BSHandleBookRequest.h"
#import "CBMessageView.h"
#import "BSFetchMemberRequest.h"
#import "PadRoomViewController.h"



typedef enum KSection
{
    KSection_member,
    KSection_project,
    kSection_room,//预约房间
    KSection_technician,
    KSection_start,
    KSection_end,
    KSection_mark,
    KSection_delete,
    KSection_num,
    
}KSection;

typedef enum kMember
{
    kMember_phone,
    kMember_name,
    kMember_num
}kMember;

@interface PadBookPopoverDetailViewController ()<UITextViewDelegate,PadBookProjectDelegate,UIActionSheetDelegate,PadRoomViewControllerDelegate>
{
    bool show_start_picker, show_end_picker, show_technician;
}
@property (nonatomic, strong) CDBook *orginBook;
@property (nonatomic, weak)IBOutlet UILabel* titleLabel;
@property (nonatomic, weak)IBOutlet UIButton* doneButton;
@end

@implementation PadBookPopoverDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   

    self.navigationController.navigationBarHidden= true;
    if (IS_SDK7)
    {
        self.preferredContentSize = CGSizeMake(self.view.width, self.view.height);
    }
    else
    {
        self.contentSizeForViewInPopover=CGSizeMake(self.view.width, self.view.height);
    }
    
    if ( [self.book.state isEqualToString:@"draft"] )
    {
        self.titleLabel.text = @"草稿";
        [self.doneButton setTitle:@"审核" forState:UIControlStateNormal];
    }
    else if ( [self.book.state isEqualToString:@"billed"] )
    {
        self.titleLabel.text = @"已开单";
    }
    else if ( [self.book.state isEqualToString:@"done"] )
    {
        self.titleLabel.text = @"已结账";
    }
    
    [self registerNofitificationForMainThread:kBSFetchMemberResponse];
    
    if ( [self.book.product_name length] == 0 )
    {
        NSArray* ids = [self.book.product_ids componentsSeparatedByString:@","];
        if ( ids.count > 0 )
        {
            CDProjectItem* item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:ids[0] forKey:@"itemID"];
            self.book.product_name = item.itemName;
            [[BSCoreDataManager currentManager] save:nil];
        }
    }
}

- (void) initOrginBook
{
    self.orginBook = [[BSCoreDataManager currentManager] insertEntity:@"CDBook"];
    self.orginBook.booker_name = self.book.booker_name;
    self.orginBook.telephone = self.book.telephone;
    self.orginBook.start_date = self.book.start_date;
    self.orginBook.end_date = self.book.end_date;
    self.orginBook.technician_id = self.book.technician_id;
    self.orginBook.technician_name = self.book.technician_name;
    self.orginBook.product_ids = self.book.product_ids;
    
    self.orginBook.product_name = self.book.product_name;
    self.orginBook.mark = self.book.mark;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.book.booker_name.length == 0)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kMember_phone inSection:KSection_member]];
        UITextField *textField = (UITextField *)[cell.contentView viewWithTag:101];
        [textField becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self removeNotificationOnMainThread:kBSFetchMemberResponse];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return KSection_num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == KSection_member)
    {
        return kMember_num;
    }
    else if (section == KSection_start)
    {
        if (show_start_picker)
        {
            return 2;
        }
        
        return 1;
    }
    else if (section == KSection_end)
    {
        if (show_end_picker)
        {
            return 2;
        }
        
        return 1;
    }
    else if (section == KSection_technician)
    {
        if ([PersonalProfile currentProfile].isTable.boolValue) {
            return 1;
        }
        else
        {
            if (show_technician)
            {
                return self.technicians.count + 1;
            }
            
            return 1;
        }
        
    }
    else if (section == kSection_room)
    {
        if ([PersonalProfile currentProfile].isTable.boolValue) {
            return 0;
        }
        else
        {
            return 1;
        }
    }
    else if (section == KSection_project)
    {
        return 1;
    }
    
    else if (section == KSection_mark)
    {
        return 1;
    }
    else if (section == KSection_delete)
    {
        return 1;
    }
    
    return 0;
}

- (void)didMemberDetailBtnPressed:(UIButton *)btn
{
    NSLog(@"%s",__FUNCTION__);
    CDMember *member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:self.book.member_id forKey:@"memberID"];
    
    if (member == nil) {
        CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:@"无此会员，无法查看详情"];
        [messageView show];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBookLookMemberDetail object:member];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == KSection_member || (section == KSection_project && [PersonalProfile currentProfile].isTable.boolValue)) {
        NSString *identifier = @"member_cell";
        UITableViewCell *member_cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (member_cell == nil)
        {
            member_cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, tableView.frame.size.width - 20, 44)];
            textField.delegate = self;
            textField.borderStyle = UITextBorderStyleNone;
            textField.backgroundColor = [UIColor clearColor];
            textField.font = [UIFont systemFontOfSize:15];
            textField.tag = 101;
//            textField.textColor = COLOR(166, 166, 166, 1);
//            textField.textAlignment = NSTextAlignmentCenter;
//            textField.clearsOnBeginEditing = true;
            [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [member_cell.contentView addSubview:textField];
            
            
            UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            detailBtn.tag = 102;
            detailBtn.frame = CGRectMake(tableView.frame.size.width - 80, 0 , 80, 44);
            detailBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [detailBtn setTitleColor:COLOR(96, 211, 212,1) forState:UIControlStateNormal];
            [detailBtn addTarget:self action:@selector(didMemberDetailBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [detailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
            [member_cell.contentView addSubview:detailBtn];
        }
        UITextField *textField = (UITextField *)[member_cell.contentView viewWithTag:101];
        UIButton *btn = (UIButton *)[member_cell.contentView viewWithTag:102];
        btn.hidden = true;
        
        if (section == KSection_member) {
            if (row == kMember_name) {
                textField.placeholder = @"请填写姓名";
                if ( self.bookMember )
                {
                    self.book.booker_name = self.bookMember.memberName;
                }
                textField.text = self.book.booker_name;
                if (self.book.booker_name.length > 0) {
                    btn.hidden = false;
                }
                textField.keyboardType = UIKeyboardTypeDefault;
            }
            else if (row == kMember_phone)
            {
                textField.placeholder = @"请填写电话号码";
                
                if ( self.bookMember )
                {
                    self.book.telephone = self.bookMember.mobile;
                }
                else if ( self.bookPhoneNumber )
                {
                    self.book.telephone = self.bookPhoneNumber;
                }
                
                textField.text = self.book.telephone;
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }
            [self cellBg:member_cell withRow:row minRow:0 maxRow:1];
        }
        else if (section == KSection_project && [PersonalProfile currentProfile].isTable.boolValue)
        {
            textField.placeholder = @"请填写人数";
            if (self.book.people_num) {
                textField.text = [NSString stringWithFormat:@"%d",self.book.people_num.integerValue];
            }
            
            textField.keyboardType = UIKeyboardTypePhonePad;
            
            member_cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_t.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
        }

        return member_cell;
    }
    else if (section == KSection_start || section == KSection_end)
    {
        if (row == 0) {
            NSString *date_cell_identifier = @"date_cell_identifier";
            UITableViewCell *date_cell = [tableView dequeueReusableCellWithIdentifier:date_cell_identifier];
            if (date_cell == nil) {
                date_cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:date_cell_identifier];
                date_cell.backgroundColor = [UIColor clearColor];
                date_cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            date_cell.textLabel.font = [UIFont systemFontOfSize:15];
            date_cell.detailTextLabel.textColor = COLOR(166, 166, 166, 1);
            if (section == KSection_start) {
                date_cell.textLabel.text = @"开始";
//                NSLog(@"")
                date_cell.detailTextLabel.text = self.book.start_date;
            }
            else
            {
                date_cell.textLabel.text = @"结束";
                date_cell.detailTextLabel.text = self.book.end_date;
            }
            if (section == KSection_start) {
                date_cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_t.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
            }
            else
            {
                if (show_end_picker) {
                    date_cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_m.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
                }
                else
                {
                    date_cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_b.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
                }
            }
            return date_cell;
        }
        else
        {
            NSString *date_picker_identifier = @"date_picker_identifier";
            UITableViewCell *date_picker_cell = [tableView dequeueReusableCellWithIdentifier:date_picker_identifier];
            if (date_picker_cell == nil) {
                date_picker_cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:date_picker_identifier];
                date_picker_cell.backgroundColor = [UIColor clearColor];
                date_picker_cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UIDatePicker *datePicker = [[UIDatePicker alloc] init];
                datePicker.y = 0;
                datePicker.x = (tableView.frame.size.width - datePicker.frame.size.width)/2.0;
                datePicker.tag = 102;
                
                datePicker.datePickerMode = UIDatePickerModeDateAndTime;
                [date_picker_cell.contentView addSubview:datePicker];
                
            }
            
            UIDatePicker *datePicker = (UIDatePicker *)[date_picker_cell.contentView viewWithTag:102];
            [datePicker addTarget:self action:@selector(didDateValueChanged:) forControlEvents:UIControlEventValueChanged];
            datePicker.minimumDate = [NSDate date];
      
            
            if (section == KSection_start) {
                date_picker_cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_m.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
                [datePicker setDate:[NSDate dateFromString:self.book.start_date] animated:NO];
//                datePicker.date = [NSDate dateFromString:self.book.start_date];
            }
            else
            {
                date_picker_cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_b.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
                [datePicker setDate:[NSDate dateFromString:self.book.end_date] animated:NO];
//                datePicker.date = [NSDate dateFromString:self.book.end_date] ;
            }
           
            
            return date_picker_cell;

        }
    }
    else if (section == KSection_technician)
    {
        if (row == 0) {
            static NSString *identifier = @"technician_identifier";
            UITableViewCell *technician_cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (technician_cell == nil) {
                NSLog(@"新建Cell");
                technician_cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
                technician_cell.backgroundColor = [UIColor clearColor];
                technician_cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            technician_cell.textLabel.font = [UIFont systemFontOfSize:15];
            technician_cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
            technician_cell.detailTextLabel.textColor = COLOR(166, 166, 166, 1);
            
            if (show_technician) {
                technician_cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_m.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
            }
            else
            {
                technician_cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_b.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
            }
            if ([PersonalProfile currentProfile].isTable.boolValue) {
                technician_cell.textLabel.text = @"桌子";
                technician_cell.detailTextLabel.text = self.book.table_name;
            }
            else
            {
                technician_cell.textLabel.text = @"技师";
                technician_cell.detailTextLabel.text = self.book.technician_name;
            }
            
            
            return technician_cell;
        }
        else
        {
            static NSString *identifier = @"technician";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.backgroundColor = [UIColor clearColor];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 52)];
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont systemFontOfSize:15];
                label.textAlignment = NSTextAlignmentCenter;
                label.tag = 101;
                [cell.contentView addSubview:label];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_m.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
            if (row == self.technicians.count) {
                cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_b.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
            }
            UILabel *label = [cell.contentView viewWithTag:101];
            
            CDStaff *technician = [self.technicians objectAtIndex:row - 1];
            label.text = technician.name;
            
            return cell;
        }
        
    }
    else if (![PersonalProfile currentProfile].isTable.boolValue && section == KSection_project)
    {
        static NSString *identifier = @"project_identifier";
        UITableViewCell *project_cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (project_cell == nil) {
            NSLog(@"新建Cell");
            project_cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            project_cell.backgroundColor = [UIColor clearColor];
            project_cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        project_cell.textLabel.font = [UIFont systemFontOfSize:15];
        project_cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        project_cell.detailTextLabel.textColor = COLOR(166, 166, 166, 1);
        
        project_cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_t.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
        project_cell.textLabel.text = @"项目";
        project_cell.detailTextLabel.text = self.book.product_name;
        
        
        return project_cell;
    }
    else if (section == kSection_room)
    {
        static NSString *identifier = @"room_identifier";
        UITableViewCell *room_cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (room_cell == nil) {
            NSLog(@"新建Cell");
            room_cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            room_cell.backgroundColor = [UIColor clearColor];
            room_cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        room_cell.textLabel.font = [UIFont systemFontOfSize:15];
        room_cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        room_cell.detailTextLabel.textColor = COLOR(166, 166, 166, 1);
        
        room_cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_m.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
        room_cell.textLabel.text = @"房间";
        room_cell.detailTextLabel.text = self.book.table_name;
        
        
        return room_cell;
    }
    else if (section == KSection_mark)
    {
        static NSString *identifier = @"mark_identifier";
        UITableViewCell *mark_cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (mark_cell == nil) {
            NSLog(@"新建Cell");
            mark_cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            mark_cell.backgroundColor = [UIColor clearColor];
            mark_cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            mark_cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_text_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
            
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, self.tableView.width - 20, 216 - 20)];
            textView.delegate = self;
            textView.font = [UIFont systemFontOfSize:14];
            [mark_cell.contentView addSubview:textView];
            textView.text = self.book.mark.length > 0 ? self.book.mark : @"";
        }
        
        return mark_cell;
    }
    else if (section == KSection_delete)
    {
        static NSString *identifier = @"delete_identifier";
        UITableViewCell *delete_cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (delete_cell == nil) {
            NSLog(@"新建Cell");
            delete_cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            delete_cell.backgroundColor = [UIColor clearColor];
            delete_cell.selectionStyle = UITableViewCellSelectionStyleNone;

            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (44-20)/2.0, self.tableView.width - 20, 20)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textColor = [UIColor redColor];
            titleLabel.text = @"删除预约";
            titleLabel.font = [UIFont systemFontOfSize:14];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [delete_cell.contentView addSubview:titleLabel];
        }
        
        [self cellBg:delete_cell withRow:row minRow:0 maxRow:0];
        
        return delete_cell;
    }
    return nil;
}

- (void)cellBg:(UITableViewCell *)cell withRow:(int)row minRow:(int)minRow maxRow:(int)maxRow
{
    if (minRow == maxRow) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_text_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
        return;
    }
    if (row == minRow) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_t.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
    }
    else if (row == maxRow)
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_b.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
    }
    else
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pos_cell_bg_m.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)]];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == KSection_start || section == KSection_end) {
        if (row == 1) {
            return 216;
        }
        else
        {
            return 44;
        }
    }
    else if (section == KSection_mark)
    {
        return 216;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == KSection_end) {
        return 0;
    }
    if (section == KSection_technician) {
        return 0;
    }
    if (section == kSection_room) {
        return 0;
    }
    return 35;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, (35 - 20), 100, 20)];
    label.textColor = COLOR(153, 174, 175,1);
    label.font = [UIFont systemFontOfSize:13];
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];

    if (section == KSection_mark)
    {
        view.backgroundColor = [UIColor whiteColor];
        label.text = @"备注信息";
        label.backgroundColor = [UIColor whiteColor];
    }

    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == KSection_member) {
    }
    else if (section == KSection_start)
    {
        show_start_picker = !show_start_picker;
        show_end_picker = false;
        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSetWithIndex:KSection_start];
        [indexSet addIndex:KSection_end];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        [self performSelector:@selector(autoScrollToSectin:) withObject:@(section) afterDelay:0.1];
        
    }
    else if (section == KSection_end)
    {
        show_end_picker = !show_end_picker;
        show_start_picker = false;
        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSetWithIndex:KSection_start];
        [indexSet addIndex:KSection_end];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        [self performSelector:@selector(autoScrollToSectin:) withObject:@(section) afterDelay:0.1];
    }
    else if (section == KSection_technician)
    {
        show_technician = !show_technician;
        if (row >= 1) {
            CDStaff *technician = [self.technicians objectAtIndex:row - 1];
            self.book.technician_id = technician.staffID;
            self.book.technician_name = technician.name;
            
            self.book.columnIdx = [NSNumber numberWithInt:row - 1];
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (section == kSection_room)
    {
        PadRoomViewController *roomVC = [[PadRoomViewController alloc] initWithNibName:@"PadRoomViewController" bundle:nil];
        roomVC.delegate = self;
        [self.navigationController pushViewController:roomVC animated:YES];
    }
    else if (section == KSection_project)
    {
        PadBookProjectViewController *bookProjectVC = [[PadBookProjectViewController alloc] init];
        bookProjectVC.delegate = self;
        [self.navigationController pushViewController:bookProjectVC animated:YES];
    }
    else if (section == KSection_mark)
    {
        
    }
    else if (section == KSection_delete)
    {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定要删除这个预约吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [actionSheet showInView:self.view];
        
//        if ([self.delegate respondsToSelector:@selector(deleteBtnPressed:)]) {
//            [self.delegate deleteBtnPressed:self.book];
//        }
    }
}


- (void)autoScrollToSectin:(NSNumber *)section
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section.integerValue] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if ([self.delegate respondsToSelector:@selector(deleteBtnPressed:)]) {
            [self.delegate deleteBtnPressed:self.book];
            NSLog(@"确定取消");
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[UIApplication sharedApplication].keyWindow endEditing:true];
}

#pragma mark - PadBookProjectDelegate
- (void) didSelectedProjectItem:(CDProjectItem *)projectItem
{
    self.book.product_ids = [projectItem.itemID stringValue];
    self.book.product_name = projectItem.itemName;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:KSection_project] withRowAnimation:UITableViewRowAnimationNone];
    
    if (projectItem.time.integerValue > 0) {
        NSDate *startDate = [NSDate dateFromString:self.book.start_date];
        NSDate *endDate = [NSDate dateWithTimeInterval:projectItem.time.integerValue * 60 sinceDate:startDate];
        self.book.end_date = [endDate dateString];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:KSection_end] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - PadRoomViewControllerDelegate
- (void)didSelectedRoom:(CDRestaurantTable *)table
{
    self.book.table_id = table.tableID;
    self.book.table_name = table.tableName;
     [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:kSection_room] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - date value changed
- (void)didDateValueChanged:(UIDatePicker *)datePicker
{
    UIView *superView = [datePicker superview];
    while (![superView isKindOfClass:[UITableViewCell class]]) {
        superView = [superView superview];
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)superView];
    if (indexPath.section == KSection_start) {
        self.book.start_date = [datePicker.date dateString];
    }
    else if (indexPath.section == KSection_end)
    {
        self.book.end_date = [datePicker.date dateString];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
//    NSLog(@"%s",__FUNCTION__);
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        return;
    }
    UIView *superView = [textField superview];
    while (![superView isKindOfClass:[UITableViewCell class]]) {
        superView = [superView superview];
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)superView];
    if (indexPath.section == KSection_member) {
        if (indexPath.row == kMember_name) {
            self.book.booker_name = textField.text;
            
            CDMember* member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withPredicateString:[NSString stringWithFormat:@"memberName == \"%@\" && storeID == %@",textField.text,[PersonalProfile currentProfile].bshopId]];
            
            if (member) {
                self.book.telephone = member.mobile;
                self.book.member_id = member.memberID;
                self.bookMember = member;
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:KSection_member] withRowAnimation:UITableViewRowAnimationNone];
            }
            else
            {
                BSFetchMemberRequest *request = [[BSFetchMemberRequest alloc] initWithKeyword:textField.text];
                [request execute];
            }
        }
        else if (indexPath.row == kMember_phone)
        {
            self.book.telephone = textField.text;
            
            CDMember* member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withPredicateString:[NSString stringWithFormat:@"mobile == \"%@\" && storeID == %@",textField.text,[PersonalProfile currentProfile].bshopId]];
            
            if (member)
            {
                self.bookMember = member;
                self.book.booker_name = member.memberName;
                self.book.member_id = member.memberID;
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:KSection_member] withRowAnimation:UITableViewRowAnimationNone];
            }
            else
            {
                if ( textField.text.length == 11 )
                {
                    BSFetchMemberRequest *request = [[BSFetchMemberRequest alloc] initWithKeyword:textField.text];
                    [request execute];
                }
            }
        }
    }
    else if (indexPath.section == KSection_project)
    {
        if (indexPath.row == 0) {
            textField.text = [NSString stringWithFormat:@"%d",textField.text.integerValue];
            self.book.people_num = [NSNumber numberWithInt:textField.text.integerValue];
        }
    }
    

    NSLog(@"%s",__FUNCTION__);
}


#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"%s",__FUNCTION__);
    self.book.mark = textView.text;
}


#pragma mark - received notification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchMemberResponse]) {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] == 0) {
            NSArray *retArray = notification.object;
            if (retArray.count > 0) {
                CDMember *member = retArray[0];
                self.bookMember = member;
                self.book.telephone = member.mobile;
                self.book.booker_name = member.memberName;
                self.book.member_id = member.memberID;
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:KSection_member] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark - btn action

- (IBAction)cacelBtnPressed:(UIButton *)sender
{
    NSLog(@"cancelBtnPressed");
    [[UIApplication sharedApplication].keyWindow endEditing:true];
    if ([self.delegate respondsToSelector:@selector(cancelBtnPressed:)])
    {
        [self.delegate cancelBtnPressed:self.book];
    }
}

- (IBAction)doneBtnPressed:(UIButton *)sender
{
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
    
    if ([PersonalProfile currentProfile].isTable.boolValue) {
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
    
    
    
//    if ([self.book.product_id integerValue] == 0) {
//        CBMessageView *msgView = [[CBMessageView alloc] initWithTitle:@"预约的项目不能为空"];
//        [msgView showInView:self.view];
//        return;
//    }
    
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
    
    if ([self.delegate respondsToSelector:@selector(doneBtnPressedWithBook:type:)])
    {
        [self.delegate doneBtnPressedWithBook:self.book type:self.type];
    }
}


@end
