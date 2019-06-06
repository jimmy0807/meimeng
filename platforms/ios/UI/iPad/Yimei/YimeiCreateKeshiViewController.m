//
//  YimeiCreateKeshiViewController.m
//  ds
//
//  Created by jimmy on 16/10/25.
//
//

#import "YimeiCreateKeshiViewController.h"
#import "FetchAllKeshiRequest.h"
#import "MBProgressHUD.h"
#import "BSFetchStaffRequest.h"
#import "SeletctListViewController.h"

@interface YimeiCreateKeshiViewController ()<UITextViewDelegate>
{
    BOOL first_keshi_expand;
    BOOL second_keshi_expand;
    BOOL shejishi_expand;
    BOOL guwen_expand;
    BOOL shejizongjian_expand;

    NSInteger currentFirstKeshi;
    NSInteger currentSecondKeshi;
    NSInteger currentShejishi;
    NSInteger currentGuwen;
    NSInteger currentShejizongjian;
}
@property(nonatomic, weak)IBOutlet UITableView* tableView;
@property(nonatomic, strong)NSArray* firstKeshiArray;
@property(nonatomic, strong)NSArray* secondKeshiArray;
@property(nonatomic, strong)NSArray* shgejishiArray;
@property(nonatomic, strong)NSArray* guwenArray;
@property(nonatomic, strong)NSArray* shejizongjianArray;
@property(nonatomic, strong)NSNumber* shopID;
@property(nonatomic, strong)SeletctListViewController* selectVC;
@property(nonatomic, strong)NSMutableDictionary* remarkTagDict;
@property(nonatomic, strong)NSArray* keshiRemarkArray;

@end

@implementation YimeiCreateKeshiViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shopID = [PersonalProfile currentProfile].bshopId;
    
    currentFirstKeshi = -1;
    currentSecondKeshi = -1;
    currentShejishi = -1;
    currentGuwen = -1;
    currentShejizongjian = -1;
    
    self.firstKeshiArray = [[BSCoreDataManager currentManager] fetchTopKeshi];
    self.keshiRemarkArray = [[BSCoreDataManager currentManager] fetchKeshiRemark];
    self.remarkTagDict = [[NSMutableDictionary alloc] init];

    if ( self.operate.firstKeshi )
    {
        [self.firstKeshiArray enumerateObjectsUsingBlock:^(CDKeShi*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ( [obj.keshi_id isEqual:self.operate.firstKeshi.keshi_id] )
            {
                currentFirstKeshi = idx;
                CDKeShi* keshi = self.firstKeshiArray[currentFirstKeshi];
                self.secondKeshiArray = keshi.staff.array;
                *stop = TRUE;
            }
        }];
        
        if ( currentFirstKeshi >=0 && self.operate.doctor_id )
        {
            self.secondKeshiArray = self.operate.firstKeshi.staff.array; //[[BSCoreDataManager currentManager] fetchChildKeshi:self.operate.firstKeshi];
            
            [self.secondKeshiArray enumerateObjectsUsingBlock:^(CDStaff*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ( [obj.staffID isEqual:self.operate.doctor_id] )
                {
                    currentSecondKeshi = idx;
                    *stop = TRUE;
                }
            }];
        }
    }
    
    self.guwenArray = [[BSCoreDataManager currentManager] fetchGuwenStaffsWithShopID:self.shopID];
    if ( [self.operate.yimei_guwenID integerValue] == 0 )
    {
        //self.operate.yimei_guwenID = self.operate.member.member_guwen_id;
    }
    
    BOOL bCheckGuwen = TRUE;
