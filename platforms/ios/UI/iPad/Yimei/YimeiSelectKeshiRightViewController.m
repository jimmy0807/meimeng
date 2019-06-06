//
//  YimeiSelectKeshiRightViewController.m
//  ds
//
//  Created by jimmy on 16/11/8.
//
//

#import "YimeiSelectKeshiRightViewController.h"
#import "FetchAllKeshiRequest.h"
#import "BSFetchStaffRequest.h"

@interface YimeiSelectKeshiRightViewController ()
{
    NSInteger currentFirstKeshi;
    NSInteger currentSecondKeshi;
    NSInteger currentDocotr;
}
@property(nonatomic, weak)IBOutlet UITableView* tableView;
@property(nonatomic, strong)NSArray* firstKeshiArray;
@property(nonatomic, strong)NSArray* secondKeshiArray;
@property(nonatomic, strong)NSArray* doctorArray;
@end

@implementation YimeiSelectKeshiRightViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSNumber* shopID = [[PersonalProfile currentProfile].shopIds firstObject];
//    BSFetchStaffRequest *request = [[BSFetchStaffRequest alloc] init];
//    request.shopID = shopID;
//    [request execute];
    
    currentFirstKeshi = -1;
    currentSecondKeshi = -1;
    currentDocotr = -1;
    
    //[[[FetchAllKeshiRequest alloc] init] execute];
    
    [self realodAllData];
    
    [self registerNofitificationForMainThread:kBSFetchKeshiResponse];
    [self registerNofitificationForMainThread:kBSFetchStaffResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberOperateResponse];
    [self registerNofitificationForMainThread:kFetchWashHandDetailResponse];
}

