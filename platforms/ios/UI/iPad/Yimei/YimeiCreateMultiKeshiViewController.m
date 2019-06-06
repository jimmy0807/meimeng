//
//  YimeiCreateMultiKeshiViewController.m
//  meim
//
//  Created by 波恩公司 on 2017/11/20.
//

#import "YimeiCreateMultiKeshiViewController.h"
#import "FetchAllKeshiRequest.h"
#import "MBProgressHUD.h"
#import "BSFetchStaffRequest.h"
#import "SeletctListViewController.h"

@interface YimeiCreateMultiKeshiViewController ()<UITextViewDelegate>
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
    NSInteger currentDoctor;
}
@property(nonatomic, weak)IBOutlet UITableView* tableView;
@property(nonatomic, strong)NSArray* firstKeshiArray;
@property(nonatomic, strong)NSArray* secondKeshiArray;
@property(nonatomic, strong)NSArray* shgejishiArray;
@property(nonatomic, strong)NSArray* guwenArray;
@property(nonatomic, strong)NSArray* shejizongjianArray;
@property(nonatomic, strong)NSNumber* shopID;
@property(nonatomic, strong)SeletctListViewController* selectVC;
@property(nonatomic, strong)NSMutableArray* keshiInfoArray;
@property(nonatomic, strong)NSMutableArray* needSelectKeshiArray;
@property(nonatomic, strong)NSMutableArray* needSelectedKeshiIds;
@property(nonatomic, strong)NSNumber* selectedKeshiId;
@property(nonatomic, strong)NSString* selectedKeshiName;
@property(nonatomic, strong)NSNumber* selectedDoctorId;
@property(nonatomic, strong)NSString* selectedRemark;
@property(nonatomic, strong)NSString* selectedRemarkLabelString;
@property(nonatomic, strong)NSArray* doctorArray;
@property(nonatomic, strong)NSMutableDictionary* remarkTagDict;
@property(nonatomic, strong)NSArray* keshiRemarkArray;

@end

@implementation YimeiCreateMultiKeshiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.productArray = [[NSMutableArray alloc] init];
        self.itemArray = [[NSMutableArray alloc] init];
    }
    return self;
}

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
    NSLog(@"%@",self.operate);
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
    
    self.keshiInfoArray = [[NSMutableArray alloc] init];
    self.needSelectKeshiArray = [[NSMutableArray alloc] init];
    self.needSelectedKeshiIds = [[NSMutableArray alloc] init];
    self.remarkTagDict = [[NSMutableDictionary alloc] init];
    NSMutableArray *operateArray = [[NSMutableArray alloc] init];
    NSLog(@"%@",self.operate);
    for (int i = 0; i < [self.operate.departmentids componentsSeparatedByString:@","].count; i++)
    {
        if ([self.operate.departmentids componentsSeparatedByString:@","].count == 0)
        {
            break;
        }
//        else if ([self.operate.departmentids componentsSeparatedByString:@","].count < self.productArray.count)
//        {
//            NSLog(@"不匹配");
//        }
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[self.operate.doctorids componentsSeparatedByString:@","][i] forKey:@"doctorID"];
        [dict setObject:[self.operate.productids componentsSeparatedByString:@","][i] forKey:@"productID"];
        [dict setObject:[self.operate.remark componentsSeparatedByString:@","][i] forKey:@"remark"];
        [dict setObject:[self.operate.departmentids componentsSeparatedByString:@","][i] forKey:@"keshiID"];
        [operateArray addObject:dict];
    }
    for (CDPosProduct *product in self.productArray)
    {
        NSNumber *keshiId = product.product.category.departments_id;
        if (product.product.departments_id != nil) {
            if ([product.product.departments_id intValue] != 0)
            {
                keshiId = product.product.departments_id;
            }
        }

        if ([keshiId intValue] == 0)
        {
            NSMutableDictionary *needSelectKeshiDict = [[NSMutableDictionary alloc] init];
            [needSelectKeshiDict setObject:product.product_name forKey:@"name"];
            //[needSelectKeshiDict setObject:product. forKey:@"id"];
            [self.needSelectKeshiArray addObject:product.product_name];
            [self.needSelectedKeshiIds addObject:product.product_id];
            continue;
        }
        for (CDKeShi *keshi in self.firstKeshiArray)
        {
            if (keshi.keshi_id.intValue == keshiId.intValue)
            {
                bool isNewKeshi = YES;
                for (NSMutableDictionary *dict in self.keshiInfoArray)
                {
                    if([[dict objectForKey:@"keshiID"] intValue] == keshiId.intValue)
                    {
                        [[dict objectForKey:@"keshiProducts"] addObject:product.product_name];
                        [[dict objectForKey:@"productID"] addObject:product.product_id];

                        isNewKeshi = NO;
                    }
                }
                if (isNewKeshi)
                {
                    NSMutableDictionary *newKeshi = [[NSMutableDictionary alloc] init];
                    [newKeshi setObject:keshiId forKey:@"keshiID"];
                    [newKeshi setObject:keshi.name forKey:@"keshiName"];
                    NSMutableArray *keshiProducts = [[NSMutableArray alloc] init];
                    [keshiProducts addObject:product.product_name];
                    [newKeshi setObject:keshiProducts forKey:@"keshiProducts"];
                    NSMutableArray *productId = [[NSMutableArray alloc] init];
                    [productId addObject:product.product_id];
                    [newKeshi setObject:productId forKey:@"productID"];
                    [newKeshi setObject:keshi forKey:@"keshi"];
                    [newKeshi setObject:@(false) forKey:@"doctorID"];
                    [newKeshi setObject:@"" forKey:@"remark"];
                    [newKeshi setObject:[keshi.remark_ids componentsSeparatedByString:@","] forKey:@"remark_ids"];
                    for (NSMutableDictionary *dict in operateArray)
                    {
                        if ([[dict objectForKey:@"keshiID"] intValue] == keshiId.intValue)
                        {
                            [newKeshi setObject:[dict objectForKey:@"remark"] forKey:@"remark"];
                            [newKeshi setObject:[dict objectForKey:@"doctorID"] forKey:@"doctorID"];
                            break;
                        }
                        [newKeshi setObject:@"" forKey:@"remark"];
                        [newKeshi setObject:@(false) forKey:@"doctorID"];
                    }
                    [self.keshiInfoArray addObject:newKeshi];
                }
            }
            
        }
    }
    for (CDCurrentUseItem *item in self.itemArray)
    {
        NSNumber *keshiId = item.projectItem.category.departments_id;
        if (item.projectItem.departments_id != nil) {
            if ([item.projectItem.departments_id intValue] != 0)
            {
                keshiId = item.projectItem.departments_id;
            }
        }
        if ([keshiId intValue] == 0)
        {
            NSMutableDictionary *needSelectKeshiDict = [[NSMutableDictionary alloc] init];
            [needSelectKeshiDict setObject:item.itemName forKey:@"name"];
            [self.needSelectKeshiArray addObject:item.itemName];
            [self.needSelectedKeshiIds addObject:item.itemID];
            continue;
        }
        for (CDKeShi *keshi in self.firstKeshiArray)
        {
            if (keshi.keshi_id.intValue == keshiId.intValue)
            {
                bool isNewKeshi = YES;
                for (NSMutableDictionary *dict in self.keshiInfoArray)
                {
                    if([[dict objectForKey:@"keshiID"] intValue] == keshiId.intValue)
                    {
                        [[dict objectForKey:@"keshiProducts"] addObject:item.itemName];
                        [[dict objectForKey:@"productID"] addObject:item.itemID];
                        isNewKeshi = NO;
                    }
                }
                if (isNewKeshi)
                {
                    NSMutableDictionary *newKeshi = [[NSMutableDictionary alloc] init];
                    [newKeshi setObject:keshiId forKey:@"keshiID"];
                    [newKeshi setObject:keshi.name forKey:@"keshiName"];
                    NSMutableArray *keshiProducts = [[NSMutableArray alloc] init];
                    [keshiProducts addObject:item.itemName];
                    [newKeshi setObject:keshiProducts forKey:@"keshiProducts"];
                    NSMutableArray *productId = [[NSMutableArray alloc] init];
                    [productId addObject:item.itemID];
                    [newKeshi setObject:productId forKey:@"productID"];
                    [newKeshi setObject:keshi forKey:@"keshi"];
                    [newKeshi setObject:@(false) forKey:@"doctorID"];
                    [newKeshi setObject:@"" forKey:@"remark"];
                    [newKeshi setObject:[keshi.remark_ids componentsSeparatedByString:@","] forKey:@"remark_ids"];
                    for (NSMutableDictionary *dict in operateArray)
                    {
                        if ([[dict objectForKey:@"keshiID"] intValue] == keshiId.intValue)
                        {
                            [newKeshi setObject:[dict objectForKey:@"remark"] forKey:@"remark"];
                            [newKeshi setObject:[dict objectForKey:@"doctorID"] forKey:@"doctorID"];
                            break;
                        }
                        [newKeshi setObject:@"" forKey:@"remark"];
                        [newKeshi setObject:@(false) forKey:@"doctorID"];
                    }
                    [self.keshiInfoArray addObject:newKeshi];
                }
            }
        }
    }
    if (operateArray.count >= self.keshiInfoArray.count)
    {
        for (int i = 0; i < self.keshiInfoArray.count; i++)
        {
            if([[operateArray[i] objectForKey:@"keshiID"] intValue] != [[self.keshiInfoArray[i] objectForKey:@"keshiID"] intValue])
            {
                BOOL isContaining = NO;
                for (NSNumber *prodID in [self.keshiInfoArray[i] objectForKey:@"productID"])
                {
                    if ([[operateArray[i] objectForKey:@"productID"] intValue] == [prodID intValue]) {
                        isContaining = YES;
//                        break;
                    }
                }
                if (!isContaining) {
                    break;
                }
                
                [self.keshiInfoArray[i] setObject:[operateArray[i] objectForKey:@"keshiID"] forKey:@"keshiID"];
                [self.keshiInfoArray[i] setObject:[operateArray[i] objectForKey:@"doctorID"] forKey:@"doctorID"];
                [self.keshiInfoArray[i] setObject:[operateArray[i] objectForKey:@"remark"] forKey:@"remark"];
                for (CDKeShi *keshi in self.firstKeshiArray)
                {
                    if (keshi.keshi_id.intValue == [[operateArray[i] objectForKey:@"keshiID"] intValue])
                        [self.keshiInfoArray[i] setObject:keshi.name forKey:@"keshiName"];
                }
            }
        }
    }
    if (operateArray.count >= self.keshiInfoArray.count && self.needSelectKeshiArray.count > 0 && operateArray.count > 0)
    {
//        for (NSMutableDictionary *dict in operateArray)
//        {
        NSMutableDictionary *dict = operateArray[operateArray.count-1];
            self.selectedKeshiId = [dict objectForKey:@"keshiID"];
            for (CDKeShi *keshi in self.firstKeshiArray)
            {
                if(keshi.keshi_id.integerValue == self.selectedKeshiId.integerValue)
                {
                    self.selectedKeshiName = keshi.name;
                    self.selectedRemarkLabelString = keshi.remark_ids;
                    break;
                }
                else
                {
                    self.selectedKeshiName = [[NSString alloc] init];
                }
            }
            self.selectedRemark = [[NSString alloc] initWithString:[dict objectForKey:@"remark"]];
            self.selectedDoctorId = [dict objectForKey:@"doctorID"];
//        }
    }
    else
    {
        self.selectedKeshiName = [[NSString alloc] init];
        self.selectedRemark = [[NSString alloc] init];
        self.selectedKeshiId = [NSNumber numberWithInt:0];
        self.selectedDoctorId = [NSNumber numberWithInt:0];
    }
    self.shopID = [[PersonalProfile currentProfile].shopIds firstObject];

    [self registerNofitificationForMainThread:kBSFetchStaffResponse];
    [self registerNofitificationForMainThread:kBSFetchKeshiResponse];
    [self setFooter];
}

- (void)setFooter
{
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 400)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 19, 300, 20)];
//    label.text = @"医生备注";
//    label.font = [UIFont systemFontOfSize:18];
//    label.textColor = COLOR(153, 174, 175,1);
//    label.backgroundColor = [UIColor clearColor];
//    [bgView addSubview:label];
    
    UITextView* textField = [[UITextView alloc] initWithFrame:CGRectMake(70, 49, self.view.frame.size.width - 140, 180)];
//    textField.delegate = self;
//    textField.layer.borderColor = COLOR(234, 234, 234, 1).CGColor;
//    textField.layer.borderWidth = 1;
//    textField.tag = 3001;
//    textField.layer.masksToBounds = TRUE;
//    textField.text = self.operate.remark;
//    [bgView addSubview:textField];
    
    
//    label = [[UILabel alloc] initWithFrame:CGRectMake(70, 19, 300, 20)];
    label.text = @"财务备注";
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = COLOR(153, 174, 175,1);
    label.backgroundColor = [UIColor clearColor];
    [bgView addSubview:label];
    
