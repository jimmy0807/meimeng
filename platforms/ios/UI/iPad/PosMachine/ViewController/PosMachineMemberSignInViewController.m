//
//  PosMachineMemberSignInViewController.m
//  ds
//
//  Created by jimmy on 16/11/15.
//
//

#import "PosMachineMemberSignInViewController.h"
#import "BSFetchMemberCardDetailRequest.h"
#import "BSFetchMemberQinyouRequest.h"
#import "BSMemberCardOperateRequest.h"
#import "CBLoadingView.h"
#import "CBMessageView.h"
#import "NSDate+Formatter.h"
#import "BSWriteMemberRecordRequest.h"
#import "LocalMusicPlayerManager.h"
#import "UIViewController+MMDrawerController.h"
#import "PadProjectViewController.h"

@interface PosMachineMemberSignInViewController ()
{
    BOOL canRing;
}
@property(nonatomic, weak)IBOutlet UITableView* tableView;
@property(nonatomic, weak)IBOutlet UIImageView* avatarImageView;
@property(nonatomic, weak)IBOutlet UILabel* genderLabel;
@property(nonatomic, weak)IBOutlet UILabel* nameLabel;
@property(nonatomic, weak)IBOutlet UILabel* cardNoLabel;
@property(nonatomic, weak)IBOutlet UILabel* dateLabel;
@property(nonatomic, weak)IBOutlet UILabel* expireViewLabel;
@property(nonatomic, weak)IBOutlet UIView* expireView;
@property(nonatomic, strong)CDMemberCard* card;
@property(nonatomic, strong)CDMemberQinyou* qingYou;
@property(nonatomic, strong)NSMutableDictionary* selectParams;
@property(nonatomic, strong)NSMutableArray* productArray;
@end

@implementation PosMachineMemberSignInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectParams = [NSMutableDictionary dictionary];
    
    canRing = TRUE;
    
    [self findCard];
    
    [self realoadData:FALSE];
    
    BSFetchMemberCardDetailRequest* request = [[BSFetchMemberCardDetailRequest alloc] initWithPosCardNo:self.cardNo];
    [request execute];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerNofitificationForMainThread:kBSFetchMemberQinyouResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberCardDetailResponse];
    [self registerNofitificationForMainThread:kBSMemberCardOperateResponse];
    [self registerNofitificationForMainThread:kBSFetchMemberCardProjectResponse];
    [self.tableView flashScrollIndicators];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)findCard
{
    self.card = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCard" withValue:self.cardNo forKey:@"default_code"];
    if ( !self.card )
    {
        self.qingYou = [[BSCoreDataManager currentManager] findEntity:@"CDMemberQinyou" withValue:self.cardNo forKey:@"card_no"];
        if ( self.qingYou )
        {
            self.card = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCard" withValue:self.qingYou.card_id forKey:@"cardID"];
            BSFetchMemberCardDetailRequest* request = [[BSFetchMemberCardDetailRequest alloc] initWithMemberCardID:self.qingYou.card_id];
            [request execute];
        }
    }
}

- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kBSFetchMemberCardDetailResponse])
    {
        if ( self.qingYou )
        {
            self.card = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCard" withValue:self.qingYou.card_id forKey:@"cardID"];
            if ( !self.card )
            {
                NSLog(@"没有此卡");
                [self ringForValidCard:FALSE];
            }
            else
            {
                [self realoadData:FALSE];
            }
        }
        else
        {
            self.card = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCard" withValue:self.cardNo forKey:@"default_code"];
            
            if ( self.card )
            {
                [self realoadData:FALSE];
            }
            else
            {
                BSFetchMemberQinyouRequest* request = [[BSFetchMemberQinyouRequest alloc] initWithPosCardNo:self.cardNo];
                [request execute];
            }
        }
    }
    else if ([notification.name isEqualToString:kBSFetchMemberQinyouResponse])
    {
        self.qingYou = [[BSCoreDataManager currentManager] findEntity:@"CDMemberQinyou" withValue:self.cardNo forKey:@"card_no"];
        if ( self.qingYou )
        {
            self.card = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCard" withValue:self.qingYou.card_id forKey:@"cardID"];
            if ( self.card )
            {
                [self realoadData:FALSE];
            }
           
            BSFetchMemberCardDetailRequest* request = [[BSFetchMemberCardDetailRequest alloc] initWithMemberCardID:self.qingYou.card_id];
            [request execute];
        }
        else
        {
            [self realoadData:FALSE];
            [self ringForValidCard:FALSE];
            NSLog(@"没有此卡");
        }
    }
    else if ([notification.name isEqualToString:kBSMemberCardOperateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            [self.maskView hidden];
            CBMessageView *messageView = [[CBMessageView alloc] initWithTitle:@"消费成功"];
            [messageView show];
            
            NSMutableDictionary* dict = [NSMutableDictionary dictionary];
            if ( self.qingYou )
            {
                [dict setObject:self.qingYou.qy_id forKey:@"relatives_id"];
            }
            
            if ( self.card )
            {
                [dict setObject:self.card.member.memberID forKey:@"member_id"];
                [dict setObject:self.card.cardID forKey:@"card_id"];
            }
            
            [dict setObject:[PersonalProfile currentProfile].deviceString forKey:@"security_id"];
            
            BSWriteMemberRecordRequest* request = [[BSWriteMemberRecordRequest alloc] initWithParams:dict];
            [request execute];
        }
    }
    else if ([notification.name isEqualToString:kBSFetchMemberCardProjectResponse])
    {
        [self realoadData:FALSE];
        if ( self.card )
        {
            [self ringForValidCard:TRUE];
        }
        else
        {
            if ( self.qingYou )
            {
                [self ringForValidCard:TRUE];
            }
            else
            {
                // do nothing
            }
        }
        
    }
}

