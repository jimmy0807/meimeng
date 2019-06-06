//
//  YimeiSelectOperateRightViewController.m
//  ds
//
//  Created by jimmy on 16/11/8.
//
//

#import "YimeiSelectOperateRightViewController.h"
#import "BSFetchStaffRequest.h"
#import "YimeiSelectOperateRightViewTableViewCell.h"
#import "SeletctListViewController.h"
#import "BSFetchMemberDetailReqeustN.h"
#import "HPatientZutaoSelectViewController.h"
#import "YimeiYaopinSelectViewController.h"
#import "EditWashHandRequest.h"
#import "HPatientAddCailiaoViewController.h"

@interface YimeiSelectOperateRightViewController ()<UITextViewDelegate>
{
    NSInteger currentSelectOperator;
}
@property(nonatomic, weak)IBOutlet UITableView* tableView;
@property(nonatomic, weak)IBOutlet UIButton* binglikaButton;
@property(nonatomic, strong)NSMutableArray* operatorArray;
@property(nonatomic, strong)NSMutableDictionary* operatorDictionary;
@property(nonatomic, strong)NSMutableDictionary* selectedDictionary;
@property(nonatomic, strong)NSNumber* shopID;
@property(nonatomic, strong)SeletctListViewController* selectVC;
@property(nonatomic, strong)UITextField* doctorNameTextField;
@property(nonatomic, strong)UITextField* peitaiNameTextField;
@property(nonatomic, strong)UITextField* xunhuiNameTextField;
@property(nonatomic, strong)UITextField* mazuiNameTextField;
@property(nonatomic, strong)UITextView* medicalNoteTextView;
@property(nonatomic, strong)NSMutableArray* recipeArray;
@property(nonatomic, strong)NSMutableArray* consumeArray;
@property (nonatomic, strong) PadMaskView *maskView;

@end

@implementation YimeiSelectOperateRightViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.shopID = [[PersonalProfile currentProfile].shopIds firstObject];
//    BSFetchStaffRequest *request = [[BSFetchStaffRequest alloc] init];
//    request.shopID = self.shopID;
//    [request execute];
    
    currentSelectOperator = -1;
    