//    if ( currentFirstKeshi >= 0 )
//    {
//        CDKeShi* keshi = self.firstKeshiArray[currentFirstKeshi];
//        if ( ![keshi.is_display_adviser boolValue] )
//        {
//            bCheckGuwen = FALSE;
//        }
//    }
    
    if ( self.operate.yimei_guwenID && bCheckGuwen )
    {
        [self.guwenArray enumerateObjectsUsingBlock:^(CDStaff*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ( [obj.staffID isEqual:self.operate.yimei_guwenID] )
            {
                currentGuwen = idx;
                *stop = TRUE;
            }
        }];
    }
    
    if ( [self.operate.yimei_shejishiID integerValue] == 0 )
    {
        self.operate.yimei_shejishiID = self.operate.member.member_shejishi_id;
    }
    
    self.shgejishiArray = [[BSCoreDataManager currentManager] fetchShejishiStaffsWithShopID:self.shopID];
    if ( self.operate.yimei_shejishiID )
    {
        [self.shgejishiArray enumerateObjectsUsingBlock:^(CDStaff*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ( [obj.staffID isEqual:self.operate.yimei_shejishiID] )
            {
                currentShejishi = idx;
                *stop = TRUE;
            }
        }];
    }
    
    if ( [self.operate.yimei_shejizongjianID integerValue] == 0 )
    {
        self.operate.yimei_shejizongjianID = self.operate.member.director_employee_id;
    }
    
    self.shejizongjianArray = [[BSCoreDataManager currentManager] fetchShejizongjianStaffsWithShopID:self.shopID];
    if ( self.operate.yimei_shejizongjianID)
    {
        [self.shejizongjianArray enumerateObjectsUsingBlock:^(CDStaff*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ( [obj.staffID isEqual:self.operate.yimei_shejizongjianID] )
            {
                currentShejizongjian = idx;
                *stop = TRUE;
            }
        }];
    }
    
        self.shopID = [[PersonalProfile currentProfile].shopIds firstObject];
//    BSFetchStaffRequest *request = [[BSFetchStaffRequest alloc] init];
//    request.shopID = self.shopID;
//    [request execute];
    
    [self registerNofitificationForMainThread:kBSFetchStaffResponse];
    [self registerNofitificationForMainThread:kBSFetchKeshiResponse];
    
    [self setFooter];
}