- (void)realodAllData
{
    currentFirstKeshi = -1;
    currentSecondKeshi = -1;
    currentDocotr = -1;
    self.firstKeshiArray = [[BSCoreDataManager currentManager] fetchTopKeshi];
    if ( self.washHand.keshi_id )
    {
        [self.firstKeshiArray enumerateObjectsUsingBlock:^(CDKeShi*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ( [obj.keshi_id isEqual:self.washHand.keshi_id] )
            {
                currentFirstKeshi = idx;
                *stop = TRUE;
            }
        }];
        
        if ( currentFirstKeshi >= 0 )
        {
            CDKeShi* keshi = self.firstKeshiArray[currentFirstKeshi];
            self.secondKeshiArray = [[BSCoreDataManager currentManager] fetchChildKeshi:keshi];
        }
        else
        {
            //如果只有二级的 先找一级的
            CDKeShi* k = [[BSCoreDataManager currentManager] findEntity:@"CDKeShi" withValue:self.washHand.keshi_id forKey:@"keshi_id"];
            if ( k )
            {
                [self.firstKeshiArray enumerateObjectsUsingBlock:^(CDKeShi*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ( [obj.keshi_id isEqual:k.parentID] )
                    {
                        currentFirstKeshi = idx;
                        *stop = TRUE;
                    }
                }];
            }
            
            if ( currentFirstKeshi >= 0 )
            {
                CDKeShi* keshi = self.firstKeshiArray[currentFirstKeshi];
                self.secondKeshiArray = [[BSCoreDataManager currentManager] fetchChildKeshi:keshi];
            }
            
            [self.secondKeshiArray enumerateObjectsUsingBlock:^(CDKeShi*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ( [obj.keshi_id isEqual:self.washHand.keshi_id] )
                {
                    currentSecondKeshi = idx;
                    *stop = TRUE;
                }
            }];
        }
        
        if ( currentSecondKeshi >= 0 && self.washHand.doctor_id )
        {
            CDKeShi* keshi = self.secondKeshiArray[currentSecondKeshi];
            self.doctorArray = keshi.staff.array;//[[BSCoreDataManager currentManager] fetchChildKeshi:keshi];
            
            [self.doctorArray enumerateObjectsUsingBlock:^(CDStaff*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ( [obj.staffID isEqual:self.washHand.doctor_id] )
                {
                    currentDocotr = idx;
                    *stop = TRUE;
                }
            }];
        }
        else if ( currentFirstKeshi >= 0 && self.washHand.doctor_id )
        {
            CDKeShi* keshi = self.firstKeshiArray[currentFirstKeshi];
            self.doctorArray = keshi.staff.array;//[[BSCoreDataManager currentManager] fetchChildKeshi:keshi];
            
            [self.doctorArray enumerateObjectsUsingBlock:^(CDStaff*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ( [obj.staffID isEqual:self.washHand.doctor_id] )
                {
                    currentDocotr = idx;
                    if ( obj.keshi.count > 0 )
                    {
                        __block BOOL isStop = FALSE;
                        for (CDKeShi* keshi in obj.keshi.allObjects )
                        {
                            [self.secondKeshiArray enumerateObjectsUsingBlock:^(CDKeShi*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                if ( [obj.keshi_id isEqual:keshi.keshi_id] )
                                {
                                    currentSecondKeshi = idx;
                                    self.washHand.keshi_id = keshi.keshi_id;
                                    *stop = TRUE;
                                    isStop = TRUE;
                                }
                            }];
                            
                            if ( isStop )
                            {
                                break;
                            }
                        }
                    }
                    
                    *stop = TRUE;
                }
            }];
        }
    }
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ( [notification.name isEqualToString:kBSFetchKeshiResponse] )
    {
        [self realodAllData];
        [self.tableView reloadData];
    }
    else if ( [notification.name isEqualToString:kBSFetchStaffResponse] )
    {
        [self.tableView reloadData];
    }
    else if ( [notification.name isEqualToString:kBSFetchMemberOperateResponse] )
    {
        [self realodAllData];
        [self.tableView reloadData];
    }
    else if ( [notification.name isEqualToString:kFetchWashHandDetailResponse] )
    {
        [self realodAllData];
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ( currentFirstKeshi >=0 )
    {
        CDKeShi* keshi = self.firstKeshiArray[currentFirstKeshi];
        NSArray* secondKeshiArray = [[BSCoreDataManager currentManager] fetchChildKeshi:keshi];
        if ( secondKeshiArray.count > 0 )
        {
            return 3;
        }
    }
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 )
    {
        return self.firstKeshiArray.count;
    }
    else if ( section == 1  )
    {
        if ( currentFirstKeshi >=0 )
        {
            CDKeShi* keshi = self.firstKeshiArray[currentFirstKeshi];
            NSArray* secondKeshiArray = [[BSCoreDataManager currentManager] fetchChildKeshi:keshi];
            if ( secondKeshiArray.count > 0 )
            {
                return secondKeshiArray.count;
            }
        }
        
        return self.doctorArray.count;
    }
    else if ( section == 2  )
    {
        return self.doctorArray.count;
    }
    
    return 0;
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
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(83, 0, self.tableView.frame.size.width - 140, 60)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = COLOR(186, 186, 186, 1);
        label.font = [UIFont systemFontOfSize:16];
        label.tag = 101;
        
        UIButton* selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        selectButton.adjustsImageWhenHighlighted = NO;
        selectButton.frame = CGRectMake(47, (60-22)/2, 22, 22);
        selectButton.tag = 103;
        selectButton.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView* backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(31, 0, self.tableView.frame.size.width - 62, 60)];
        backgroundImageView.tag = 102;
        [cell.contentView addSubview:backgroundImageView];
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:selectButton];
    }
    
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:101];
    
    int maxRow = 0;
    
    if ( indexPath.section == 0 )
    {
        CDKeShi* keshi = self.firstKeshiArray[row];
        nameLabel.text = keshi.name;
        maxRow = self.firstKeshiArray.count - 1;
        [self setSelected:currentFirstKeshi == indexPath.row cell:cell];
    }
    else if ( indexPath.section == 1 )
    {
        if ( currentFirstKeshi >=0 )
        {
            CDKeShi* keshi = self.firstKeshiArray[currentFirstKeshi];
            NSArray* secondKeshiArray = [[BSCoreDataManager currentManager] fetchChildKeshi:keshi];
            if ( secondKeshiArray.count > 0 )
            {
                CDKeShi* keshi = self.secondKeshiArray[row];
                nameLabel.text = keshi.name;
                maxRow = self.secondKeshiArray.count - 1;
                [self setSelected:currentSecondKeshi == indexPath.row cell:cell];
            }
            else
            {
                CDStaff* staff = self.doctorArray[row];
                nameLabel.text = staff.name;
                maxRow = self.doctorArray.count - 1;
                [self setSelected:currentDocotr == indexPath.row cell:cell];
            }
        }
        else
        {
            CDStaff* staff = self.doctorArray[row];
            nameLabel.text = staff.name;
            maxRow = self.doctorArray.count - 1;
            [self setSelected:currentDocotr == indexPath.row cell:cell];
        }
    }
    else if ( indexPath.section == 2 )
    {
        CDStaff* staff = self.doctorArray[row];
        nameLabel.text = staff.name;
        maxRow = self.doctorArray.count - 1;
        [self setSelected:currentDocotr == indexPath.row cell:cell];
    }
    
    [self cellBg:cell withRow:row minRow:0 maxRow:maxRow];
    
    return cell;
}