//    CDKeShi* keshi = [[BSCoreDataManager currentManager] findEntity:@"CDKeShi" withValue:self.posOperate.keshi_id forKey:@"keshi_id"];
//    self.operatorArray = keshi.operate_machine.array;//[[BSCoreDataManager currentManager] fetchOperateStaffsWithShopID:self.shopID];
    [self fetchOperateArrray];
    
    self.selectedDictionary = [NSMutableDictionary dictionary];
    self.consumeArray = [NSMutableArray array];
    self.recipeArray = [NSMutableArray array];
    NSArray* currentSelectArray = [self.washHand.yimei_operate_employee_ids componentsSeparatedByString:@","];
    if ( currentSelectArray.count > 0 )
    {
        for ( NSString* n in currentSelectArray )
        {
            if ( [n isKindOfClass:[NSString class]] && [n integerValue] > 0 )
            {
                self.selectedDictionary[@([n integerValue])] = @(TRUE);
            }
            else if ( [n isKindOfClass:[NSNumber class]] && [n integerValue] > 0 )
            {
                self.selectedDictionary[n] = @(TRUE);
            }
        }
    }
    
    [self.tableView registerNib:[UINib nibWithNibName: @"YimeiSelectOperateRightViewTableViewCell" bundle: nil] forCellReuseIdentifier:@"YimeiSelectOperateRightViewTableViewCell"];
    
    [self registerNofitificationForMainThread:kBSFetchStaffResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberOperateResponse];
    [self registerNofitificationForMainThread:kFetchWashHandDetailResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberCardDetailResponse];
    [self registerNofitificationForMainThread:@"AddCailiaoFinished"];
    
    CDMember* member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:self.washHand.member_id forKey:@"memberID"];
    if ( member && [self.washHand.binglika_id integerValue] > 0 )
    {
        //self.binglikaButton.hidden = NO;
    }
    
    if ( !member )
    {
        BSFetchMemberDetailRequestN* request = [[BSFetchMemberDetailRequestN alloc] initWithMemberID:self.washHand.member_id];
        [request execute];
    }
    self.recipeArray = [[NSMutableArray alloc] init];
    if (self.washHand.prescriptions.length > 0)
    {
        self.recipeArray = [self.washHand.prescriptions componentsSeparatedByString:@","];
    }
    if (self.washHand.consumable_ids.length > 0)
    {
        self.consumeArray = [NSMutableArray arrayWithArray:[self.washHand.consumable_ids componentsSeparatedByString:@","]];
    }
    [self setHeader];
    [self setFooter];
    [self.tableView reloadData];
    self.maskView = [[PadMaskView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    
}

- (void)removeNoti
{
    [self removeNotificationOnMainThread:kBSFetchStaffResponse];
    [self removeNotificationOnMainThread:@"AddCailiaoFinished"];
    [self removeNotificationOnMainThread:kBSFetchMemberOperateResponse];
    [self removeNotificationOnMainThread:kFetchWashHandDetailResponse];
    [self removeNotificationOnMainThread:kBSFetchMemberCardDetailResponse];
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ( [notification.name isEqualToString:kBSFetchStaffResponse] )
    {
        [self fetchOperateArrray];
//        CDKeShi* keshi = [[BSCoreDataManager currentManager] findEntity:@"CDKeShi" withValue:self.posOperate.keshi_id forKey:@"keshi_id"];
//        self.operatorArray = keshi.operate_machine.array;//[[BSCoreDataManager currentManager] fetchOperateStaffsWithShopID:self.shopID];
        
        [self.tableView reloadData];
    }
    else if ( [notification.name isEqualToString:kBSFetchMemberOperateResponse] || [notification.name isEqualToString:kBSFetchMemberCardDetailResponse])
    {
        CDMember* member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:self.washHand.member_id forKey:@"memberID"];
        if ( member && [self.washHand.binglika_id integerValue] > 0 )
        {
            //self.binglikaButton.hidden = NO;
        }
    }
    else if ( [notification.name isEqualToString:kFetchWashHandDetailResponse] )
    {
        self.medicalNoteTextView.text = self.washHand.medical_note;
        self.selectedDictionary = [NSMutableDictionary dictionary];
        NSArray* currentSelectArray = [self.washHand.yimei_operate_employee_ids componentsSeparatedByString:@","];
        if ( currentSelectArray.count > 0 )
        {
            for ( NSString* n in currentSelectArray )
            {
                if ( [n isKindOfClass:[NSString class]] && [n integerValue] > 0 )
                {
                    self.selectedDictionary[@([n integerValue])] = @(TRUE);
                }
                else if ( [n isKindOfClass:[NSNumber class]] && [n integerValue] > 0 )
                {
                    self.selectedDictionary[n] = @(TRUE);
                }
            }
        }
        if (self.washHand.consumable_ids.length > 0)
        {
            self.consumeArray = [NSMutableArray arrayWithArray:[self.washHand.consumable_ids componentsSeparatedByString:@","]];
        }
        
        [self.tableView reloadData];
    }
    else if ( [notification.name isEqualToString:@"AddCailiaoFinished"] )
    {
        NSLog(@"%@",notification.userInfo);
        NSArray *newCailiaoArray = [notification.userInfo objectForKey:@"Cailiao"];
        if (newCailiaoArray.count > 0) {
            for (CDPosProduct *product in newCailiaoArray)
            {
                NSString *name = product.product_name;
                NSNumber *qty = product.product_qty;
                NSNumber *prodID = product.product_id;
                if ( self.washHand.consumable_ids.length > 0 )
                {
                    self.washHand.consumable_ids = [self.washHand.consumable_ids stringByAppendingString:[NSString stringWithFormat:@",%@@%@@%@@%@@%@", name, qty, qty, prodID, @0]];
                }
                else
                {
                    self.washHand.consumable_ids = [NSString stringWithFormat:@"%@@%@@%@@%@@%@", name, qty, qty, prodID, @0];
                }
                
                NSLog(@"%@", self.washHand.consumable_ids);
            }
            if (self.washHand.consumable_ids.length > 0)
            {
                self.consumeArray = [NSMutableArray arrayWithArray:[self.washHand.consumable_ids componentsSeparatedByString:@","]];
            }
            
            [self.tableView reloadData];
            self.washHand.consumable_ids = [self.consumeArray componentsJoinedByString:@","];
            [self updateWashHand];
        }
        
//        self.washHand.consumable_ids
    }
    
}