- (void)setFooter
{
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 800)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 19, 300, 20)];
    label.text = @"医生备注";
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = COLOR(153, 174, 175,1);
    label.backgroundColor = [UIColor clearColor];
    [bgView addSubview:label];
    
    UITextView* textField = [[UITextView alloc] initWithFrame:CGRectMake(70, 49, self.view.frame.size.width - 140, 180)];
    textField.delegate = self;
    textField.layer.borderColor = COLOR(234, 234, 234, 1).CGColor;
    textField.layer.borderWidth = 1;
    textField.tag = 3001;
    textField.layer.masksToBounds = TRUE;
    textField.text = self.operate.remark;
    [bgView addSubview:textField];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(71, 140, self.tableView.frame.size.width - 142, 88)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.scrollEnabled = YES;
    NSArray *remarkArray;
    if ( currentFirstKeshi != -1 )
    {
        CDKeShi* keshi = self.firstKeshiArray[currentFirstKeshi];
        remarkArray = [keshi.remark_ids componentsSeparatedByString:@","];
    }
    //NSArray *remarkArray = [keshi.remark_ids componentsSeparatedByString:@","];
    //remarkArray = [[NSArray alloc] initWithObjects:@"1234567890qwertyu", @"1234567890qwertyu", @"1234567890qwertyu", @"1234567890qwertyu", @"1234567890qwertyu", @"1234567890qwertyu", @"1234567890qwertyu", @"1234567890qwertyu", @"1234567890qwertyu", @"1234567890qwertyu", @"1234567890qwertyu", nil];
    scrollView.contentSize = CGSizeMake(self.tableView.frame.size.width - 142, 88);
    CGFloat originX = 15.0;
    CGFloat originY = 6.0;
    if (remarkArray.count > 0)
    {
        for (int i = 0; i < remarkArray.count; i++)
        {
            if ([[self remarkIdToName:remarkArray[i]] isEqualToString:@""])
            {
                continue;
            }
            CGFloat textWidth = [[self remarkIdToName:remarkArray[i]] boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width + 15;
            if ( originX + textWidth > scrollView.bounds.size.width)
            {
                originY = originY + 26;
                originX = 15.0;
            }
            UIButton *remarkButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, textWidth, 20)];
            remarkButton.layer.borderWidth = 1.0;
            remarkButton.layer.cornerRadius = 10;
            remarkButton.layer.borderColor = [COLOR(149, 171, 171, 1) CGColor];
            [remarkButton setTitleColor:COLOR(149, 171, 171, 1) forState:UIControlStateNormal];
            [remarkButton setTitle:[self remarkIdToName:remarkArray[i]] forState:UIControlStateNormal];
            remarkButton.titleLabel.font = [UIFont systemFontOfSize:12];
            remarkButton.tag = 8000 + i;
            [self.remarkTagDict setObject:[self remarkIdToName:remarkArray[i]] forKey:[NSString stringWithFormat:@"%d", remarkButton.tag]];
            [remarkButton addTarget:self action:@selector(remarkSelect:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:remarkButton];
            originX = originX + textWidth + 6;
        }
    }
    [bgView addSubview:scrollView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(70, 250, 300, 20)];
    label.text = @"财务备注";
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = COLOR(153, 174, 175,1);
    label.backgroundColor = [UIColor clearColor];
    [bgView addSubview:label];
    
    textField = [[UITextView alloc] initWithFrame:CGRectMake(70, 290, self.view.frame.size.width - 140, 180)];
    textField.delegate = self;
    textField.tag = 3002;
    textField.layer.borderColor = COLOR(234, 234, 234, 1).CGColor;
    textField.layer.borderWidth = 1;
    textField.layer.masksToBounds = TRUE;
    textField.text = self.operate.note;
    [bgView addSubview:textField];
    
    self.tableView.tableFooterView = bgView;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ( textView.tag == 3001 )
    {
        [self.tableView setContentOffset:CGPointMake(0, 420)];
    }
    else if ( textView.tag == 3002 )
    {
        [self.tableView setContentOffset:CGPointMake(0, 650)];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ( textView.tag == 3001 )
    {
        self.operate.remark = textView.text;
    }
    else if ( textView.tag == 3002 )
    {
        self.operate.note = textView.text;
    }
    
    [[BSCoreDataManager currentManager] save:nil];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ( textView.tag == 3001 )
    {
        self.operate.remark = textView.text;
    }
    else if ( textView.tag == 3002 )
    {
        self.operate.note = textView.text;
    }
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ( [notification.name isEqualToString:kBSFetchKeshiResponse] )
    {
        self.firstKeshiArray = [[BSCoreDataManager currentManager] fetchTopKeshi];
        [self.tableView reloadData];
    }
    else if ( [notification.name isEqualToString:kBSFetchStaffResponse] )
    {
        self.shgejishiArray = [[BSCoreDataManager currentManager] fetchShejishiStaffsWithShopID:self.shopID];
        self.shejizongjianArray = [[BSCoreDataManager currentManager] fetchShejizongjianStaffsWithShopID:self.shopID];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (currentFirstKeshi >=0 ? 2 : 1) + 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 )
    {
        if ( first_keshi_expand )
        {
            return self.firstKeshiArray.count + 1;
        }
    }
    else if ( section == 1  )
    {
        if ( currentFirstKeshi >= 0 )
        {
            if ( second_keshi_expand )
            {
                return self.secondKeshiArray.count + 1;
            }

        }
        else
        {
            if ( guwen_expand )
            {
                return self.guwenArray.count + 2;
            }
        }
    }
    else if ( section == 2 )
    {
        if ( currentFirstKeshi >= 0 )
        {
            if ( guwen_expand )
            {
                return self.guwenArray.count + 2;
            }
            
        }
        else
        {
            if ( shejishi_expand )
            {
                return self.shgejishiArray.count + 2;
            }
        }
    }
    else if ( section == 3 )
    {
        if ( currentFirstKeshi >= 0 )
        {
            if ( shejishi_expand )
            {
                return self.shgejishiArray.count + 2;
            }
            
        }
        else
        {
            if ( shejizongjian_expand )
            {
                return self.shejizongjianArray.count + 2;
            }
        }
    }
    else if ( section == 4 )
    {
        if ( shejizongjian_expand )
        {
            return self.shejizongjianArray.count + 2;
        }
    }

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, self.tableView.frame.size.width - 140, 60)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 101;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView* backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 0, self.tableView.frame.size.width - 140, 60)];
        backgroundImageView.tag = 102;
        [cell.contentView addSubview:backgroundImageView];
        [cell.contentView addSubview:label];
    }
    
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:101];
    
    int maxRow = 0;
    
    if ( indexPath.section == 0 )
    {
        if ( first_keshi_expand)
        {
            maxRow = self.firstKeshiArray.count;
        }
        
        if ( row != 0 )
        {
            CDKeShi* keshi = self.firstKeshiArray[indexPath.row - 1];
            nameLabel.text = keshi.name;
        }
        else
        {
            if ( currentFirstKeshi >= 0 )
            {
                CDKeShi* keshi = self.firstKeshiArray[currentFirstKeshi];
                nameLabel.text = keshi.name;
            }
            else
            {
                nameLabel.text = @"请选择...";
            }
        }
    }
    else if ( indexPath.section == 1 )
    {
        if ( currentFirstKeshi >= 0 )
        {
            if ( second_keshi_expand)
            {
                maxRow = self.secondKeshiArray.count;
            }
            
            if ( row != 0 )
            {
                CDStaff* keshi = self.secondKeshiArray[indexPath.row - 1];
                nameLabel.text = keshi.name;
            }
            else
            {
                if ( currentSecondKeshi >= 0 )
                {
                    CDStaff* keshi = self.secondKeshiArray[currentSecondKeshi];
                    nameLabel.text = keshi.name;
                }
                else
                {
                    nameLabel.text = @"请选择...";
                }
            }
        }
        else
        {
            if ( guwen_expand)
            {
                maxRow = self.guwenArray.count + 1;
            }
            
            if ( row != 0 )
            {
                if ( row == 1 )
                {
                    nameLabel.text = @"无";
                }
                else
                {
                    CDStaff* staff = self.guwenArray[indexPath.row - 2];
                    nameLabel.text = staff.name;
                }
            }
            else
            {
                if ( currentGuwen >= 0 )
                {
                    CDStaff* staff = self.guwenArray[currentGuwen];
                    nameLabel.text = staff.name;
                }
                else
                {
                    nameLabel.text = @"请选择...";
                }
            }
        }
    }
    else if ( indexPath.section == 2 )
    {
        if ( currentFirstKeshi >= 0 )
        {
            if ( guwen_expand)
            {
                maxRow = self.guwenArray.count + 1;
            }
            
            if ( row != 0 )
            {
                if ( row == 1 )
                {
                    nameLabel.text = @"无";
                }
                else
                {
                    CDStaff* staff = self.guwenArray[indexPath.row - 2];
                    nameLabel.text = staff.name;
                }
            }
            else
            {
                if ( currentGuwen >= 0 )
                {
                    CDStaff* staff = self.guwenArray[currentGuwen];
                    nameLabel.text = staff.name;
                }
                else
                {
                    nameLabel.text = @"请选择...";
                }
            }
        }
        else
        {
            if ( shejishi_expand)
            {
                maxRow = self.shgejishiArray.count + 1;
            }
            
            if ( row != 0 )
            {
                if ( row == 1 )
                {
                    nameLabel.text = @"无";
                }
                else
                {
                    CDStaff* staff = self.shgejishiArray[indexPath.row - 2];
                    nameLabel.text = staff.name;
                }
            }
            else
            {
                if ( currentShejishi >= 0 )
                {
                    CDStaff* staff = self.shgejishiArray[currentShejishi];
                    nameLabel.text = staff.name;
                }
                else
                {
                    nameLabel.text = @"请选择...";
                }
            }
        }
    }
    else if ( indexPath.section == 3 )
    {
        if ( currentFirstKeshi >= 0 )
        {
            if ( shejishi_expand )
            {
                maxRow = self.shgejishiArray.count + 1;
            }
            
            if ( row != 0 )
            {
                if ( row == 1 )
                {
                    nameLabel.text = @"无";
                }
                else
                {
                    CDStaff* staff = self.shgejishiArray[indexPath.row - 2];
                    nameLabel.text = staff.name;
                }
            }
            else
            {
                if ( currentShejishi >= 0 )
                {
                    CDStaff* staff = self.shgejishiArray[currentShejishi];
                    nameLabel.text = staff.name;
                }
                else
                {
                    nameLabel.text = @"请选择...";
                }
            }
        }
        else
        {
            if ( shejizongjian_expand)
            {
                maxRow = self.shejizongjianArray.count + 1;
            }
            
            if ( row != 0 )
            {
                if ( row == 1 )
                {
                    nameLabel.text = @"无";
                }
                else
                {
                    CDStaff* staff = self.shejizongjianArray[indexPath.row - 2];
                    nameLabel.text = staff.name;
                }
            }
            else
            {
                if ( currentShejizongjian >= 0 )
                {
                    CDStaff* staff = self.shejizongjianArray[currentShejizongjian];
                    nameLabel.text = staff.name;
                }
                else
                {
                    nameLabel.text = @"请选择...";
                }
            }
        }
    }
    else
    {
        if ( shejizongjian_expand)
        {
            maxRow = self.shejizongjianArray.count + 1;
        }
        
        if ( row != 0 )
        {
            if ( row == 1 )
            {
                nameLabel.text = @"无";
            }
            else
            {
                CDStaff* staff = self.shejizongjianArray[indexPath.row - 2];
                nameLabel.text = staff.name;
            }
        }
        else
        {
            if ( currentShejizongjian >= 0 )
            {
                CDStaff* staff = self.shejizongjianArray[currentShejizongjian];
                nameLabel.text = staff.name;
            }
            else
            {
                nameLabel.text = @"请选择...";
            }
        }
    }
    
    [self cellBg:cell withRow:row minRow:0 maxRow:maxRow];
    
    return cell;
}