//    textField = [[UITextView alloc] initWithFrame:CGRectMake(70, 290, self.view.frame.size.width - 140, 180)];
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
    if ( textView.tag >= 5000 )
    {
        UILabel* label = (UILabel*)[self.tableView viewWithTag:(textView.tag-1000)];
        label.hidden = YES;
        [label setHidden:YES];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:textView.tag%10] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ( textView.tag >= 5000 )
    {
        if ([textView.text isEqualToString:@""] || [textView.text isEqualToString:@" "])
        {
            UILabel* label = (UILabel*)[self.tableView viewWithTag:(textView.tag-1000)];
            label.hidden = NO;
            [label setHidden:NO];
        }
        else
        {
            int selectKeshiSections = (self.needSelectKeshiArray.count > 0 ? 1 : 0) + self.keshiInfoArray.count;
            if ( textView.tag - 5000 == selectKeshiSections - 1 && self.needSelectKeshiArray.count != 0 )
            {
                self.selectedRemark = textView.text;
            }
            else if ( textView.tag - 5000 < selectKeshiSections - 1 || (textView.tag - 5000 == selectKeshiSections - 1 && self.needSelectKeshiArray.count == 0) )
            {
                [self.keshiInfoArray[textView.tag - 5000] setObject:textView.text forKey:@"remark"];
            }
            UILabel* label = (UILabel*)[self.tableView viewWithTag:(textView.tag-1000)];
            label.hidden = YES;
            [label setHidden:YES];
        }
    }
    else if ( textView.tag == 3001 )
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
    if ( textView.tag >= 5000 )
    {
        int selectKeshiSections = (self.needSelectKeshiArray.count > 0 ? 1 : 0) + self.keshiInfoArray.count;
        if ( textView.tag - 5000 == selectKeshiSections - 1 && self.needSelectKeshiArray.count != 0 )
        {
            self.selectedRemark = textView.text;
        }
        else if ( textView.tag - 5000 < selectKeshiSections || (textView.tag - 5000 == selectKeshiSections - 1 && self.needSelectKeshiArray.count == 0))
        {
            [self.keshiInfoArray[textView.tag - 5000] setObject:textView.text forKey:@"remark"];
        }
    }
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
    return 3 + (self.needSelectKeshiArray.count > 0 ? 1 : 0) + self.keshiInfoArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int selectKeshiSections = (self.needSelectKeshiArray.count > 0 ? 1 : 0) + self.keshiInfoArray.count;
    if ( section == selectKeshiSections - 1 && self.needSelectKeshiArray.count != 0 )
    {
        return 1;
    }
    else if ( section < selectKeshiSections - 1 )
    {
        return 1;
    }
//    else if ( section == 0 + selectKeshiSections)
//    {
//        if ( first_keshi_expand )
//        {
//            return self.firstKeshiArray.count + 1;
//        }
//    }
//    else if ( section == 0 + selectKeshiSections )
//    {
//        if ( currentFirstKeshi >= 0 )
//        {
//            if ( second_keshi_expand )
//            {
//                return self.secondKeshiArray.count + 1;
//            }
//
//        }
//        else
//        {
//            if ( guwen_expand )
//            {
//                return self.guwenArray.count + 2;
//            }
//        }
//    }
    else if ( section == 0 + selectKeshiSections)
    {
//        if ( currentFirstKeshi >= 0 )
//        {
            if ( guwen_expand )
            {
                return self.guwenArray.count + 2;
            }
            
//        }
//        else
//        {
//            if ( shejishi_expand )
//            {
//                return self.shgejishiArray.count + 2;
//            }
//        }
    }
    else if ( section == 1 + selectKeshiSections)
    {
//        if ( currentFirstKeshi >= 0 )
//        {
            if ( shejishi_expand )
            {
                return self.shgejishiArray.count + 2;
            }
            
//        }
//        else
//        {
//            if ( shejizongjian_expand )
//            {
//                return self.shejizongjianArray.count + 2;
//            }
//        }
    }
    else if ( section == 2 + selectKeshiSections)
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, self.tableView.frame.size.width - 140, 60)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 300 + indexPath.section;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView* backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 0, self.tableView.frame.size.width - 140, 60)];
        backgroundImageView.tag = 102;
        [cell.contentView addSubview:backgroundImageView];
        [cell.contentView addSubview:label];
    }
    else
    {
        for (UIView *sub in cell.contentView.subviews)
        {
            if (sub.tag >= 4000 && sub.tag < 5000)
            {
                [sub removeFromSuperview];
            }
            if (sub.tag >= 300 && sub.tag < 1000)
            {
                [sub removeFromSuperview];
            }
        }
    }
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:300 + indexPath.section];
    
    int maxRow = 0;
    int selectKeshiSections = (self.needSelectKeshiArray.count > 0 ? 1 : 0) + self.keshiInfoArray.count;
    if ( indexPath.section == selectKeshiSections - 1 && self.needSelectKeshiArray.count != 0 )
    {
        if ([self.selectedDoctorId intValue] != 0)
        {
            NSArray *doctorList = [[NSArray alloc] init];
            for (CDKeShi *keshi in self.firstKeshiArray)
            {
                if (keshi.keshi_id.intValue == [self.selectedKeshiId intValue])
                {
                    doctorList = keshi.staff.array;
                }
            }
            for (CDStaff *doctor in doctorList)
            {
                if (doctor.staffID.intValue == [self.selectedDoctorId intValue])
                {
                    nameLabel.text = doctor.name;
                }
            }
        }
        else
        {
            nameLabel.text = @"选择医生";
        }
        nameLabel.tag = 300 + indexPath.section;
        [cell.contentView addSubview:nameLabel];
    }
    else if ( indexPath.section < selectKeshiSections - 1  || (indexPath.section == selectKeshiSections - 1 && self.needSelectKeshiArray.count == 0) )
    {
        if ([[self.keshiInfoArray[indexPath.section] objectForKey:@"doctorID"] intValue] != 0)
        {
            NSArray *doctorList = [[NSArray alloc] init];
            for (CDKeShi *keshi in self.firstKeshiArray)
            {
                if (keshi.keshi_id.intValue == [[self.keshiInfoArray[indexPath.section] objectForKey:@"keshiID"] intValue])
                {
                    doctorList = keshi.staff.array;
                }
            }
            for (CDStaff *doctor in doctorList)
            {
                if (doctor.staffID.intValue == [[self.keshiInfoArray[indexPath.section] objectForKey:@"doctorID"] intValue])
                {
                    nameLabel.text = doctor.name;
                }
            }
        }
        else
        {
            nameLabel.text = @"选择医生";
        }
        nameLabel.tag = 300 + indexPath.section;
        [cell.contentView addSubview:nameLabel];
    }
