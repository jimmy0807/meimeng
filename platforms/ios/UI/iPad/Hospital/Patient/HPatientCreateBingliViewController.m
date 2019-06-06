//
//  HPatientCreateBingliViewController.m
//  meim
//
//  Created by jimmy on 2017/5/8.
//
//

#import "HPatientCreateBingliViewController.h"
#import "SeletctListViewController.h"
#import "HHuizhenCreateRequest_N.h"
#import "CBLoadingView.h"
#import "YimeiHuizhenPhotoView.h"
#import "SeletctListViewController.h"

@interface HPatientCreateBingliViewController ()
@property(nonatomic, strong)SeletctListViewController* selectVC;
@property(nonatomic, weak)IBOutlet UILabel* doctorLabel;
@property(nonatomic, weak)IBOutlet UILabel* fisrtCategoryLabel;
@property(nonatomic, weak)IBOutlet UILabel* secondCategoryLabel;
@property(nonatomic, weak)IBOutlet UITextView* doctorNoteTextView;
@property(nonatomic, weak)IBOutlet UITextView* doctorReasonTextView;
@property(nonatomic, weak)IBOutlet UILabel* memzhenLabel;
@property(nonatomic, strong)NSMutableOrderedSet* indexSet;
@end

@implementation HPatientCreateBingliViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ( self.huizhen.doctors_name.length > 0 )
    {
        self.doctorLabel.text = self.huizhen.doctors_name;
    }
    else
    {
        NSArray* array = [[BSCoreDataManager currentManager] fetchDoctorStaffsWithShopID:[PersonalProfile currentProfile].bshopId];
        for ( CDStaff* staff in array )
        {
            if ( [[PersonalProfile currentProfile].employeeID isEqual:staff.staffID] )
            {
                self.doctorLabel.text = staff.name;
                self.huizhen.doctors_name = staff.name;
                self.huizhen.doctors_id = staff.staffID;
            }
        }
    }
    
    if ( [self.huizhen.doctors_id integerValue] == 0 )
    {
        self.huizhen.doctors_name = self.huizhen.binglika.doctor_name;
        self.huizhen.doctors_id = self.huizhen.binglika.doctor_id;
    }
    
    self.doctorNoteTextView.text = self.huizhen.doctors_note;
    self.doctorReasonTextView.text = self.huizhen.reason;
    
    self.fisrtCategoryLabel.text = self.huizhen.first_category_name.length > 0 ? self.huizhen.first_category_name : @"请选择";
    self.secondCategoryLabel.text = self.huizhen.second_category_name.length > 0 ? self.huizhen.second_category_name : @"请选择";
    
    if ( [self.huizhen.source isEqualToString:@"zy"] )
    {
        self.memzhenLabel.text = @"住院";
    }
    else
    {
        self.memzhenLabel.text = @"门诊";
        self.huizhen.source = @"mz";
    }
    
    [self registerNofitificationForMainThread:kHHuizhenCreateResponse];
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kHHuizhenCreateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            [[BSCoreDataManager currentManager] save:nil];
            [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)didDoctorsButtonPressed:(id)sender
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
        weakSelf.doctorLabel.text = staff.name;
        weakSelf.huizhen.doctors_id = staff.staffID;
        weakSelf.huizhen.doctors_name = staff.name;
    };
    self.selectVC.rightInfoAtIndex = ^NSString *(NSInteger index) {
        CDStaff* staff = array[index];
        return [NSString stringWithFormat:@"%@ %@",staff.work_location,staff.job_name];
    };
    
    [self.parentViewController.parentViewController.view addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (IBAction)didCategory1ButtonPressed:(id)sender
{
    WeakSelf;
    NSArray* array = [[BSCoreDataManager currentManager] fetchAllTopHuizhenCategory];
    
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    self.selectVC.countOfTheList = ^NSInteger{
        return array.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDHHuizhenCategory* category = array[index];
        return category.name;
    };
    
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        CDHHuizhenCategory* category = array[index];
        weakSelf.huizhen.first_category_id = category.cateogry_id;
        weakSelf.huizhen.first_category_name = category.name;
        weakSelf.fisrtCategoryLabel.text = category.name;
        
        weakSelf.huizhen.second_category_name = @"";
        weakSelf.huizhen.second_category_ids = @"";
        weakSelf.secondCategoryLabel.text = @"请选择";
        weakSelf.indexSet = [NSMutableOrderedSet orderedSet];
    };
    
    [self.parentViewController.parentViewController.view addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (IBAction)didCategory2ButtonPressed:(id)sender
{
    if ( [self.huizhen.first_category_id integerValue] == 0 )
    {
        UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"请选择分类一" delegate: nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [v show];
        return;
    }
    
    WeakSelf;
    CDHHuizhenCategory* category = [[BSCoreDataManager currentManager] findEntity:@"CDHHuizhenCategory" withValue:self.huizhen.first_category_id forKey:@"cateogry_id"];
    
    NSArray* array = category.childs.array;
    
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    self.selectVC.multiSelect = TRUE;
    
    self.selectVC.countOfTheList = ^NSInteger{
        return array.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        CDHHuizhenCategory* category = array[index];
        return category.name;
    };
    
    self.selectVC.multiSelectFinish = ^(NSOrderedSet* set) {
        NSMutableArray* nameArray = [NSMutableArray array];
        NSMutableArray* idsArray = [NSMutableArray array];
        
        weakSelf.indexSet = [NSMutableOrderedSet orderedSet];
        NSArray* sortArray = [set.array sortedArrayUsingComparator:^NSComparisonResult(NSNumber*  _Nonnull obj1, NSNumber*  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        [sortArray enumerateObjectsUsingBlock:^(NSNumber*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakSelf.indexSet addObject:obj];
            CDHHuizhenCategory* category = array[[obj integerValue]];
            [nameArray addObject:category.name];
            [idsArray addObject:category.cateogry_id];
        }];
        
        weakSelf.huizhen.second_category_name = [nameArray componentsJoinedByString:@","];
        weakSelf.huizhen.second_category_ids = [idsArray componentsJoinedByString:@","];
        
        weakSelf.secondCategoryLabel.text = weakSelf.huizhen.second_category_name;
    };
    
    self.selectVC.isSelected = ^BOOL(NSInteger index) {
        if ( [weakSelf.indexSet containsObject:@(index)] )
        {
            return TRUE;
        }
        
        return FALSE;
    };
    
    [self.parentViewController.parentViewController.view addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (IBAction)didMenzhenButtonPressed:(id)sender
{
    WeakSelf;
    NSArray* array = @[@"门诊",@"住院"];
    
    self.selectVC = [[SeletctListViewController alloc] initWithNibName:@"SeletctListViewController" bundle:nil];
    self.selectVC.countOfTheList = ^NSInteger{
        return array.count;
    };
    self.selectVC.nameAtIndex = ^NSString *(NSInteger index) {
        return array[index];
    };
    
    self.selectVC.selectAtIndex = ^(NSInteger index) {
        weakSelf.huizhen.source = ( index == 0 ) ? @"mz" : @"zy";
        weakSelf.memzhenLabel.text = array[index];
    };
    
    [self.parentViewController.parentViewController.view addSubview:self.selectVC.view];
    [self.selectVC showWithAnimation];
}

- (IBAction)didPhotoButtonPressed:(id)sender
{
    [YimeiHuizhenPhotoView showWithHuizhen:self.huizhen];
}

- (void)didSaveHuizhenButtonPressed
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ( [self.huizhen.doctors_id integerValue] > 0 )
    {
        [params setObject:self.huizhen.doctors_id forKey:@"doctors_id"];
    }
    else if ( [self.huizhen.binglika.doctor_id integerValue] > 0 )
    {
        [params setObject:self.huizhen.binglika.doctor_id forKey:@"doctors_id"];
        //[self showAlert:@"请选择医生"];
        //return;
    }
    
    if ( self.doctorNoteTextView.text.length > 0 )
    {
        [params setObject:self.doctorNoteTextView.text forKey:@"reason"];
        self.huizhen.doctors_note = self.doctorNoteTextView.text;
    }
    else
    {
        [self showAlert:@"请填写实际情况"];
        return;
    }
    
    if (self.doctorReasonTextView.text.length > 0 )
    {
        [params setObject:self.doctorReasonTextView.text forKey:@"doctors_note"];
        self.huizhen.reason = self.doctorReasonTextView.text;
    }
    else
    {
        [params setObject:@"321" forKey:@"doctors_note"];
        self.huizhen.reason = @"321";

//        [self showAlert:@"请填写就诊意见"];
//        return;
    }
    
    if ( [self.huizhen.first_category_id integerValue] > 0 )
    {
        [params setObject:self.huizhen.first_category_id forKey:@"first_diagnosis_category_id"];
    }
    
    if ( [self.huizhen.second_category_ids length] > 0 )
    {
        [params setObject:self.huizhen.second_category_ids forKey:@"second_diagnosis_category_id"];
    }
    
    if ( self.huizhen.picUrls.length > 0 )
    {
        [params setObject:self.huizhen.picUrls forKey:@"image_ids"];
    }
    
    [params setObject:self.huizhen.huizhen_id forKey:@"record_line_id"];
    if ( self.huizhen.huizhen_id.integerValue == 0 )
    {
        [params setObject:self.huizhen.binglika.binglika_id forKey:@"record_id"];
    }
    
    if ( self.huizhen.source )
    {
        [params setObject:self.huizhen.source forKey:@"source"];
    }
    
    if ( [self.huizhen.source isEqualToString:@"mz"] )
    {
        self.huizhen.description_str = [self.huizhen.description_str stringByReplacingOccurrencesOfString:@"住院" withString:@"门诊"];
    }
    else
    {
        self.huizhen.description_str = [self.huizhen.description_str stringByReplacingOccurrencesOfString:@"门诊" withString:@"住院"];
    }
#if 0
    if ( [self.huizhen.huizhen_id integerValue] > 0 )
    {
        HHuizhenCreateRequest* request = [[HHuizhenCreateRequest alloc] initWithHuizhenID:self.huizhen.huizhen_id params:params isEdit:YES];
        [request execute];
    }
    else
    {
        HHuizhenCreateRequest* request = [[HHuizhenCreateRequest alloc] initWithHuizhenID:self.huizhen.binglika.binglika_id params:@{@"line_ids":@[@[@(0),@(FALSE),params]]} isEdit:FALSE];
        [request execute];
    }
#else
    HHuizhenCreateRequest_N* request = [[HHuizhenCreateRequest_N alloc] init];
    request.params = params;
    [request execute];
#endif
    [[CBLoadingView shareLoadingView] show];
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