- (void)fetchOperateArrray
{
    self.operatorArray = [NSMutableArray array];
    self.operatorDictionary = [NSMutableDictionary dictionary];
    CDKeShi* keshi = [[BSCoreDataManager currentManager] findEntity:@"CDKeShi" withValue:self.washHand.keshi_id forKey:@"keshi_id"];
    NSArray* staffArray = keshi.operate_machine.array;
    if ( staffArray.count == 0 )
    {
        staffArray = [[BSCoreDataManager currentManager] fetchOperateStaffsWithShopID:self.shopID];
    }
    for ( CDStaff* staff in staffArray )
    {
        NSMutableArray* values = self.operatorDictionary[staff.work_location];
        if ( values == nil )
        {
            values = [NSMutableArray array];
            self.operatorDictionary[staff.work_location] = values;
            [self.operatorArray addObject:values];
        }
        
        [values addObject:staff];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.operatorArray.count + 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == self.operatorArray.count)
    {
        if (self.recipeArray.count == 0)
        {
            return 0;
        }
        return self.recipeArray.count+1;
    }
    else if (section == self.operatorArray.count+1)
    {
        return self.consumeArray.count+1;
    }
    else
    {
        NSArray* array = self.operatorArray[section];
        return (array.count  + 2 ) / 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if (indexPath.section < self.operatorArray.count) {
        YimeiSelectOperateRightViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YimeiSelectOperateRightViewTableViewCell"];
        NSArray* array = self.operatorArray[indexPath.section];
        
        for ( NSInteger i = 0; i < 3; i++ )
        {
            if ( row*3 + i < array.count )
            {
                CDStaff* staff = array[row*3 + i];
                BOOL isSelected = [self.selectedDictionary[staff.staffID] boolValue];
                
                if ( i == 0 )
                {
                    [cell.butotn1 setTitle:staff.name forState:UIControlStateNormal];
                    cell.tag1.hidden = !isSelected;
                }
                else if ( i == 1 )
                {
                    [cell.butotn2 setTitle:staff.name forState:UIControlStateNormal];
                    cell.tag2.hidden = !isSelected;
                }
                else if ( i == 2 )
                {
                    [cell.butotn3 setTitle:staff.name forState:UIControlStateNormal];
                    cell.tag3.hidden = !isSelected;
                }
            }
            else
            {
#if 1
                if ( i == 0 )
                {
                    [cell.butotn1 setTitle:@"" forState:UIControlStateNormal];
                    cell.tag1.hidden = TRUE;
                }
                else if ( i == 1 )
                {
                    [cell.butotn2 setTitle:@"" forState:UIControlStateNormal];
                    cell.tag2.hidden = TRUE;
                }
                else if ( i == 2 )
                {
                    [cell.butotn3 setTitle:@"" forState:UIControlStateNormal];
                    cell.tag3.hidden = TRUE;
                }
#endif
            }
        }
        
        __weak YimeiSelectOperateRightViewController* weakSelf = self;
        cell.selectedAtIndex = ^(NSInteger index) {
            if ( row*3 + index < array.count )
            {
                CDStaff* staff = array[row*3 + index];
                weakSelf.selectedDictionary[staff.staffID] = @(![weakSelf.selectedDictionary[staff.staffID] boolValue]);
                
                
                [tableView reloadData];
                [weakSelf resetOperate];
            }
        };
        
        if ( row == 0 )
        {
            cell.topLineImageView.hidden = NO;
        }
        else
        {
            cell.topLineImageView.hidden = YES;
        }
        
        cell.bottomImageView.hidden = NO;
        return cell;
    }
    else if (indexPath.section == self.operatorArray.count)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"RecipeCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        if (row == 0)
        {
            UILabel *recipeTitle = [[UILabel alloc] initWithFrame:CGRectMake(32, 20, 200, 20)];
            recipeTitle.text = @"手术用药";
            recipeTitle.textColor = COLOR(149, 171, 171, 1);
            [cell addSubview:recipeTitle];
            
            UIButton *addRecipe = [[UIButton alloc] initWithFrame:CGRectMake(450, 0, 120, 20)];
            [addRecipe setTitle:@"选择处方模板" forState:UIControlStateNormal];
            [addRecipe addTarget:self action:@selector(addRecipeClicked) forControlEvents:UIControlEventTouchUpInside];
            [addRecipe setTitleColor:COLOR(47, 143, 255, 1) forState:UIControlStateNormal];
            //[cell addSubview:addRecipe];
            
            UIView *createRecipeView = [[UIView alloc] initWithFrame:CGRectMake(32, 30, 540, 60)];
            createRecipeView.backgroundColor = [UIColor whiteColor];
            UIImageView *createImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
            createImageView.image = [UIImage imageNamed:@"pos_add"];
            [createRecipeView addSubview:createImageView];
            UILabel *createLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 20, 80, 20)];
            createLabel.text = @"添加";
            createLabel.textColor = COLOR(155, 155, 155, 1);
            [createRecipeView addSubview:createLabel];
            //[cell addSubview:createRecipeView];
        }
        else
        {
            UIView *whiteBgView = [[UIView alloc] initWithFrame:CGRectMake(32, 0, 540, 60)];
            whiteBgView.backgroundColor = [UIColor whiteColor];
            UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 540, 1)];
            topLine.backgroundColor = COLOR(236, 237, 237, 1);
            [whiteBgView addSubview:topLine];
            UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 60)];
            leftLine.backgroundColor = COLOR(236, 237, 237, 1);
            [whiteBgView addSubview:leftLine];
            UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(540, 0, 1, 60)];
            rightLine.backgroundColor = COLOR(236, 237, 237, 1);
            [whiteBgView addSubview:rightLine];
            UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 540, 1)];
            bottomLine.backgroundColor = COLOR(236, 237, 237, 1);
            [whiteBgView addSubview:bottomLine];
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 20)];
            nameLabel.text = [self.recipeArray[indexPath.row-1] componentsSeparatedByString:@"@"][0];
            nameLabel.font = [UIFont systemFontOfSize:16];
            nameLabel.textColor = COLOR(37, 37, 37, 0.6);
            [whiteBgView addSubview:nameLabel];
            UILabel *qtyLabel = [[UILabel alloc] initWithFrame:CGRectMake(320, 20, 200, 20)];
            qtyLabel.text = [self.recipeArray[indexPath.row-1] componentsSeparatedByString:@"@"][1];
            qtyLabel.font = [UIFont systemFontOfSize:16];
            qtyLabel.textAlignment = NSTextAlignmentRight;
            qtyLabel.textColor = COLOR(37, 37, 37, 0.6);
            [whiteBgView addSubview:qtyLabel];
            [cell addSubview:whiteBgView];
        }
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ConsumeCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        if (row == 0)
        {
            UILabel *consumeTitle = [[UILabel alloc] initWithFrame:CGRectMake(32, 20, 200, 20)];
            consumeTitle.text = @"材料";
            consumeTitle.textColor = COLOR(149, 171, 171, 1);
            [cell addSubview:consumeTitle];
            
            
            //[cell addSubview:addConsume];
            
            UIView *createConsumeView = [[UIView alloc] initWithFrame:CGRectMake(32, 60, 540, 60)];
            createConsumeView.backgroundColor = [UIColor whiteColor];
            UIImageView *createImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
            createImageView.image = [UIImage imageNamed:@"pos_add"];
            [createConsumeView addSubview:createImageView];
            UILabel *createLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 20, 80, 20)];
            createLabel.text = @"添加材料";
            createLabel.textColor = COLOR(155, 155, 155, 1);
            [createConsumeView addSubview:createLabel];
            
            UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 540, 1)];
            topLine.backgroundColor = COLOR(236, 237, 237, 1);
            [createConsumeView addSubview:topLine];
            UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 60)];
            leftLine.backgroundColor = COLOR(236, 237, 237, 1);
            [createConsumeView addSubview:leftLine];
            UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(540, 0, 1, 60)];
            rightLine.backgroundColor = COLOR(236, 237, 237, 1);
            [createConsumeView addSubview:rightLine];
            UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 540, 1)];
            bottomLine.backgroundColor = COLOR(236, 237, 237, 1);
            [createConsumeView addSubview:bottomLine];
            
            UIButton *addConsume = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 540, 60)];
            //[addConsume setTitle:@"选择处方模板" forState:UIControlStateNormal];
            [addConsume addTarget:self action:@selector(addCailiaoClicked) forControlEvents:UIControlEventTouchUpInside];
            [addConsume setTitleColor:COLOR(47, 143, 255, 1) forState:UIControlStateNormal];
            [createConsumeView addSubview:addConsume];
            [cell addSubview:createConsumeView];
        }
        else
        {
            UIView *whiteBgView = [[UIView alloc] initWithFrame:CGRectMake(32, 0, 540, 60)];
            whiteBgView.backgroundColor = [UIColor whiteColor];
            UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 540, 1)];
            topLine.backgroundColor = COLOR(236, 237, 237, 1);
            [whiteBgView addSubview:topLine];
            UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 60)];
            leftLine.backgroundColor = COLOR(236, 237, 237, 1);
            [whiteBgView addSubview:leftLine];
            UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(540, 0, 1, 60)];
            rightLine.backgroundColor = COLOR(236, 237, 237, 1);
            [whiteBgView addSubview:rightLine];
            UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 540, 1)];
            bottomLine.backgroundColor = COLOR(236, 237, 237, 1);
            [whiteBgView addSubview:bottomLine];
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 20)];
            if ( [self.consumeArray[indexPath.row-1] componentsSeparatedByString:@"@"].count > 1 )
            {
                nameLabel.text = [NSString stringWithFormat:@"%@ X%d",[self.consumeArray[indexPath.row-1] componentsSeparatedByString:@"@"][0],[[self.consumeArray[indexPath.row-1] componentsSeparatedByString:@"@"][1] intValue]];
                nameLabel.font = [UIFont systemFontOfSize:16];
                nameLabel.textColor = COLOR(37, 37, 37, 0.6);
                [whiteBgView addSubview:nameLabel];
                
                UIImageView *qtyChangeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(406, 14, 114, 32)];
                qtyChangeImageView.image = [UIImage imageNamed:@"pad_qty_change"];
                [whiteBgView addSubview:qtyChangeImageView];
                
                UILabel *qtyLabel = [[UILabel alloc] initWithFrame:CGRectMake(448, 20, 30, 20)];
                qtyLabel.text = [self.consumeArray[indexPath.row-1] componentsSeparatedByString:@"@"][2];
                qtyLabel.font = [UIFont systemFontOfSize:16];
                qtyLabel.textAlignment = NSTextAlignmentCenter;
                qtyLabel.textColor = COLOR(37, 37, 37, 0.6);
                [whiteBgView addSubview:qtyLabel];
                
                UIButton *minusButton = [[UIButton alloc] initWithFrame:CGRectMake(406, 14, 32, 32)];
                minusButton.tag = indexPath.row - 1;
                [minusButton addTarget:self action:@selector(minusQty:) forControlEvents:UIControlEventTouchUpInside];
                [whiteBgView addSubview:minusButton];
                
                UIButton *plusButton = [[UIButton alloc] initWithFrame:CGRectMake(488, 14, 32, 32)];
                plusButton.tag = indexPath.row - 1;
                [plusButton addTarget:self action:@selector(plusQty:) forControlEvents:UIControlEventTouchUpInside];
                [whiteBgView addSubview:plusButton];
                
                [cell addSubview:whiteBgView];
            }
        }
        
        return cell;
    }
    
}