//    else if ( indexPath.section == 0 + selectKeshiSections)
//    {
//        if ( first_keshi_expand)
//        {
//            maxRow = self.firstKeshiArray.count;
//        }
//
//        if ( row != 0 )
//        {
//            CDKeShi* keshi = self.firstKeshiArray[indexPath.row - 1];
//            nameLabel.text = keshi.name;
//        }
//        else
//        {
//            if ( currentFirstKeshi >= 0 )
//            {
//                CDKeShi* keshi = self.firstKeshiArray[currentFirstKeshi];
//                nameLabel.text = keshi.name;
//            }
//            else
//            {
//                nameLabel.text = @"请选择...";
//            }
//        }
//    }
//    else if ( indexPath.section == 0 + selectKeshiSections)
//    {
//        if ( currentFirstKeshi >= 0 )
//        {
//            if ( second_keshi_expand)
//            {
//                maxRow = self.secondKeshiArray.count;
//            }
//
//            if ( row != 0 )
//            {
//                CDStaff* keshi = self.secondKeshiArray[indexPath.row - 1];
//                nameLabel.text = keshi.name;
//            }
//            else
//            {
//                if ( currentSecondKeshi >= 0 )
//                {
//                    CDStaff* keshi = self.secondKeshiArray[currentSecondKeshi];
//                    nameLabel.text = keshi.name;
//                }
//                else
//                {
//                    nameLabel.text = @"请选择...";
//                }
//            }
//        }
//        else
//        {
//            if ( guwen_expand)
//            {
//                maxRow = self.guwenArray.count + 1;
//            }
//
//            if ( row != 0 )
//            {
//                if ( row == 1 )
//                {
//                    nameLabel.text = @"无";
//                }
//                else
//                {
//                    CDStaff* staff = self.guwenArray[indexPath.row - 2];
//                    nameLabel.text = staff.name;
//                }
//            }
//            else
//            {
//                if ( currentGuwen >= 0 )
//                {
//                    CDStaff* staff = self.guwenArray[currentGuwen];
//                    nameLabel.text = staff.name;
//                }
//                else
//                {
//                    nameLabel.text = @"请选择...";
//                }
//            }
//        }
//    }
    else if ( indexPath.section == 0 + selectKeshiSections)
    {
//        if ( currentFirstKeshi >= 0 )
//        {
        if (nameLabel == nil)
        {
            nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, self.tableView.frame.size.width - 140, 60)];
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.font = [UIFont systemFontOfSize:16];
            nameLabel.textAlignment = NSTextAlignmentCenter;
        }
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
//        }
//        else
//        {
//            if ( shejishi_expand)
//            {
//                maxRow = self.shgejishiArray.count + 1;
//            }
//
//            if ( row != 0 )
//            {
//                if ( row == 1 )
//                {
//                    nameLabel.text = @"无";
//                }
//                else
//                {
//                    CDStaff* staff = self.shgejishiArray[indexPath.row - 2];
//                    nameLabel.text = staff.name;
//                }
//            }
//            else
//            {
//                if ( currentShejishi >= 0 )
//                {
//                    CDStaff* staff = self.shgejishiArray[currentShejishi];
//                    nameLabel.text = staff.name;
//                }
//                else
//                {
//                    nameLabel.text = @"请选择...";
//                }
//            }
//        }
        nameLabel.tag = 500 + indexPath.section;
        [cell.contentView addSubview:nameLabel];
    }
    else if ( indexPath.section == 1 + selectKeshiSections)
    {
//        if ( currentFirstKeshi >= 0 )
//        {
        if (nameLabel == nil)
        {
            nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, self.tableView.frame.size.width - 140, 60)];
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.font = [UIFont systemFontOfSize:16];
            nameLabel.textAlignment = NSTextAlignmentCenter;
        }
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
//        }
//        else
//        {
//            if ( shejizongjian_expand)
//            {
//                maxRow = self.shejizongjianArray.count + 1;
//            }
//
//            if ( row != 0 )
//            {
//                if ( row == 1 )
//                {
//                    nameLabel.text = @"无";
//                }
//                else
//                {
//                    CDStaff* staff = self.shejizongjianArray[indexPath.row - 2];
//                    nameLabel.text = staff.name;
//                }
//            }
//            else
//            {
//                if ( currentShejizongjian >= 0 )
//                {
//                    CDStaff* staff = self.shejizongjianArray[currentShejizongjian];
//                    nameLabel.text = staff.name;
//                }
//                else
//                {
//                    nameLabel.text = @"请选择...";
//                }
//            }
//        }
        nameLabel.tag = 600 + indexPath.section;
        [cell.contentView addSubview:nameLabel];
    }
    else
    {
        if (nameLabel == nil)
        {
            nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, self.tableView.frame.size.width - 140, 60)];
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.font = [UIFont systemFontOfSize:16];
            nameLabel.textAlignment = NSTextAlignmentCenter;
        }
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
        nameLabel.tag = 700 + indexPath.section;
        [cell.contentView addSubview:nameLabel];
    }
    if ( indexPath.section == selectKeshiSections - 1 && self.needSelectKeshiArray.count != 0 )
    {
        
        UIImageView* backgroundImageView = (UIImageView*)[cell viewWithTag:102];
        backgroundImageView.image = [[UIImage imageNamed:@"pos_cell_bg_t.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
        UIImageView* backgroundImageViewBottom = [[UIImageView alloc] initWithFrame:CGRectMake(70, 60, self.tableView.frame.size.width - 140, 120)];
        backgroundImageViewBottom.image = [[UIImage imageNamed:@"pos_cell_bg_b.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
        [cell.contentView addSubview:backgroundImageViewBottom];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, self.tableView.frame.size.width - 140, 60)];
        [button addTarget:self action:@selector(chooseStaff:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1000 +indexPath.section;
        [cell.contentView addSubview:button];
        
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 60, self.tableView.frame.size.width - 140, 60)];
        tempLabel.tag = 4000 + indexPath.section;
        tempLabel.text = @"请输入医生备注";
        tempLabel.textAlignment = NSTextAlignmentCenter;
        tempLabel.textColor = COLOR(165, 165, 165, 1);
        [cell.contentView addSubview:tempLabel];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(85, 60, self.tableView.frame.size.width - 170, 60)];
        //[textView ]
        textView.backgroundColor = [UIColor clearColor];
        textView.delegate = self;
        textView.tag = 5000 + indexPath.section;
        textView.text = self.selectedRemark;
        [cell.contentView addSubview:textView];
        if (![textView.text isEqualToString:@""] && ![textView.text isEqualToString:@" "])
        {
            tempLabel.hidden = YES;
        }
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(71, 120, self.tableView.frame.size.width - 142, 59)];
        scrollView.backgroundColor = [UIColor clearColor];
        NSArray *remarkArray = [self.selectedRemarkLabelString componentsSeparatedByString:@","];
        //NSArray *remarkArray = [[NSArray alloc] initWithObjects:@"1", @"12", @"123", @"1234", @"12345", @"123456", @"1234567", @"12345678", @"123456789", @"1234567890", @"1234567890qwertyu", nil];
        CGFloat pages = remarkArray.count > 10 ? 2 : 1;
        scrollView.contentSize = CGSizeMake(self.tableView.frame.size.width - 142, 59 * pages);
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
                remarkButton.tag = 8000 + indexPath.section * 100 + i;
                [self.remarkTagDict setObject:[self remarkIdToName:remarkArray[i]] forKey:[NSString stringWithFormat:@"%d", remarkButton.tag]];
                [remarkButton addTarget:self action:@selector(remarkSelect:) forControlEvents:UIControlEventTouchUpInside];
                [scrollView addSubview:remarkButton];
                originX = originX + textWidth + 6;
            }
        }
        [cell.contentView addSubview:scrollView];
    }
    else if ( indexPath.section < selectKeshiSections - 1  || (indexPath.section == selectKeshiSections - 1 && self.needSelectKeshiArray.count == 0) )
    {
        UIImageView* backgroundImageView = (UIImageView*)[cell viewWithTag:102];
        backgroundImageView.image = [[UIImage imageNamed:@"pos_cell_bg_t.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
        UIImageView* backgroundImageViewBottom = [[UIImageView alloc] initWithFrame:CGRectMake(70, 60, self.tableView.frame.size.width - 140, 120)];
        backgroundImageViewBottom.image = [[UIImage imageNamed:@"pos_cell_bg_b.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10,10)];
        [cell.contentView addSubview:backgroundImageViewBottom];
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 60, self.tableView.frame.size.width - 140, 60)];
        tempLabel.tag = 4000 + indexPath.section;
        NSLog(@"%@",cell.subviews);
        tempLabel.text = @"请输入医生备注";
        tempLabel.textColor = COLOR(165, 165, 165, 1);
        tempLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:tempLabel];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, self.tableView.frame.size.width - 140, 60)];
        button.tag = 1000 +indexPath.section;
        [button addTarget:self action:@selector(chooseStaff:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(85, 60, self.tableView.frame.size.width - 170, 60)];
        //[textView ]
        textView.delegate = self;
        textView.tag = 5000 + indexPath.section;
        textView.text = [self.keshiInfoArray[indexPath.section] objectForKey:@"remark"];
        textView.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:textView];
        if (![textView.text isEqualToString:@""] && ![textView.text isEqualToString:@" "])
        {
            tempLabel.hidden = YES;
        }
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(71, 120, self.tableView.frame.size.width - 142, 60)];
        //scrollView.backgroundColor = [UIColor yellowColor];
        scrollView.scrollEnabled = YES;
        NSArray *remarkArray = [self.keshiInfoArray[indexPath.section] objectForKey:@"remark_ids"];
        //NSArray *remarkArray = [[NSArray alloc] initWithObjects:@"1", @"12", @"123", @"1234", @"12345", @"123456", @"1234567", @"12345678", @"123456789", @"1234567890", @"1234567890qwertyu", nil];
        CGFloat pages = remarkArray.count > 10 ? 2 : 1;
        scrollView.contentSize = CGSizeMake(self.tableView.frame.size.width - 142, 59 * pages);
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
                remarkButton.tag = 8000 + indexPath.section * 100 + i;
                [self.remarkTagDict setObject:[self remarkIdToName:remarkArray[i]] forKey:[NSString stringWithFormat:@"%d", remarkButton.tag]];
                [remarkButton addTarget:self action:@selector(remarkSelect:) forControlEvents:UIControlEventTouchUpInside];
                [scrollView addSubview:remarkButton];
                originX = originX + textWidth + 6;
            }
        }
        [cell.contentView addSubview:scrollView];
    }
    else
    {
        [self cellBg:cell withRow:row minRow:0 maxRow:maxRow];
    }
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
    int selectKeshiSections = (self.needSelectKeshiArray.count > 0 ? 1 : 0) + self.keshiInfoArray.count;
    if ( indexPath.section == selectKeshiSections - 1 && self.needSelectKeshiArray.count != 0 )
    {
        return 180;
    }
    else if ( indexPath.section < selectKeshiSections - 1  || (indexPath.section == selectKeshiSections - 1 && self.needSelectKeshiArray.count == 0) )
    {
        return 180;
    }
    else
    {
        return 60;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    int selectKeshiSections = (self.needSelectKeshiArray.count > 0 ? 1 : 0) + self.keshiInfoArray.count;
    if ( section == selectKeshiSections - 1 && self.needSelectKeshiArray.count != 0 )
    {
        return 72;
    }
    else if ( section < selectKeshiSections - 1  || (section == selectKeshiSections - 1 && self.needSelectKeshiArray.count == 0) )
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
    int selectKeshiSections = (self.needSelectKeshiArray.count > 0 ? 1 : 0) + self.keshiInfoArray.count;
    if ( section == selectKeshiSections - 1 && self.needSelectKeshiArray.count != 0 )
    {
        NSString *labelText =  [[NSString alloc] init];
        if ([self.selectedKeshiId intValue] == 0)
        {
            labelText = @"请选择科室";
        }
        else
        {
            labelText = self.selectedKeshiName;
        }
        int textWidth = [labelText boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size.width + 2;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 32, textWidth, 20)];
        label.tag = 2000 + section;
        label.text = labelText;
        if ([self.selectedKeshiId intValue] == 0)
        {
            label.textColor = [UIColor redColor];
        }
        else
        {
            label.textColor = COLOR(153, 174, 175,1);
        }
        label.font = [UIFont systemFontOfSize:18];
        label.backgroundColor = [UIColor clearColor];
        
//        v.backgroundColor = [UIColor blueColor];
        [v addSubview:label];
        UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(textWidth+72, 24, 498-textWidth, 40)];
        detail.text = [NSString stringWithFormat:@"(%@)", [self.needSelectKeshiArray componentsJoinedByString:@"、"]];
        detail.numberOfLines = 0;
        detail.tag = 7000 + section;
        detail.font = [UIFont systemFontOfSize:14];
        detail.textColor = COLOR(188, 188, 188,1);
        [v addSubview:detail];
        UIButton *choose = [[UIButton alloc] initWithFrame:CGRectMake(600, 34, 58, 20)];
        NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"更改科室"];
        [tncString addAttribute:NSUnderlineStyleAttributeName
                          value:@(NSUnderlineStyleSingle)
                          range:(NSRange){0,[tncString length]}];
        [tncString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14]  range:NSMakeRange(0,[tncString length])];
        [tncString addAttribute:NSForegroundColorAttributeName value:COLOR(96, 211, 212, 1)  range:NSMakeRange(0,[tncString length])];
        [tncString addAttribute:NSUnderlineColorAttributeName value:COLOR(96, 211, 212, 1) range:(NSRange){0,[tncString length]}];
        [choose setAttributedTitle:tncString forState:UIControlStateNormal];
        [choose addTarget:self action:@selector(chooseRoom:) forControlEvents:UIControlEventTouchUpInside];
        choose.tag = 6000 + section;
        [v addSubview:choose];
    }
    else if ( section < selectKeshiSections - 1  || (section == selectKeshiSections - 1 && self.needSelectKeshiArray.count == 0) )
    {
        int textWidth = [[self.keshiInfoArray[section] objectForKey:@"keshiName"] boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size.width + 2;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 32, textWidth, 20)];
        label.text = [self.keshiInfoArray[section] objectForKey:@"keshiName"];
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = COLOR(153, 174, 175,1);
        label.tag = 2000 + section;
        label.backgroundColor = [UIColor clearColor];