- (void)realoadData:(BOOL)flag
{
    if ( self.qingYou )
    {
        [self.avatarImageView setImageWithName:[NSString stringWithFormat:@"%@",self.qingYou.image_name] tableName:@"born.relatives" filter:self.qingYou.qy_id fieldName:@"image" writeDate:self.card.member.lastUpdate placeholderString:@"pad_avatar_big" cacheDictionary:nil];
    }
    else
    {
        [self.avatarImageView setImageWithName:[NSString stringWithFormat:@"%@_%@",self.card.member.memberID, self.card.member.memberName] tableName:@"born.member" filter:self.card.member.memberID fieldName:@"image" writeDate:self.card.member.lastUpdate placeholderString:@"pad_avatar_big" cacheDictionary:nil];
    }
    
    
    NSString* genderName = @"Male";
    NSString* nameString = @"Name";
    if ( self.qingYou )
    {
        genderName = self.qingYou.gender;
        nameString =  self.qingYou.name;
    }
    else
    {
        genderName = self.card.member.gender;
        nameString = self.card.member.memberName;
    }
    
    self.genderLabel.text = [genderName isEqualToString:@"Male"] ? @"男" : @"女";
    self.nameLabel.text = [NSString stringWithFormat:@"%@(%@)", nameString, self.genderLabel.text];
    
    if ( self.card.cardNo.length > 0 )
    {
        self.cardNoLabel.text = [NSString stringWithFormat:@"%@",self.card.cardNo];
    }
    else
    {
        self.cardNoLabel.text = @"";
    }
    self.expireView.backgroundColor = COLOR(217, 22, 22, 0.45);
    self.expireView.alpha = 1;
    if ( self.card.invalidDate.length > 1 )
    {
        self.dateLabel.text = [NSString stringWithFormat:@"有效期为: %@",self.card.invalidDate];

        if ( [[[NSDate date] dateString] compare:self.card.invalidDate] == NSOrderedAscending )
        {
            self.expireView.hidden = YES;
        }
        else
        {
            self.expireView.hidden = NO;
            self.expireViewLabel.text = @"卡已过期";
        }
    }
    else if ( self.card.use_start_time.length > 2 )
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate* start = [dateFormat dateFromString:self.card.use_start_time];
        NSDate* end = [dateFormat dateFromString:self.card.use_end_time];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *startComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:start];
        NSDateComponents *endComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:end];
        NSDateComponents *currentComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[NSDate date]];
        BOOL isVaildTime = FALSE;
        if ( startComponents.hour < currentComponents.hour || (startComponents.hour == currentComponents.hour && startComponents.minute <= currentComponents.minute) )
        {
            if ( endComponents.hour > currentComponents.hour || (endComponents.hour == currentComponents.hour && endComponents.minute >= currentComponents.minute) )
            {
                isVaildTime = TRUE;
            }
        }
            
        if ( isVaildTime )
        {
            self.dateLabel.text = @"";
            self.expireView.hidden = YES;
        }
        else
        {
            NSString* startTime = self.card.use_start_time;
            NSString* endTime = self.card.use_end_time;
            NSArray* s = [self.card.use_start_time componentsSeparatedByString:@" "];
            if ( s.count == 2 )
            {
                startTime = s[1];
            }
            
            s = [self.card.use_end_time componentsSeparatedByString:@" "];
            if ( s.count == 2 )
            {
                endTime = s[1];
            }
            
            self.dateLabel.text = [NSString stringWithFormat:@"已过时段卡有效时间:%@ - %@",startTime, endTime];
            self.expireView.hidden = NO;
            
            self.expireViewLabel.text = [NSString stringWithFormat:@"已过时段卡有效时间:%@ - %@",startTime, endTime];
        }
    }
    else
    {
        self.dateLabel.text = @"";
        self.expireView.hidden = YES;
    }
    
    NSInteger expireCount = 0;
    self.productArray = [NSMutableArray array];
    for ( CDMemberCardProject* project in self.card.projects )
    {
        if ( [project.projectCount integerValue] > 0 )
        {
            [self.productArray addObject:project];
            if ( [[[NSDate date] dateString] compare:project.limitedDate] != NSOrderedAscending )
            {
                expireCount++;
                self.dateLabel.text = [NSString stringWithFormat:@"%@ 已过期 %@",project.projectName, project.limitedDate];
            }
        }
    }
    
    if ( self.card == nil )
    {
        self.expireView.hidden = NO;
        self.expireViewLabel.text = @"没有找到此卡";
    }
    else if ( self.card.isInvalid.boolValue )
    {
        self.expireView.hidden = NO;
        self.expireViewLabel.text = @"该会员卡已失效";
    }
    else if ( expireCount == self.productArray.count )
    {
        self.expireView.hidden = NO;
        self.expireViewLabel.text = @"项目已过期";
    }
    else if ( self.productArray.count == 0 )
    {
        self.expireView.hidden = NO;
        self.expireViewLabel.text = @"项目次数已用完";
    }
    
    [self.tableView reloadData];
    
    if ( flag )
    {
        canRing = flag;
        [self ringForValidCard:TRUE];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.productArray.count;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton* iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        iconButton.userInteractionEnabled = NO;
        iconButton.frame = CGRectMake(70, 22, 28, 28);
        iconButton.tag = 1101;
        [cell.contentView addSubview:iconButton];
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 25, 400, 23)];
        titleLabel.font = [UIFont systemFontOfSize:24];
        titleLabel.tag = 1102;
        [cell.contentView addSubview:titleLabel];
        
        UILabel* countLabel = [[UILabel alloc] initWithFrame:CGRectMake(450, 25, 202, 23)];
        countLabel.font = [UIFont systemFontOfSize:24];
        countLabel.tag = 1103;
        countLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:countLabel];
        
        //UIImageView* lineView = [[UIImageView alloc] initWithFrame:CGRectMake(69, 72, 580, 1)];
        //[cell.contentView addSubview:lineView];
    }
    
    CDMemberCardProject* project = self.productArray[row];
    
    UIButton* iconButton = (UIButton*)[cell viewWithTag:1101];
    UILabel* titleLabel = (UILabel*)[cell viewWithTag:1102];
    titleLabel.textColor = COLOR(37.0, 37.0, 37.0, 1.0);
    UILabel* countLabel = (UILabel*)[cell viewWithTag:1103];
    countLabel.textColor = COLOR(165.0, 165.0, 165.0, 1.0);
    [iconButton setBackgroundImage:[self.selectParams[@(indexPath.row)] boolValue]?[UIImage imageNamed:@"yimei_blue_check_n"] : [UIImage imageNamed:@"yimei_blue_check_d"] forState:UIControlStateNormal];
    
    NSString* limitedDate = project.limitedDate;
    if ( limitedDate.length < 2 )
    {
        limitedDate = @"";
    }
    if ( [[[NSDate date] dateString] compare:project.limitedDate] != NSOrderedAscending )
    {
        NSMutableAttributedString *statusString = [[NSMutableAttributedString alloc] init];
        NSAttributedString *projectName = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", project.projectName] attributes:@{NSForegroundColorAttributeName:COLOR(37.0, 37.0, 37.0, 1.0)}];
        [statusString appendAttributedString:projectName];
        NSAttributedString *progress = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(已过期 %@)", limitedDate] attributes:@{NSForegroundColorAttributeName:COLOR(180.0, 213.0, 218.0, 1.0)}];
        [statusString appendAttributedString:progress];
        titleLabel.attributedText = statusString;
    }
    else
    {
        titleLabel.text = [NSString stringWithFormat:@"%@ (%@)",project.projectName,limitedDate];
    }
    if (![project.isLimited boolValue])
    {
        NSMutableAttributedString *statusString = [[NSMutableAttributedString alloc] init];
        NSAttributedString *leftChar = [[NSAttributedString alloc] initWithString:@"剩" attributes:@{NSForegroundColorAttributeName:COLOR(165.0, 165.0, 165.0, 1.0)}];
        [statusString appendAttributedString:leftChar];
        NSAttributedString *leftTimes = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@次", project.remainQty] attributes:@{NSForegroundColorAttributeName:COLOR(96.0, 211.0, 212.0, 1.0)}];
        [statusString appendAttributedString:leftTimes];
        NSAttributedString *totalTimes = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"/共%@次", project.purchaseQty] attributes:@{NSForegroundColorAttributeName:COLOR(165.0, 165.0, 165.0, 1.0)}];
        [statusString appendAttributedString:totalTimes];
        countLabel.attributedText = statusString;
    }
    else
    {
        countLabel.text = @"不限次";
    }
    if (row == self.productArray.count - 1)
    {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(70, 59, 584, 23)];
        line.backgroundColor = COLOR(199, 199, 199, 1);
        [cell addSubview:line];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CDMemberCardProject* project = self.productArray[indexPath.row];
    if ( [project.projectCount integerValue] == 0 )
    {
        return;
    }
    
    if ( [self.selectParams[@(indexPath.row)] boolValue] )
    {
        [self.selectParams setObject:@(FALSE) forKey:@(indexPath.row)];
    }
    else
    {
        [self.selectParams setObject:@(TRUE) forKey:@(indexPath.row)];
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 30.0)];
    headerView.backgroundColor = COLOR(242, 245, 245, 1);
    //    headerView.backgroundColor = COLOR(180.0, 218.0, 213.0, 1.0);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 1.0, 200, 24.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = COLOR(37, 37, 37, 1);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont boldSystemFontOfSize:24.0];
    titleLabel.text = @"卡内项目";
    [headerView addSubview:titleLabel];

    return headerView;
}