- (void)minusQty:(UIButton *)button
{
    NSLog(@"%@",self.consumeArray[button.tag]);
    int qty = [[self.consumeArray[button.tag] componentsSeparatedByString:@"@"][2] intValue];
    if (qty > 0) {
        NSArray *detailArray = [self.consumeArray[button.tag] componentsSeparatedByString:@"@"];
        if ( detailArray.count > 3 )
        {
            NSMutableArray* a = [NSMutableArray arrayWithArray:self.consumeArray];
            [a replaceObjectAtIndex:button.tag withObject:[NSString stringWithFormat:@"%@@%@@%d@%@@%@",detailArray[0],detailArray[1],qty-1,detailArray[3],detailArray[4]]];
            
            self.consumeArray = a;
            
            //[self.consumeArray insertObject:[NSString stringWithFormat:@"%@@%@@%d@%@@%@",detailArray[0],detailArray[1],qty-1,detailArray[3],detailArray[4]] atIndex:button.tag];
            //[self.consumeArray removeObjectAtIndex:button.tag+1];
        }
    }
    self.washHand.consumable_ids = [self.consumeArray componentsJoinedByString:@","];
    NSLog(@"%@",self.consumeArray[button.tag]);
    [self updateWashHand];
    [self.tableView reloadData];
}