//        v.backgroundColor = [UIColor blueColor];
        [v addSubview:label];
        UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(textWidth+72, 24, 538-textWidth, 40)];
        detail.text = [NSString stringWithFormat:@"(%@)", [[self.keshiInfoArray[section] objectForKey:@"keshiProducts"] componentsJoinedByString:@"、"]];
        detail.numberOfLines = 0;
        detail.tag = 7000 + section;
        detail.font = [UIFont systemFontOfSize:14];
        detail.textColor = COLOR(188, 188, 188,1);
        [v addSubview:detail];
        UIButton *choose = [[UIButton alloc] initWithFrame:CGRectMake(600, 34, 58, 20)];
        NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"更改科室"];
        [tncString addAttribute:NSUnderlineStyleAttributeName
                          value:@(NSUnderlineStyleSingle)
                          range:(NSRange){0,[tncString length]}];
        [tncString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14]  range:NSMakeRange(0,[tncString length])];
        [tncString addAttribute:NSForegroundColorAttributeName value:COLOR(96, 211, 212, 1)  range:NSMakeRange(0,[tncString length])];
        [tncString addAttribute:NSUnderlineColorAttributeName value:COLOR(96, 211, 212, 1) range:(NSRange){0,[tncString length]}];
        [choose setAttributedTitle:tncString forState:UIControlStateNormal];
        [choose addTarget:self action:@selector(chooseRoom:) forControlEvents:UIControlEventTouchUpInside];
        choose.tag = 6000 + section;
        [v addSubview:choose];
    }
