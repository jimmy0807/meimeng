//
//  PadReserveViewController.m
//  Boss
//
//  Created by XiaXianBing on 15/12/14.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "PadReserveViewController.h"
#import "PadProjectData.h"
#import "PadReserveCell.h"
#import "PadProjectSideCell.h"
#import "BSFetchBookRequest.h"

@interface PadReserveViewController ()

@property (nonatomic, strong) NSArray *reserves;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UITableView *reserveTabelView;

@end


@implementation PadReserveViewController

- (id)initWithDelegate:(id<PadReserveViewControllerDelegate>)delegate
{
    self = [super initWithNibName:@"PadReserveViewController" bundle:nil];
    if (self)
    {
        self.selectedIndex = -1;
        self.delegate = delegate;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0.0, 0.0, kPadMaskViewWidth, IC_SCREEN_HEIGHT);
    
    [self registerNofitificationForMainThread:kFetchBookResponse];
    self.reserves = [[BSCoreDataManager currentManager] fetchTodayBooks];
    
    self.reserveTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, kPadMaskViewWidth, IC_SCREEN_HEIGHT - kPadNaviHeight) style:UITableViewStylePlain];
    self.reserveTabelView.backgroundColor = [UIColor clearColor];
    self.reserveTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.reserveTabelView.dataSource = self;
    self.reserveTabelView.delegate = self;
    self.reserveTabelView.showsVerticalScrollIndicator = NO;
    self.reserveTabelView.showsHorizontalScrollIndicator = NO;
    self.reserveTabelView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.reserveTabelView];
    
    UIImage *naviImage = [UIImage imageNamed:@"pad_navi_background"];
    UIImageView *navi = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, naviImage.size.height)];
    navi.backgroundColor = [UIColor clearColor];
    navi.image = naviImage;
    navi.userInteractionEnabled = YES;
    [self.view addSubview:navi];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadNaviHeight, 0.0, self.view.frame.size.width - 2 * kPadNaviHeight, kPadNaviHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = COLOR(48.0, 48.0, 48.0, 1.0);
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    titleLabel.text = LS(@"PadTodayReserveList");
    [navi addSubview:titleLabel];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.backgroundColor = [UIColor clearColor];
    confirmButton.frame = CGRectMake(self.view.frame.size.width - 90.0, 0.0, 90.0, kPadNaviHeight);
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [confirmButton setTitle:LS(@"PadMakeSureButton") forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_n"] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"pad_normal_button_h"] forState:UIControlStateHighlighted];
    [confirmButton addTarget:self action:@selector(didConfirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:confirmButton];
    
    BSFetchBookRequest *request = [[BSFetchBookRequest alloc] init];
    [request execute];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)didConfirmButtonClick:(id)sender
{
    [self.maskView hidden];
    
    if (self.reserves.count != 0 && self.selectedIndex >= 0 && self.selectedIndex < self.reserves.count)
    {
        CDBook *book = [self.reserves objectAtIndex:self.selectedIndex];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPadReserveConfirm:)])
        {
            [self.delegate didPadReserveConfirm:book];
        }
    }
}


#pragma mark -
#pragma mark NSNotification Methods

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kFetchBookResponse])
    {
        if ([[notification.userInfo objectForKey:@"rc"] integerValue] >= 0)
        {
            self.reserves = [[BSCoreDataManager currentManager] fetchTodayBooks];
            [self.reserveTabelView reloadData];
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


#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reserves.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPadReserveCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PadReserveCellIdentifier";
    PadReserveCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[PadReserveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell isSelectImageViewSelected:NO];
    if (indexPath.row == self.selectedIndex)
    {
        [cell isSelectImageViewSelected:YES];
    }
    
    CDBook *book = [self.reserves objectAtIndex:indexPath.row];
    cell.nameLabel.text = book.booker_name;
    cell.phoneLabel.text = book.telephone;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *startDate = [dateFormatter dateFromString:book.start_date];
    NSDate *endDate = [dateFormatter dateFromString:book.end_date];
    dateFormatter.dateFormat = @"yyyy.MM.dd";
    cell.dateLabel.text = [dateFormatter stringFromDate:startDate];
    dateFormatter.dateFormat = @"HH:mm";
    cell.timeLabel.text = [NSString stringWithFormat:@"%@ - %@", [dateFormatter stringFromDate:startDate], [dateFormatter stringFromDate:endDate]];
    cell.technicianLabel.text = [NSString stringWithFormat:LS(@"PadReserveTechnician"), book.technician_name];
    cell.itemLabel.text = [NSString stringWithFormat:LS(@"PadReserveItemName"), book.product_name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectedIndex == indexPath.row)
    {
        self.selectedIndex = -1;
    }
    else
    {
        self.selectedIndex = indexPath.row;
    }
    [self.reserveTabelView reloadData];
}

@end