- (void)cellBg:(UITableViewCell *)cell withRow:(int)row minRow:(int)minRow maxRow:(int)maxRow
{
    UIImageView* backgroundImageView = (UIImageView*)[cell viewWithTag:102];
    if (minRow == maxRow) {
        backgroundImageView.image = [[UIImage imageNamed:@"pos_text_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
        return;
    }
    if (row == minRow) {
        backgroundImageView.image = [[UIImage imageNamed:@"pos_cell_bg_t.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
    }
    else if (row == maxRow)
    {
        backgroundImageView.image = [[UIImage imageNamed:@"pos_cell_bg_b.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
    }
    else
    {
        backgroundImageView.image = [[UIImage imageNamed:@"pos_cell_bg_m.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
    }
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
        return 56;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v = [[UIView alloc] initWithFrame:CGRectZero];
    v.backgroundColor = [UIColor whiteColor];
    if ( section == 0 )
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 32, 300, 20)];
        label.text = @"科室";
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = COLOR(153, 174, 175,1);
        label.backgroundColor = [UIColor clearColor];
        [v addSubview:label];
    }
    else if ( section == 1 )
    {
        if ( currentFirstKeshi >= 0 )
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 19, 300, 20)];
            label.text = @"医生";
            label.font = [UIFont systemFontOfSize:18];
            label.textColor = COLOR(153, 174, 175,1);
            label.backgroundColor = [UIColor clearColor];
            [v addSubview:label];
        }
        else
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 19, 300, 20)];
            label.text = @"顾问";
            label.font = [UIFont systemFontOfSize:18];
            label.textColor = COLOR(153, 174, 175,1);
            label.backgroundColor = [UIColor clearColor];
            [v addSubview:label];
        }
    }
    else if ( section == 2 )
    {
        if ( currentFirstKeshi >= 0 )
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 19, 300, 20)];
            label.text = @"顾问";
            label.font = [UIFont systemFontOfSize:18];
            label.textColor = COLOR(153, 174, 175,1);
            label.backgroundColor = [UIColor clearColor];
            [v addSubview:label];
        }
        else
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 19, 300, 20)];
            label.text = @"设计师";
            label.font = [UIFont systemFontOfSize:18];
            label.textColor = COLOR(153, 174, 175,1);
            label.backgroundColor = [UIColor clearColor];
            [v addSubview:label];
        }
    }
    else if ( section == 3 )
    {
        if ( currentFirstKeshi >= 0 )
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 19, 300, 20)];
            label.text = @"设计师";
            label.font = [UIFont systemFontOfSize:18];
            label.textColor = COLOR(153, 174, 175,1);
            label.backgroundColor = [UIColor clearColor];
            [v addSubview:label];
        }
        else
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 19, 300, 20)];
            label.text = @"设计总监";
            label.font = [UIFont systemFontOfSize:18];
            label.textColor = COLOR(153, 174, 175,1);
            label.backgroundColor = [UIColor clearColor];
            [v addSubview:label];
        }
    }
    else
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 19, 300, 20)];
        label.text = @"设计总监";
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = COLOR(153, 174, 175,1);
        label.backgroundColor = [UIColor clearColor];
        [v addSubview:label];
    }
    
    return v;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if ( indexPath.section == 0 )
    {
        if ( row > 0 )
        {
            currentFirstKeshi = row - 1;
            currentSecondKeshi = -1;
            currentGuwen = -1;
            guwen_expand = FALSE;
            second_keshi_expand = FALSE;
            
            CDKeShi* keshi = self.firstKeshiArray[currentFirstKeshi];
            
            self.secondKeshiArray = keshi.staff.array;//[[BSCoreDataManager currentManager] fetchChildKeshi:keshi];
            [self setFooter];
            if ( tableView.numberOfSections == 3 )
            {
                //[self.tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
            }
            else
            {
                //[self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        
        first_keshi_expand = !first_keshi_expand;
        [self.tableView reloadData];
    }
    else if ( indexPath.section == 1 )
    {
        if ( currentFirstKeshi >= 0 )
        {
            if ( row > 0 )
            {
                currentSecondKeshi = row - 1;
            }
            
            second_keshi_expand = !second_keshi_expand;
            currentGuwen = -1;
            guwen_expand = FALSE;
            [self.tableView reloadData];
        }
        else
        {
            if ( row == 1 )
            {
                currentGuwen = -1;
            }
            else if ( row > 1 )
            {
                currentGuwen = row - 2;
            }
            
            guwen_expand = !guwen_expand;
            [self.tableView reloadData];
        }
    }
    else if ( indexPath.section == 2 )
    {
        if ( currentFirstKeshi >= 0 )
        {
//            CDKeShi* keshi = self.firstKeshiArray[currentFirstKeshi];
//            if ( ![keshi.is_display_adviser boolValue] )
//            {
//                return;
//            }
            
            if ( row == 1 )
            {
                currentGuwen = -1;
            }
            else if ( row > 1 )
            {
                currentGuwen = row - 2;
            }
            
            guwen_expand = !guwen_expand;
            [self.tableView reloadData];
        }
        else
        {
            [self didShejishiPressed];
            return;
            
            if ( row == 1 )
            {
                currentShejishi = -1;
            }
            else if ( row > 1 )
            {
                currentShejishi = row - 2;
            }
            
            shejishi_expand = !shejishi_expand;
            [self.tableView reloadData];
        }
    }
    else if ( indexPath.section == 3 )
    {
        if ( currentFirstKeshi >= 0 )
        {
            [self didShejishiPressed];
            return;
            if ( row == 1 )
            {
                currentShejishi = -1;
            }
            else if ( row > 1 )
            {
                currentShejishi = row - 2;
            }
            
            shejishi_expand = !shejishi_expand;
            [self.tableView reloadData];
        }
        else
        {
            [self didShejiZongjianPressed];
            return;
            if ( row == 1 )
            {
                currentShejizongjian = -1;
            }
            else if ( row > 1 )
            {
                currentShejizongjian = row - 1;
            }
            
            shejizongjian_expand = !shejizongjian_expand;
            [self.tableView reloadData];
        }
    }
    else
    {
        [self didShejiZongjianPressed];
        return;
        
        if ( row == 1 )
        {
            currentShejizongjian = -1;
        }
        else if ( row > 1 )
        {
            currentShejizongjian = row - 2;
        }
        
        shejizongjian_expand = !shejizongjian_expand;
        [self.tableView reloadData];
    }
}

- (IBAction)didCloseButtonPressed:(id)sender
{
    [self.maskView hidden];
}

- (IBAction)didOkButtonPressed:(id)sender
{
    if ( currentFirstKeshi == -1 )
    {
//        UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"请选择科室" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
//        [v show];
        [self.maskView hidden];
    }
    else
    {
        CDKeShi* keshi = self.firstKeshiArray[currentFirstKeshi];
        if ( [keshi.is_display_adviser boolValue] && currentGuwen == -1 )
        {
            UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"请选择顾问" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [v show];
            return;
        }
        
        if ( [keshi.is_display_designer boolValue] && currentShejishi == -1 )
        {
            UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"请选择设计师" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [v show];
            return;
        }
        
        CDStaff* staff = nil;
        if ( currentSecondKeshi >= 0 )
        {
            staff = self.secondKeshiArray[currentSecondKeshi];
        }

        if ( self.keshiSelectFinished )
        {
            if ( currentGuwen >= 0)
            {
                CDStaff* staff = self.guwenArray[currentGuwen];
                self.operate.yimei_guwenID = staff.staffID;
                self.operate.yimei_guwenName = staff.name;
            }
            
            if ( currentShejishi >= 0)
            {
                CDStaff* staff = self.shgejishiArray[currentShejishi];
                self.operate.yimei_shejishiID = staff.staffID;
                self.operate.yimei_shejishiName = staff.name;
            }
            
            if ( currentShejizongjian >= 0)
            {
                CDStaff* staff = self.shejizongjianArray[currentShejizongjian];
                self.operate.yimei_shejizongjianID = staff.staffID;
                self.operate.yimei_shejishiName = staff.name;
            }
            self.keshiSelectFinished(keshi, staff);
        }
        [self.maskView hidden];
    }
}

- (void)didShejishiPressed
{
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    
    WeakSelf;
    self.selectVC.countOfTheList = ^NSInteger{
        return weakSelf.shgejishiArray.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = weakSelf.shgejishiArray[index];
        return staff.name;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        currentShejishi = index;
        [weakSelf.tableView reloadData];
    };
    self.selectVC.rightInfoAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = weakSelf.shgejishiArray[index];
        return [NSString stringWithFormat:@"%@ %@",staff.work_location,staff.job_name];
    };
    
    [self.maskView addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (void)didShejiZongjianPressed
{
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    
    WeakSelf;
    self.selectVC.countOfTheList = ^NSInteger{
        return weakSelf.shejizongjianArray.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = weakSelf.shejizongjianArray[index];
        return staff.name;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        currentShejizongjian = index;
        [weakSelf.tableView reloadData];
    };
    self.selectVC.rightInfoAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = weakSelf.shejizongjianArray[index];
        return [NSString stringWithFormat:@"%@ %@",staff.work_location,staff.job_name];
    };
    
    [self.maskView addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (void)remarkSelect:(UIButton *)button
{
    UITextView *textView = [self.tableView viewWithTag:3001];
    textView.text = [NSString stringWithFormat:@"%@%@",textView.text, [self.remarkTagDict objectForKey:[NSString stringWithFormat:@"%d", button.tag]]];
    [textView becomeFirstResponder];
    self.operate.remark = textView.text;
    [self.tableView setContentOffset:CGPointMake(0, 420)];
}

- (NSString*)remarkIdToName:(NSString *)remarkId
{
    NSString *name = [[NSString alloc] init];
    for (CDKeshiRemarks *remark in self.keshiRemarkArray)
    {
        if([remark.remark_id integerValue] == [remarkId integerValue])
        {
            name = remark.remark_name;
        }
    }
    return name;
}
@end