//    else if ( section == 0 + selectKeshiSections)
//    {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 32, 300, 20)];
//        label.text = @"科室";
//        label.font = [UIFont systemFontOfSize:18];
//        label.textColor = COLOR(153, 174, 175,1);
//        label.backgroundColor = [UIColor clearColor];
//        [v addSubview:label];
//    }
//    else if ( section == 0 + selectKeshiSections)
//    {
//        if ( currentFirstKeshi >= 0 )
//        {
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 19, 300, 20)];
//            label.text = @"医生";
//            label.font = [UIFont systemFontOfSize:18];
//            label.textColor = COLOR(153, 174, 175,1);
//            label.backgroundColor = [UIColor clearColor];
//            [v addSubview:label];
//        }
//        else
//        {
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 19, 300, 20)];
//            label.text = @"顾问";
//            label.font = [UIFont systemFontOfSize:18];
//            label.textColor = COLOR(153, 174, 175,1);
//            label.backgroundColor = [UIColor clearColor];
//            [v addSubview:label];
//        }
//    }
    else if ( section == 0 + selectKeshiSections)
    {
//        if ( currentFirstKeshi >= 0 )
//        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 19, 300, 20)];
            label.text = @"顾问";
            label.font = [UIFont systemFontOfSize:18];
            label.textColor = COLOR(153, 174, 175,1);
            label.backgroundColor = [UIColor clearColor];
            [v addSubview:label];
//        }
//        else
//        {
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 19, 300, 20)];
//            label.text = @"设计师";
//            label.font = [UIFont systemFontOfSize:18];
//            label.textColor = COLOR(153, 174, 175,1);
//            label.backgroundColor = [UIColor clearColor];
//            [v addSubview:label];
//        }
    }
    else if ( section == 1 + selectKeshiSections)
    {
//        if ( currentFirstKeshi >= 0 )
//        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 19, 300, 20)];
            label.text = @"设计师";
            label.font = [UIFont systemFontOfSize:18];
            label.textColor = COLOR(153, 174, 175,1);
            label.backgroundColor = [UIColor clearColor];
            [v addSubview:label];
//        }
//        else
//        {
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 19, 300, 20)];
//            label.text = @"设计总监";
//            label.font = [UIFont systemFontOfSize:18];
//            label.textColor = COLOR(153, 174, 175,1);
//            label.backgroundColor = [UIColor clearColor];
//            [v addSubview:label];
//        }
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
    int selectKeshiSections = (self.needSelectKeshiArray.count > 0 ? 1 : 0) + self.keshiInfoArray.count;
    if ( indexPath.section == 0 )
    {
        /*
        if ( row > 0 )
        {
            currentFirstKeshi = row - 1;
            currentSecondKeshi = -1;
            currentGuwen = -1;
            guwen_expand = FALSE;
            second_keshi_expand = FALSE;
            
            CDKeShi* keshi = self.firstKeshiArray[currentFirstKeshi];
            
            self.secondKeshiArray = keshi.staff.array;//[[BSCoreDataManager currentManager] fetchChildKeshi:keshi];
            
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
        [self.tableView reloadData];*/
    }
    else if ( indexPath.section == 0 + selectKeshiSections )
    {
//        if ( currentFirstKeshi >= 0 )
//        {
//            if ( row > 0 )
//            {
//                currentSecondKeshi = row - 1;
//            }
//
//            second_keshi_expand = !second_keshi_expand;
//            currentGuwen = -1;
//            guwen_expand = FALSE;
//            [self.tableView reloadData];
//        }
//        else
//        {
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
//        }
    }
    else if ( indexPath.section == 1 + selectKeshiSections )
    {
//        if ( currentFirstKeshi >= 0 )
//        {
//            //            CDKeShi* keshi = self.firstKeshiArray[currentFirstKeshi];
//            //            if ( ![keshi.is_display_adviser boolValue] )
//            //            {
//            //                return;
//            //            }
//
//            if ( row == 1 )
//            {
//                currentGuwen = -1;
//            }
//            else if ( row > 1 )
//            {
//                currentGuwen = row - 2;
//            }
//
//            guwen_expand = !guwen_expand;
//            [self.tableView reloadData];
//        }
//        else
//        {
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
//        }
    }
    else if ( indexPath.section == 2 + selectKeshiSections )
    {
//        if ( currentFirstKeshi >= 0 )
//        {
//            [self didShejishiPressed];
//            return;
//            if ( row == 1 )
//            {
//                currentShejishi = -1;
//            }
//            else if ( row > 1 )
//            {
//                currentShejishi = row - 2;
//            }
//
//            shejishi_expand = !shejishi_expand;
//            [self.tableView reloadData];
//        }
//        else
//        {
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
//        }
    }
