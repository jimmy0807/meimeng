//
//  HPatientBingliLeftViewController.m
//  meim
//
//  Created by jimmy on 2017/4/27.
//
//

#import "HPatientBingliLeftViewController.h"
#import "HPatientLeftShoushuTableViewCell.h"
#import "FetchHBinglikaDetailRequest.h"
#import "HShoushuCreateRequest.h"

@interface HPatientBingliLeftViewController ()

@property(nonatomic, weak)IBOutlet UILabel* nameLabel;       //名称
@property(nonatomic, weak)IBOutlet UIImageView* logoImage;      //图像
@property(nonatomic, weak)IBOutlet UILabel* genderLabel;       //病人性别
@property(nonatomic, weak)IBOutlet UILabel* ageLabel;       //年龄
@property(nonatomic, weak)IBOutlet UILabel* amountLabel;       //余额
@property(nonatomic, weak)IBOutlet UILabel* pointLabel;       //积分
@property(nonatomic, weak)IBOutlet UILabel* xingzuoLabel;       //星座
@property(nonatomic, weak)IBOutlet UILabel* xuexingLabel;       //血型
@property(nonatomic, weak)IBOutlet UILabel* mobileLabel;      //电话
@property(nonatomic, weak)IBOutlet UILabel* doctorLabel;    //医生
@property(nonatomic, weak)IBOutlet UILabel* firstTreatDateLabel;    //初珍时间

@property(nonatomic, weak)IBOutlet UIView* huizhenView;
@property(nonatomic, weak)IBOutlet UIView* shoushuView;
@property(nonatomic, weak)IBOutlet UIView* peiyaoView;

@property(nonatomic, weak)IBOutlet UIImageView* huizhenBlueTag;
@property(nonatomic, weak)IBOutlet UIImageView* shoushuBluetag;
@property(nonatomic, weak)IBOutlet UIImageView* peiyaoBluetag;

@property(nonatomic, weak)IBOutlet UIButton* createButton;
@property(nonatomic, weak)IBOutlet UITableView* tableView;
@property(nonatomic, strong)CDHBinglika* ka;
@end

@implementation HPatientBingliLeftViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self reloadData];
    
    [self registerNofitificationForMainThread:kHBinglikaResponse];
    [self registerNofitificationForMainThread:kHShoushuResponse];
    [self registerNofitificationForMainThread:kHShoushuCreateResponse];
    [self registerNofitificationForMainThread:kHShoushuLinesResponse];
    [self registerNofitificationForMainThread:kBSMemberCreateResponse];
    
    [self setMemberInfo];
    
    self.shoushuView.backgroundColor = [UIColor whiteColor];
    self.peiyaoView.backgroundColor = [UIColor whiteColor];
//    if ([[PersonalProfile currentProfile].medical_api_version isEqualToString:@"nine"])
//    {
//        self.peiyaoView.hidden = YES;
//    }
    self.shoushuBluetag.hidden = YES;
    self.peiyaoBluetag.hidden = YES;
    self.shoushuView.hidden = self.hideShoushu;
    self.createButton.hidden = YES;
    self.tableView.hidden = YES;
    
    self.ka = [[BSCoreDataManager currentManager] uniqueEntityForName:@"CDHBinglika" withValue:self.member.record_id forKey:@"binglika_id"];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    UIImageView* v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 1)];
    v.backgroundColor = COLOR(239, 242, 242, 1);
    self.tableView.tableHeaderView = v;
}

- (void)setMemberInfo
{
    self.nameLabel.text = self.member.memberName;
    if ( [self.member.gender isEqualToString:@"Male"] )
    {
        self.genderLabel.text = @"男";
    }
    else
    {
        self.genderLabel.text = @"女";
    }
    self.mobileLabel.text = self.member.mobile;
    self.doctorLabel.text = self.member.doctor_name;
    self.firstTreatDateLabel.text = self.member.first_treat_date;
    self.ageLabel.text = [self age];
    [self.logoImage sd_setImageWithURL:[NSURL URLWithString:self.member.image_url] placeholderImage:[UIImage imageNamed:@"pad_avatar_default"]];
    self.xuexingLabel.text = self.member.blood_type;
    self.xingzuoLabel.text = self.member.astro;
}

