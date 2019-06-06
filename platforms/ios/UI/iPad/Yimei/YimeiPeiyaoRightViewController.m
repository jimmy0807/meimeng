//
//  YimeiPeiyaoRightViewController.m
//  meim
//
//  Created by jimmy on 2017/7/14.
//
//

#import "YimeiPeiyaoRightViewController.h"
#import "YimeiPeiyaoRightTableViewCell.h"
#import "SeletctListViewController.h"
#import "NSArray+JSON.h"
#import "EditWashHandRequest.h"
#import "CBLoadingView.h"

@interface YimeiPeiyaoRightViewController ()<UITextViewDelegate>
@property(nonatomic, weak)IBOutlet UITableView* tableView;
@property(nonatomic, strong)SeletctListViewController* selectVC;
@end

@implementation YimeiPeiyaoRightViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setFooter];
    
    [self.tableView registerNib:[UINib nibWithNibName: @"YimeiPeiyaoRightTableViewCell" bundle: nil] forCellReuseIdentifier:@"YimeiPeiyaoRightTableViewCell"];
    
    [self registerNofitificationForMainThread:kFetchWashHandDetailResponse];
    [self registerNofitificationForMainThread:kEditWashHandResponse];
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ( [notification.name isEqualToString:kFetchWashHandDetailResponse] )
    {
        [self.tableView reloadData];
    }
    else if ( [notification.name isEqualToString:kEditWashHandResponse] )
    {
        [[CBLoadingView shareLoadingView] hide];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 )
    {
        return self.washHand.chufang_items.count + 1;
    }
    else if ( section == 1 )
    {
        return self.washHand.feichufang_items.count + 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YimeiPeiyaoRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YimeiPeiyaoRightTableViewCell"];
    
    cell.isAddLine = indexPath.row == 0;
    [self cellBg:cell withRow:indexPath.row minRow:0 maxRow:4];
    
    if ( indexPath.section == 0 )
    {
        if ( indexPath.row > 0 )
        {
            cell.item = self.washHand.chufang_items[indexPath.row - 1];
        }
    }
    else if ( indexPath.section == 1 )
    {
        if ( indexPath.row > 0 )
        {
            cell.item = self.washHand.feichufang_items[indexPath.row - 1];
        }
    }
    
    return cell;
}

- (void)cellBg:(YimeiPeiyaoRightTableViewCell *)cell withRow:(int)row minRow:(int)minRow maxRow:(int)maxRow
{
    UIImageView* backgroundImageView = cell.backgroundImageView;
    
    if (minRow == maxRow)
    {
        backgroundImageView.image = [[UIImage imageNamed:@"pos_text_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
        return;
    }
    
    if (row == minRow)
    {
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
    return 65;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v = [[UIView alloc] initWithFrame:CGRectZero];
    v.backgroundColor = self.view.backgroundColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 34, 300, 18)];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = COLOR(164, 182, 182,1);
    label.backgroundColor = [UIColor clearColor];
    [v addSubview:label];
    
    if ( section == 0 )
    {
        label.text = @"处方药列表";
    }
    else if ( section == 1 )
    {
        label.text = @"非处方药列表";
    }
    else if ( section == 2 )
    {
        label.text = @"配药医嘱";
    }
    
    return v;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == 0 )
    {
        WeakSelf;
        NSArray* array = [[BSCoreDataManager currentManager] fetchPrescriptionsItems];
        
        self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
        self.selectVC.countOfTheList = ^NSInteger{
            return array.count;
        };
        self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
            CDProjectItem* item = array[index];
            return item.itemName;
        };
        self.selectVC.selectAtIndex = ^(NSInteger index) {
            CDProjectItem* projectItem = array[index];
            
            if ( [weakSelf checkIsConstainsItemID:projectItem.itemID section:indexPath.section] )
                return;
            
            CDMedicalItem* item = [[BSCoreDataManager currentManager] insertEntity:@"CDMedicalItem"];
            item.name = projectItem.itemName;
            item.itemID = projectItem.itemID;
            item.uomName = projectItem.uomName;
            item.uomID = projectItem.uomID;
            item.count = @(1);
            
            if ( indexPath.section == 0 )
            {
                item.is_prescription = @(TRUE);
                item.chufang = weakSelf.washHand;
            }
            else if ( indexPath.section == 1 )
            {
                item.is_prescription = @(FALSE);
                item.feichufang = weakSelf.washHand;
            }
            
            [weakSelf.tableView reloadData];
        };
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.selectVC.view];
        [self.selectVC showWithAnimation];
    }
}

- (BOOL)checkIsConstainsItemID:(NSNumber*)itemID section:(NSInteger)section
{
    NSOrderedSet* set = nil;
    if ( section == 0 )
    {
        set = self.washHand.chufang_items;
    }
    else
    {
        set = self.washHand.feichufang_items;
    }
    
    for ( CDMedicalItem* item in set )
    {
        if ( [item.itemID isEqual:itemID] )
        {
            return TRUE;
        }
    }
    
    return FALSE;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row > 0 )
    {
        return TRUE;
    }
    
    return FALSE;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if ( indexPath.section == 0 )
        {
            [self.washHand removeObjectFromChufang_itemsAtIndex:indexPath.row - 1];
        }
        else if ( indexPath.section == 1 )
        {
            [self.washHand removeObjectFromFeichufang_itemsAtIndex:indexPath.row - 1];
        }
        [self.tableView reloadData];
    }
}

- (IBAction)didConfirmButtonPressed:(id)sender
{
    NSMutableArray* array = [NSMutableArray array];
    
    for ( CDMedicalItem* item in self.washHand.chufang_items )
    {
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        [params setObject:item.count forKey:@"qty"];
        [params setObject:item.is_prescription forKey:@"is_prescription"];
        [params setObject:item.itemID forKey:@"product_id"];
        [params setObject:item.uomID forKey:@"uom_id"];
        [array addObject:params];
    }
    
    for ( CDMedicalItem* item in self.washHand.feichufang_items )
    {
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        [params setObject:item.count forKey:@"qty"];
        [params setObject:item.is_prescription forKey:@"is_prescription"];
        [params setObject:item.itemID forKey:@"product_id"];
        [params setObject:item.uomID forKey:@"uom_id"];
        [array addObject:params];
    }
    
    NSString* s = [array toJsonString];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.washHand.medical_note forKey:@"medical_note"];
    
    if ( s.length > 0 )
    {
        [params setObject:s forKey:@"prescriptions"];
        
        EditWashHandRequest* request = [[EditWashHandRequest alloc] init];
        request.params = params;
        request.notGoNext = YES;
        request.wash = self.washHand;
        [request execute];
    }
    
    [[CBLoadingView shareLoadingView] show];
}

- (void)setFooter
{
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 800)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 100, 20)];
    label.text = @"配药医嘱";
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = COLOR(164, 182, 182,1);
    label.backgroundColor = [UIColor clearColor];
    [bgView addSubview:label];
    
    UITextView* textField = [[UITextView alloc] initWithFrame:CGRectMake(0, 60, self.tableView.frame.size.width, 180)];
    textField.delegate = self;
    textField.layer.borderColor = COLOR(234, 234, 234, 1).CGColor;
    textField.layer.borderWidth = 1;
    textField.layer.masksToBounds = TRUE;
    textField.layer.cornerRadius = 3;
    [bgView addSubview:textField];
    //self.remarkTextField = textField;
    
    textField.text = self.washHand.medical_note;
    
    self.tableView.tableFooterView = bgView;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.washHand.medical_note = textView.text;
}

@end