//    else if ( indexPath.section == 2 + selectKeshiSections )
//    {
//        [self didShejiZongjianPressed];
//        return;
//
//        if ( row == 1 )
//        {
//            currentShejizongjian = -1;
//        }
//        else if ( row > 1 )
//        {
//            currentShejizongjian = row - 2;
//        }
//
//        shejizongjian_expand = !shejizongjian_expand;
//        [self.tableView reloadData];
//    }
}

- (IBAction)didCloseButtonPressed:(id)sender
{
    if (self.needSelectKeshiArray.count == 0)
    {
        self.selectedKeshiName = [[NSString alloc] init];
        self.selectedRemarkLabelString = [[NSString alloc] init];
        self.selectedRemark = [[NSString alloc] init];
        self.selectedKeshiId = [NSNumber numberWithInt:0];
        self.selectedDoctorId = [NSNumber numberWithInt:0];
        NSMutableArray *doctorArray = [[NSMutableArray alloc] init];
        NSMutableArray *roomArray = [[NSMutableArray alloc] init];
        NSMutableArray *remarkArray = [[NSMutableArray alloc] init];
        NSMutableArray *productArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in self.keshiInfoArray)
        {
            [doctorArray addObject:[dict objectForKey:@"doctorID"]];
            [roomArray addObject:[dict objectForKey:@"keshiID"]];
            [remarkArray addObject:[dict objectForKey:@"remark"]];
            [productArray addObject:[[dict objectForKey:@"productID"] componentsJoinedByString:@"|"]];
            
        }
        
//        [doctorArray addObject:self.selectedDoctorId];
//        [roomArray addObject:self.selectedKeshiId];
//        [remarkArray addObject:self.selectedRemark];
//        [productArray addObject:[self.needSelectedKeshiIds componentsJoinedByString:@"|"]];
        
        self.operate.doctorids = [doctorArray componentsJoinedByString:@","];
        //self.operate.departmentids = [roomArray componentsJoinedByString:@","];
        self.operate.remark = [remarkArray componentsJoinedByString:@","];
        self.operate.productids = [productArray componentsJoinedByString:@","];
    }
    [self.maskView hidden];
}

- (IBAction)didOkButtonPressed:(id)sender
{
    //currentFirstKeshi = 0;
    for (NSDictionary *dict in self.keshiInfoArray)
    {
        if ([[dict objectForKey:@"keshiID"] integerValue] == 0 || [dict objectForKey:@"keshiID"] == nil)
        {
            currentFirstKeshi = -1;
        }
    }
    if (self.selectedKeshiId.integerValue == 0)
    {
        self.operate.firstKeshi = nil;
    }
    if ( currentFirstKeshi == -1 )
    {
        //        UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"请选择科室" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        //        [v show];
        if ( currentDoctor >= 0 )
        {
            CDStaff* staff = self.secondKeshiArray[currentDoctor];
            self.operate.doctor_id = staff.staffID;
            self.operate.doctor_name = staff.name;
        }

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
        if (self.needSelectKeshiArray.count == 0)
        {
            NSMutableArray *doctorArray = [[NSMutableArray alloc] init];
            NSMutableArray *roomArray = [[NSMutableArray alloc] init];
            NSMutableArray *remarkArray = [[NSMutableArray alloc] init];
            NSMutableArray *productArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in self.keshiInfoArray)
            {
                [doctorArray addObject:[dict objectForKey:@"doctorID"]];
                [roomArray addObject:[dict objectForKey:@"keshiID"]];
                [remarkArray addObject:[dict objectForKey:@"remark"]];
                [productArray addObject:[[dict objectForKey:@"productID"] componentsJoinedByString:@"|"]];
                
            }
            self.operate.doctorids = [doctorArray componentsJoinedByString:@","];
            self.operate.departmentids = [roomArray componentsJoinedByString:@","];
            self.operate.remark = [remarkArray componentsJoinedByString:@","];
            self.operate.productids = [productArray componentsJoinedByString:@","];
        }
        
        [self.maskView hidden];
    }
    else
    {
        for(NSDictionary *keshInfo in self.keshiInfoArray)
        {
            for(CDKeShi *keshi in self.firstKeshiArray)
            {
                if (keshi.keshi_id.intValue == [[keshInfo objectForKey:@"keshiID"] intValue])
                {
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
                }
            }
        }
        CDKeShi* keshi = self.firstKeshiArray[currentFirstKeshi];
        self.operate.firstKeshi = keshi;
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
            NSMutableArray *doctorArray = [[NSMutableArray alloc] init];
            NSMutableArray *roomArray = [[NSMutableArray alloc] init];
            NSMutableArray *remarkArray = [[NSMutableArray alloc] init];
            NSMutableArray *productArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in self.keshiInfoArray)
            {
                [doctorArray addObject:[dict objectForKey:@"doctorID"]];
                [roomArray addObject:[dict objectForKey:@"keshiID"]];
                [remarkArray addObject:[dict objectForKey:@"remark"]];
                [productArray addObject:[[dict objectForKey:@"productID"] componentsJoinedByString:@"|"]];
                
            }
            if(self.needSelectKeshiArray.count > 0)
            {
                [doctorArray addObject:self.selectedDoctorId];
                [roomArray addObject:self.selectedKeshiId];
                [remarkArray addObject:self.selectedRemark];
                [productArray addObject:[self.needSelectedKeshiIds componentsJoinedByString:@"|"]];
                
            }
            self.operate.doctorids = [doctorArray componentsJoinedByString:@","];
            self.operate.departmentids = [roomArray componentsJoinedByString:@","];
            self.operate.remark = [remarkArray componentsJoinedByString:@","];
            self.operate.productids = [productArray componentsJoinedByString:@","];

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