- (void)plusQty:(UIButton *)button
{
    NSLog(@"%@",self.consumeArray[button.tag]);
    int totalQty = [[self.consumeArray[button.tag] componentsSeparatedByString:@"@"][1] intValue];
    int qty = [[self.consumeArray[button.tag] componentsSeparatedByString:@"@"][2] intValue];
    //if (qty < totalQty) {
        NSArray *detailArray = [self.consumeArray[button.tag] componentsSeparatedByString:@"@"];
//        [self.consumeArray insertObject:;
//        [self.consumeArray removeObjectAtIndex:button.tag+1];
    NSMutableArray* a = [NSMutableArray arrayWithArray:self.consumeArray];
    [a replaceObjectAtIndex:button.tag withObject:[NSString stringWithFormat:@"%@@%@@%d@%@@%@",detailArray[0],detailArray[1],qty+1,detailArray[3],detailArray[4]]];
    
    self.consumeArray = a;
//        [self.consumeArray replaceObjectAtIndex:button.tag withObject:[NSString stringWithFormat:@"%@@%@@%d",detailArray[0],detailArray[1],qty+1]];
   // }
    NSLog(@"%@",self.consumeArray[button.tag]);
    self.washHand.consumable_ids = [self.consumeArray componentsJoinedByString:@","];
    [self updateWashHand];
    [self.tableView reloadData];
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
    if (indexPath.row == 0 && indexPath.section == self.operatorArray.count + 1)
    {
        return 120;
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == self.operatorArray.count)
    {
        return 1;
//        if (self.recipeArray.count == 0)
//        {
//            return 0;
//        }
//        else
//        {
//            return 28;
//        }
    }
    else if (section == self.operatorArray.count + 1)
    {
        return 1;
    }
    return 58;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v = [[UIView alloc] initWithFrame:CGRectZero];
    v.backgroundColor = [UIColor clearColor];
    if (section < self.operatorArray.count) {
        CDStaff* staff = self.operatorArray[section][0];
        //if ( section == 0 )
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(49, 19, 250, 20)];
            label.text = staff.work_location;
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = COLOR(153, 174, 175,1);
            label.backgroundColor = [UIColor clearColor];
            [v addSubview:label];
        }
    }
    return v;
}