- (IBAction)didCloseButtonPressed:(id)sender
{
    [self.maskView hidden];
}

- (IBAction)didOKButtonPressed:(id)sender
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableArray *consumeIds = [NSMutableArray array];
    
    [params setObject:self.card.cardID forKey:@"card_id"];
    
    
    for ( NSNumber* selected in self.selectParams.allKeys )
    {
        if ( [self.selectParams[selected] boolValue] )
        {
            CDMemberCardProject* product = self.productArray[[selected integerValue]];
            NSArray *array = @[@(0), @(NO), @{@"product_id":product.projectID, @"lines_id":product.productLineID, @"consume_qty":@(1), @"qty":@(1)}];
            [consumeIds addObject:array];
        }
    }
    
    if ( consumeIds.count == 0 )
    {
        UIAlertView* v = [[UIAlertView alloc] initWithTitle:nil message:@"请选择要消费的项目" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [v show];
        return;
    }
    
    [params setObject:consumeIds forKey:@"consume_line_ids"];
    
    [[CBLoadingView shareLoadingView] show];
    
    BSMemberCardOperateRequest *request = [[BSMemberCardOperateRequest alloc] initWithParams:params operateType:kPadMemberCardOperateCashier];
    [request execute];
}

- (void)ringForValidCard:(BOOL)valid
{
    if ( canRing )
    {
        if ( valid )
        {
            if ( self.productArray.count > 0 )
            {
                NSString* filePath = [[NSBundle mainBundle] pathForResource:self.expireView.hidden ? @"ring.mp3" : @"ring_invalid.mp3" ofType: @""];
                [[LocalMusicPlayerManager sharedManager] playMusic:[NSURL URLWithString:filePath]];
            }
            else
            {
                NSString* filePath = [[NSBundle mainBundle] pathForResource:@"ring_invalid.mp3" ofType: @""];
                [[LocalMusicPlayerManager sharedManager] playMusic:[NSURL URLWithString:filePath]];
            }
        }
        else
        {
            NSString* filePath = [[NSBundle mainBundle] pathForResource:@"ring_invalid.mp3" ofType: @""];
            [[LocalMusicPlayerManager sharedManager] playMusic:[NSURL URLWithString:filePath]];
        }
        
        canRing = FALSE;
    }
}