- (void)chooseStaff:(UIButton *)sender
{
    if (sender.tag - 1000 >= self.keshiInfoArray.count)
    {
        if (self.selectedKeshiId.intValue == 0)
        {
            UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"请选择科室" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
            [v show];
            return;
        }
        else
        {
            for (CDKeShi *keshi in self.firstKeshiArray)
            {
                if (keshi.keshi_id.intValue == self.selectedKeshiId.intValue)
                {
                    self.doctorArray = keshi.staff.array;
                }
            }
        }
    }
    else
    {
        for (CDKeShi *keshi in self.firstKeshiArray)
        {
            if (keshi.keshi_id.intValue == [[self.keshiInfoArray[sender.tag - 1000] objectForKey:@"keshiID"] intValue])
            {
                self.doctorArray = keshi.staff.array;
            }
        }
    }
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];

    WeakSelf;
    self.selectVC.countOfTheList = ^NSInteger{
        return weakSelf.doctorArray.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = weakSelf.doctorArray[index];
        return staff.name;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        currentDoctor = index;
//        [weakSelf.tableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:sender.tag-1000];
        NSLog(@"%@",[weakSelf.tableView cellForRowAtIndexPath:indexPath].contentView.subviews);
        UILabel* label = (UILabel*)[[weakSelf.tableView cellForRowAtIndexPath:indexPath].contentView viewWithTag:sender.tag-700];
        CDStaff* staff = weakSelf.doctorArray[index];
        label.text = staff.name;
        if (sender.tag - 1000 >= self.keshiInfoArray.count)
        {
            weakSelf.selectedDoctorId = staff.staffID;
//            [self.keshiInfoArray[sender.tag - 1000] setObject:staff.staffID forKey:@"doctorID"];
        }
        else
        {
            [weakSelf.keshiInfoArray[sender.tag - 1000] setObject:staff.staffID forKey:@"doctorID"];
        }
        [weakSelf.tableView reloadData];
    };
    self.selectVC.rightInfoAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = weakSelf.doctorArray[index];
        return [NSString stringWithFormat:@"%@ %@",staff.work_location,staff.job_name];
    };
    
    [self.maskView addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (void)chooseRoom:(UIButton *)sender
{
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    
    WeakSelf;
    self.selectVC.countOfTheList = ^NSInteger{
        return weakSelf.firstKeshiArray.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDKeShi* keshi = weakSelf.firstKeshiArray[index];
        return keshi.name;
    };
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        //        [weakSelf.tableView reloadData];
        UILabel* label = (UILabel*)[weakSelf.tableView viewWithTag:sender.tag - 4000];
        UILabel* detail = (UILabel*)[weakSelf.tableView viewWithTag:sender.tag + 1000];
        CDKeShi* keshi = weakSelf.firstKeshiArray[index];
        currentFirstKeshi = index;
        label.text = keshi.name;
        int textWidth = [keshi.name boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size.width + 2;
        label.frame = CGRectMake(70, 32, textWidth, 20);
        detail.frame = CGRectMake(textWidth+72, 24, 538-textWidth, 40);
        if (weakSelf.keshiInfoArray.count == 0 || sender.tag - 6000 == weakSelf.keshiInfoArray.count)
        {
            weakSelf.selectedKeshiName = keshi.name;
            weakSelf.selectedKeshiId = keshi.keshi_id;
            weakSelf.selectedRemarkLabelString = keshi.remark_ids;
            weakSelf.selectedDoctorId = [NSNumber numberWithInt:0];
        }
        else
        {
            [weakSelf.keshiInfoArray[sender.tag - 6000] setObject:keshi.name forKey:@"keshiName"];
            [weakSelf.keshiInfoArray[sender.tag - 6000] setObject:keshi.keshi_id forKey:@"keshiID"];
            [weakSelf.keshiInfoArray[sender.tag - 6000] setObject:[NSNumber numberWithInt:0] forKey:@"doctorID"];
            [weakSelf.keshiInfoArray[sender.tag - 6000] setObject:[keshi.remark_ids componentsSeparatedByString:@","] forKey:@"remark_ids"];
        }
        [weakSelf.tableView reloadData];
    };
    self.selectVC.rightInfoAtIndex = ^NSString *(NSInteger index) {
        CDKeShi* keshi = weakSelf.firstKeshiArray[index];
        return @"";
    };
    
    [self.maskView addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (void)remarkSelect:(UIButton *)button
{
    UITextView *textView = [self.tableView viewWithTag:((button.tag/100)%10+5000)];
    textView.text = [NSString stringWithFormat:@"%@%@",textView.text, [self.remarkTagDict objectForKey:[NSString stringWithFormat:@"%d", button.tag]]];
    int selectKeshiSections = (self.needSelectKeshiArray.count > 0 ? 1 : 0) + self.keshiInfoArray.count;
    if ( textView.tag - 5000 == selectKeshiSections - 1 && self.needSelectKeshiArray.count != 0 )
    {
        self.selectedRemark = textView.text;
    }
    else if ( textView.tag - 5000 < selectKeshiSections - 1 || (textView.tag - 5000 == selectKeshiSections - 1 && self.needSelectKeshiArray.count == 0) )
    {
        [self.keshiInfoArray[textView.tag - 5000] setObject:textView.text forKey:@"remark"];
    }
    UILabel* label = (UILabel*)[self.tableView viewWithTag:((button.tag/100)%10+4000)];
    label.hidden = YES;
    [label setHidden:YES];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:(button.tag/100)%10] atScrollPosition:UITableViewScrollPositionTop animated:YES];
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