- (NSString*)age
{
    if ( [self.member.birthday length] > 0 )
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"yyyy-MM-dd";
        NSDate *date = [dateFormat dateFromString:self.member.birthday];
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        unsigned int unitFlags = NSYearCalendarUnit;
        NSDateComponents *comps = [gregorian components:unitFlags fromDate:date  toDate:[NSDate date]  options:0];
        
        return [NSString stringWithFormat:@"%d岁",comps.year];
    }
    
    return @"未填";
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kHBinglikaResponse])
    {
        [self reloadData];
    }
    else if ([notification.name isEqualToString:kHShoushuResponse])
    {
        [self reloadData];
    }
    else if ( [notification.name isEqualToString:kHShoushuCreateResponse] )
    {
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            [[[FetchHBinglikaDetailRequest alloc] initWithBinglikaID:self.member.record_id] execute];
            HShoushuCreateRequest* request = notification.object;
            if ( [request.shoushuID integerValue] == 0 )
            {
                //self.shoushuPressed();
            }
        }
    }
    else if ([notification.name isEqualToString:kHShoushuLinesResponse])
    {
        [self reloadData];
    }
    else if ([notification.name isEqualToString:kBSMemberCreateResponse])
    {
        [self setMemberInfo];
    }
}

- (void)reloadData
{
    [self.tableView reloadData];
}

- (IBAction)didHuizhenButtonPressed:(id)sender
{
    self.huizhenView.backgroundColor = COLOR(239, 242, 242, 1);
    self.shoushuView.backgroundColor = [UIColor whiteColor];
    self.peiyaoView.backgroundColor = [UIColor whiteColor];
    self.huizhenBlueTag.hidden = NO;
    self.shoushuBluetag.hidden = YES;
    self.peiyaoBluetag.hidden = YES;
    self.createButton.hidden = YES;
    self.tableView.hidden = YES;
    self.huizhenPressed();
}

- (IBAction)didShoushuButtonPressed:(id)sender
{
    self.huizhenView.backgroundColor = [UIColor whiteColor];
    self.shoushuView.backgroundColor = COLOR(239, 242, 242, 1);
    self.peiyaoView.backgroundColor = [UIColor whiteColor];
    self.huizhenBlueTag.hidden = YES;
    self.shoushuBluetag.hidden = NO;
    self.peiyaoBluetag.hidden = YES;
    self.createButton.hidden = NO;
    self.tableView.hidden = YES;
    self.shoushuPressed();
}

- (IBAction)didPeiyaoButtonPressed:(id)sender
{
    self.huizhenView.backgroundColor = [UIColor whiteColor];
    self.shoushuView.backgroundColor = [UIColor whiteColor];
    self.peiyaoView.backgroundColor = COLOR(239, 242, 242, 1);
    self.huizhenBlueTag.hidden = YES;
    self.shoushuBluetag.hidden = YES;
    self.peiyaoBluetag.hidden = NO;
    self.createButton.hidden = NO;
    self.tableView.hidden = YES;
    self.peiyaoPressed();
}

- (IBAction)didCreateButtonPressed:(id)sender
{
    self.shoushuCreatePressed();
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.ka.shoushu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HPatientLeftShoushuTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HPatientLeftShoushuTableViewCell"];
    CDHShoushu* shoushu = self.ka.shoushu[indexPath.row];
    cell.shoushu = shoushu;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CDHShoushu* shoushu = self.ka.shoushu[indexPath.row];
    self.shoushuItemPressed(shoushu, indexPath.row);
}

@end