- (void)resetOperate
{
    NSMutableArray* array = [NSMutableArray array];
    for ( NSNumber* n in self.selectedDictionary.allKeys )
    {
        BOOL b = [self.selectedDictionary[n] boolValue];
        if ( b )
        {
            [array addObject:n];
        }
    }
    
    self.washHand.yimei_operate_employee_ids = [array componentsJoinedByString:@","];
    self.medicalNoteTextView.text = self.washHand.medical_note;
    
//    EditWashHandRequest* request = [[EditWashHandRequest alloc] init];
//    request.notGoNext = YES;
//    request.wash = self.washHand;
//    [request execute];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if ( indexPath.section == 0 && indexPath.row ==0 )
//    {
//        UIViewController *viewController = nil;
//        YimeiYaopinSelectViewController *returnItemViewController = [[YimeiYaopinSelectViewController alloc] initWithMemberCard:nil couponCard:nil];
//        returnItemViewController.maskView = self.maskView;
//        viewController = (UIViewController *)returnItemViewController;
//        if (viewController)
//        {
//            self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
//            self.maskView.navi.navigationBarHidden = YES;
//            self.maskView.navi.view.frame = CGRectMake(kPadMaskViewLeftWidth, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
//            [self.maskView addSubview:self.maskView.navi.view];
//            [self.maskView show];
//        }
//    }
//    if ( indexPath.section == 0 )
//    {
//        if ( indexPath.row == currentSelectOperator )
//        {
//            currentSelectOperator = -1;
//            self.posOperate.yimei_operate_employee_id = @(0);
//            self.posOperate.yimei_operate_employee_name = @"";
//            
//            [tableView reloadData];
//            
//            return;
//        }
//        
//        currentSelectOperator = indexPath.row;
//        
//        CDStaff* staff = self.operatorArray[currentSelectOperator];
//        self.posOperate.yimei_operate_employee_id = staff.staffID;
//        self.posOperate.yimei_operate_employee_name = staff.name;
//        
//        [tableView reloadData];
//    }
}