- (void)setSelected:(BOOL)selected indexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self setSelected:selected cell:cell];
}

- (void)setSelected:(BOOL)selected cell:(UITableViewCell*)cell
{
    UIButton* btn = (UIButton*)[cell.contentView viewWithTag:103];
    if ( selected )
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"yimei_blue_check_n"] forState:UIControlStateNormal];
    }
    else
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"yimei_blue_check_d"] forState:UIControlStateNormal];
    }
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
    return 58;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v = [[UIView alloc] initWithFrame:CGRectZero];
    v.backgroundColor = COLOR(242, 245, 245, 1);
    if ( section == 0 )
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(49, 19, 300, 20)];
        label.text = @"科室";
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = COLOR(153, 174, 175,1);
        label.backgroundColor = [UIColor clearColor];
        [v addSubview:label];
    }
    else if ( section == 1 )
    {
        if ( currentFirstKeshi >= 0 )
        {
            CDKeShi* keshi = self.firstKeshiArray[currentFirstKeshi];
            NSArray* secondKeshiArray = [[BSCoreDataManager currentManager] fetchChildKeshi:keshi];
            if ( secondKeshiArray.count > 0 )
            {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(49, 19, 300, 20)];
                label.text = @"二级科室";
                label.font = [UIFont systemFontOfSize:16];
                label.textColor = COLOR(153, 174, 175,1);
                label.backgroundColor = [UIColor clearColor];
                [v addSubview:label];
            }
            else
            {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(49, 19, 300, 20)];
                label.text = @"医生";
                label.font = [UIFont systemFontOfSize:16];
                label.textColor = COLOR(153, 174, 175,1);
                label.backgroundColor = [UIColor clearColor];
                [v addSubview:label];
            }
        }
    }
    else if ( section == 2 )
    {
        if ( currentFirstKeshi >= 0 || currentSecondKeshi >= 0 )
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(49, 19, 300, 20)];
            label.text = @"医生";
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = COLOR(153, 174, 175,1);
            label.backgroundColor = [UIColor clearColor];
            [v addSubview:label];
        }
    }
    
    return v;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 )
    {
        if ( indexPath.row == currentFirstKeshi )
        {
            return;
        }
        
        currentFirstKeshi = indexPath.row;
        currentSecondKeshi = -1;
        
        CDKeShi* keshi = self.firstKeshiArray[currentFirstKeshi];
        
        self.washHand.keshi_id = keshi.keshi_id;
        self.washHand.doctor_id = @(0);
        
        [self realodAllData];
        [tableView reloadData];
    }
    else if ( indexPath.section == 1 )
    {
        if ( currentFirstKeshi >= 0 )
        {
            CDKeShi* keshi = self.firstKeshiArray[currentFirstKeshi];
            NSArray* secondKeshiArray = [[BSCoreDataManager currentManager] fetchChildKeshi:keshi];
            if ( secondKeshiArray.count > 0 )
            {
                currentSecondKeshi = indexPath.row;
                CDKeShi* keshi = self.secondKeshiArray[currentSecondKeshi];
                self.washHand.keshi_id = keshi.keshi_id;
                self.washHand.doctor_id = @(0);
                currentDocotr = -1;
                [self realodAllData];
            }
            else
            {
                currentDocotr = indexPath.row;
                CDStaff* keshi = self.doctorArray[currentDocotr];
                self.washHand.doctor_id = keshi.staffID;
            }
        }
        
        
        [tableView reloadData];
    }
    else
    {
        currentDocotr = indexPath.row;
        CDStaff* keshi = self.doctorArray[currentDocotr];
        self.washHand.doctor_id = keshi.staffID;
        
        [tableView reloadData];
    }
}

@end