- (IBAction)didGoProjectButtonPressed:(id)sender
{
    if ( self.card )
    {
        UINavigationController* naviVc = (UINavigationController*)((MMDrawerController*)[UIApplication sharedApplication].keyWindow.rootViewController).centerViewController;
        NSLog(@"%d",naviVc.viewControllers.count);

        if ( naviVc.viewControllers.count == 1 )
        {
            PadProjectViewController *viewController = [[PadProjectViewController alloc] initWithMemberCard:self.card couponCard:nil handno:@""];
            viewController.delegate = naviVc.viewControllers[0];
            [naviVc pushViewController:viewController animated:YES];
        }
        else if ( naviVc.viewControllers.count == 2 )
        {
            UIViewController* vc = naviVc.viewControllers[1];
            if ( [vc isKindOfClass:[PadProjectViewController class]] )
            {
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.card.member, @"member", nil];
                [params setObject:self.card forKey:@"card"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kPadSelectMemberAndCardFinish object:@(FALSE) userInfo:params];
            }
            else
            {
                [naviVc popToRootViewControllerAnimated:NO];
                PadProjectViewController *viewController = [[PadProjectViewController alloc] initWithMemberCard:self.card couponCard:nil handno:@""];
                viewController.delegate = naviVc.viewControllers[0];
                [naviVc pushViewController:viewController animated:YES];
            }
        }
        else
        {
            [naviVc popToRootViewControllerAnimated:NO];
            PadProjectViewController *viewController = [[PadProjectViewController alloc] initWithMemberCard:self.card couponCard:nil handno:@""];
            viewController.delegate = naviVc.viewControllers[0];
            [naviVc pushViewController:viewController animated:YES];
        }
        
        [self.maskView hidden];
    }
}

@end