- (void)addRecipeClicked
{
    UIViewController *viewController = nil;
    HPatientZutaoSelectViewController *returnItemViewController = [[HPatientZutaoSelectViewController alloc] initWithMemberCard:nil couponCard:nil];
    returnItemViewController.maskView = self.maskView;
    viewController = (UIViewController *)returnItemViewController;
    if (viewController)
    {
        self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
        self.maskView.navi.navigationBarHidden = YES;
        self.maskView.navi.view.frame = CGRectMake(kPadMaskViewLeftWidth, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
        [self.maskView addSubview:self.maskView.navi.view];
        [self.maskView show];
    }
}

- (void)addCailiaoClicked
{
    UIViewController *viewController = nil;
    HPatientAddCailiaoViewController *returnItemViewController = [[HPatientAddCailiaoViewController alloc] initWithMemberCard:nil couponCard:nil];
    returnItemViewController.maskView = self.maskView;
    viewController = (UIViewController *)returnItemViewController;
    if (viewController)
    {
        self.maskView.navi = [[CBRotateNavigationController alloc] initWithRootViewController:viewController];
        self.maskView.navi.navigationBarHidden = YES;
        self.maskView.navi.view.frame = CGRectMake(kPadMaskViewLeftWidth, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
        [self.maskView addSubview:self.maskView.navi.view];
        [self.maskView show];
    }
}

- (void)updateWashHand
{
//    EditWashHandRequest* request = [[EditWashHandRequest alloc] init];
//    request.notGoNext = YES;
//    request.wash = self.washHand;
//    [request execute];
}

- (IBAction)didWriteBinglikaButtonPressed:(id)sender
{
    self.writeBinglikaButtonPressed();
}

- (void)setHeader
{
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 250)];
    
    UIView *staffView = [[UIView alloc] initWithFrame:CGRectMake(32, 20, self.tableView.frame.size.width-64, 240)];
    staffView.backgroundColor = [UIColor whiteColor];
    staffView.layer.borderWidth = 1;
    staffView.layer.borderColor = COLOR(236, 237, 237, 1).CGColor;
    staffView.layer.cornerRadius = 6;
    staffView.clipsToBounds = YES;
    
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 20)];
    title1.text = @"手术医生";
    title1.textColor = COLOR(37, 37, 37, 1);
    title1.font = [UIFont systemFontOfSize:16];

    UITextField *label1 = [[UITextField alloc] initWithFrame:CGRectMake(staffView.frame.size.width - 200, 0, 150, 60)];
    label1.backgroundColor = [UIColor clearColor];
    label1.font = [UIFont systemFontOfSize:16];
    label1.textAlignment = NSTextAlignmentRight;
    label1.textColor = COLOR(37, 37, 37, 1);
    label1.placeholder = @"请选择医生";
    label1.enabled = NO;
    self.doctorNameTextField = label1;
    label1.text = self.washHand.doctor_name;
    
    UIImageView* backgroundImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, staffView.frame.size.width, 60)];
    backgroundImageView1.backgroundColor = [UIColor whiteColor];
    backgroundImageView1.layer.cornerRadius = 3;
    backgroundImageView1.layer.masksToBounds = YES;
    
    UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, staffView.frame.size.width, 60);
    [btn1 addTarget:self action:@selector(didDoctorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *arrowImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(staffView.frame.size.width - 35, 20, 12, 21)];
    arrowImageView1.image = [UIImage imageNamed:@"Pad_Home_history_arrow"];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 59, self.tableView.frame.size.width - 64, 1)];
    line1.backgroundColor = COLOR(236, 237, 237, 1);
    [staffView addSubview:backgroundImageView1];
    [staffView addSubview:title1];
    [staffView addSubview:label1];
    [staffView addSubview:line1];
    [staffView addSubview:arrowImageView1];
    [staffView addSubview:btn1];
    
    UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 200, 20)];
    title2.text = @"配台护士";
    title2.textColor = COLOR(37, 37, 37, 1);
    title2.font = [UIFont systemFontOfSize:16];
    
    UITextField *label2 = [[UITextField alloc] initWithFrame:CGRectMake(staffView.frame.size.width - 200, 60, 150, 60)];
    label2.backgroundColor = [UIColor clearColor];
    label2.font = [UIFont systemFontOfSize:16];
    label2.textAlignment = NSTextAlignmentRight;
    label2.textColor = COLOR(37, 37, 37, 1);
    label2.placeholder = @"请选择护士";
    label2.enabled = NO;
    self.peitaiNameTextField = label2;
    label2.text = self.washHand.peitai_nurse_name;
    
    UIImageView* backgroundImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, staffView.frame.size.width, 60)];
    backgroundImageView2.backgroundColor = [UIColor whiteColor];
    backgroundImageView2.layer.cornerRadius = 3;
    backgroundImageView2.layer.masksToBounds = YES;
    
    UIButton* btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, 60, staffView.frame.size.width, 60);
    [btn2 addTarget:self action:@selector(didPeitaiButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *arrowImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(staffView.frame.size.width - 35, 80, 12, 21)];
    arrowImageView2.image = [UIImage imageNamed:@"Pad_Home_history_arrow"];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 119, self.tableView.frame.size.width - 64, 1)];
    line2.backgroundColor = COLOR(236, 237, 237, 1);
    [staffView addSubview:backgroundImageView2];
    [staffView addSubview:title2];
    [staffView addSubview:label2];
    [staffView addSubview:line2];
    [staffView addSubview:arrowImageView2];
    [staffView addSubview:btn2];
    
    UILabel *title3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, 200, 20)];
    title3.text = @"巡回护士";
    title3.textColor = COLOR(37, 37, 37, 1);
    title3.font = [UIFont systemFontOfSize:16];
    
    UITextField *label3 = [[UITextField alloc] initWithFrame:CGRectMake(staffView.frame.size.width - 200, 120, 150, 60)];
    label3.backgroundColor = [UIColor clearColor];
    label3.font = [UIFont systemFontOfSize:16];
    label3.textAlignment = NSTextAlignmentRight;
    label3.textColor = COLOR(37, 37, 37, 1);
    label3.placeholder = @"请选择护士";
    label3.enabled = NO;
    self.xunhuiNameTextField = label3;
    label3.text = self.washHand.xunhui_nurse_name;
    
    UIImageView* backgroundImageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 120, staffView.frame.size.width, 60)];
    backgroundImageView3.backgroundColor = [UIColor whiteColor];
    backgroundImageView3.layer.cornerRadius = 3;
    backgroundImageView3.layer.masksToBounds = YES;
    
    UIButton* btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(0, 120, staffView.frame.size.width, 60);
    [btn3 addTarget:self action:@selector(didXunhuiButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *arrowImageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(staffView.frame.size.width - 35, 140, 12, 21)];
    arrowImageView3.image = [UIImage imageNamed:@"Pad_Home_history_arrow"];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 179, self.tableView.frame.size.width - 64, 1)];
    line3.backgroundColor = COLOR(236, 237, 237, 1);
    [staffView addSubview:backgroundImageView3];
    [staffView addSubview:title3];
    [staffView addSubview:label3];
    [staffView addSubview:line3];
    [staffView addSubview:arrowImageView3];
    [staffView addSubview:btn3];
    
    UILabel *title4 = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 200, 20)];
    title4.text = @"麻醉师";
    title4.textColor = COLOR(37, 37, 37, 1);
    title4.font = [UIFont systemFontOfSize:16];
    
    UITextField *label4 = [[UITextField alloc] initWithFrame:CGRectMake(staffView.frame.size.width - 200, 180, 150, 60)];
    label4.backgroundColor = [UIColor clearColor];
    label4.font = [UIFont systemFontOfSize:16];
    label4.textAlignment = NSTextAlignmentRight;
    label4.textColor = COLOR(37, 37, 37, 1);
    label4.placeholder = @"请选择麻醉师";
    label4.enabled = NO;
    self.mazuiNameTextField = label4;
    label4.text = self.washHand.anesthetist_name;
    
    UIImageView* backgroundImageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 180, staffView.frame.size.width, 60)];
    backgroundImageView4.backgroundColor = [UIColor whiteColor];
    backgroundImageView4.layer.cornerRadius = 3;
    backgroundImageView4.layer.masksToBounds = YES;
    
    UIButton* btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(0, 180, staffView.frame.size.width, 60);
    [btn4 addTarget:self action:@selector(didMazuiButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *arrowImageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(staffView.frame.size.width - 35, 200, 12, 21)];
    arrowImageView4.image = [UIImage imageNamed:@"Pad_Home_history_arrow"];
    
    [staffView addSubview:backgroundImageView4];
    [staffView addSubview:title4];
    [staffView addSubview:label4];
    [staffView addSubview:arrowImageView4];
    [staffView addSubview:btn4];

    [bgView addSubview:staffView];
    self.tableView.tableHeaderView = bgView;
}

- (void)didDoctorButtonPressed:(id)sender
{
    WeakSelf;
    NSArray* array = [[BSCoreDataManager currentManager] fetchDoctorStaffsWithShopID:[PersonalProfile currentProfile].bshopId];
    
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    self.selectVC.countOfTheList = ^NSInteger{
        return array.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = array[index];
        return staff.name;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        CDStaff* staff = array[index];
        weakSelf.doctorNameTextField.text = staff.name;
        weakSelf.washHand.doctor_id = staff.staffID;
//        EditWashHandRequest* request = [[EditWashHandRequest alloc] init];
//        request.notGoNext = YES;
//        request.wash = weakSelf.washHand;
//        [request execute];
    };
    self.selectVC.rightInfoAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = array[index];
        return [NSString stringWithFormat:@"%@ %@",staff.work_location,staff.job_name];
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (void)didPeitaiButtonPressed:(id)sender
{
    WeakSelf;
    NSArray* array = [[BSCoreDataManager currentManager] fetchOperateStaffsWithShopID:[PersonalProfile currentProfile].bshopId];
    
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    self.selectVC.countOfTheList = ^NSInteger{
        return array.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = array[index];
        return staff.name;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        CDStaff* staff = array[index];
        weakSelf.peitaiNameTextField.text = staff.name;
        weakSelf.washHand.peitai_nurse_id = staff.staffID;
//        EditWashHandRequest* request = [[EditWashHandRequest alloc] init];
//        request.notGoNext = YES;
//        request.wash = weakSelf.washHand;
//        [request execute];
    };
    self.selectVC.rightInfoAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = array[index];
        return [NSString stringWithFormat:@"%@ %@",staff.work_location,staff.job_name];
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (void)didXunhuiButtonPressed:(id)sender
{
    WeakSelf;
    NSArray* array = [[BSCoreDataManager currentManager] fetchOperateStaffsWithShopID:[PersonalProfile currentProfile].bshopId];
    
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    self.selectVC.countOfTheList = ^NSInteger{
        return array.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = array[index];
        return staff.name;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        CDStaff* staff = array[index];
        weakSelf.xunhuiNameTextField.text = staff.name;
        weakSelf.washHand.xunhui_nurse_id = staff.staffID;
//        EditWashHandRequest* request = [[EditWashHandRequest alloc] init];
//        request.notGoNext = YES;
//        request.wash = weakSelf.washHand;
//        [request execute];
    };
    self.selectVC.rightInfoAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = array[index];
        return [NSString stringWithFormat:@"%@ %@",staff.work_location,staff.job_name];
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (void)didMazuiButtonPressed:(id)sender
{
    WeakSelf;
    NSArray* array = [[BSCoreDataManager currentManager] fetchDoctorStaffsWithShopID:[PersonalProfile currentProfile].bshopId];
    
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    self.selectVC.countOfTheList = ^NSInteger{
        return array.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = array[index];
        return staff.name;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        CDStaff* staff = array[index];
        weakSelf.mazuiNameTextField.text = staff.name;
        weakSelf.washHand.anesthetist_id = staff.staffID;
//        EditWashHandRequest* request = [[EditWashHandRequest alloc] init];
//        request.notGoNext = YES;
//        request.wash = weakSelf.washHand;
//        [request execute];
    };
    self.selectVC.rightInfoAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = array[index];
        return [NSString stringWithFormat:@"%@ %@",staff.work_location,staff.job_name];
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (void)setFooter
{
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 400)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(32, 30, 100, 20)];
    label.text = @"医嘱";
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = COLOR(153, 174, 175,1);
    label.backgroundColor = [UIColor clearColor];
    [bgView addSubview:label];
    
    UITextView* textField = [[UITextView alloc] initWithFrame:CGRectMake(32, 60, self.tableView.frame.size.width - 64, 180)];
    textField.delegate = self;
    textField.layer.borderColor = COLOR(234, 234, 234, 1).CGColor;
    textField.layer.borderWidth = 1;
    textField.layer.masksToBounds = TRUE;
    [bgView addSubview:textField];
    self.medicalNoteTextView = textField;
    
    self.tableView.tableFooterView = bgView;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.washHand.medical_note = textView.text;
}

- (void)dealloc
{
    
}
@end
