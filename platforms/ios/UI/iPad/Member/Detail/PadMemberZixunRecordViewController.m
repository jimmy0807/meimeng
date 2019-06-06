//
//  PadMemberZixunRecordViewController.m
//  meim
//
//  Created by 波恩公司 on 2018/1/29.
//

#import "PadMemberZixunRecordViewController.h"
#import "PadProjectConstant.h"
#ifdef meim_dev
#import "meim_dev-Swift.h"
#else
#import "meim-Swift.h"
#endif

@interface PadMemberZixunRecordViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CDMember *member;
@property (nonatomic, strong) CDCouponCard *couponCard;
@property (nonatomic, strong) NSArray *zixunArray;
@property (nonatomic, strong) UITableView *zixunTableView;
@property (nonatomic, strong) NSMutableDictionary *inkImageDictionary;
@property (nonatomic, strong) NSMutableDictionary *photoImageDictionary;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *inkView;

@end

@implementation PadMemberZixunRecordViewController

- (id)initWithMember:(CDMember *)member
{
    self = [super initWithNibName:@"PadMemberZixunRecordViewController" bundle:nil];
    if (self)
    {
        self.member = member;
        FetchQiantaiZixunRequest *request = [[FetchQiantaiZixunRequest alloc] init];
        request.searchKeyWord = [NSString stringWithFormat:@"%@",self.member.memberName];
        [request execute];
        self.inkImageDictionary = [[NSMutableDictionary alloc] init];
        self.photoImageDictionary = [[NSMutableDictionary alloc] init];
        self.couponCard = nil;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.noKeyboardNotification = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self registerNofitificationForMainThread:kFetchZixunResponse];
    [self registerNofitificationForMainThread:kPadSelectMemberCardFinish];
    
    self.zixunTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, kPadNaviHeight, self.view.frame.size.width, self.view.frame.size.height - kPadNaviHeight) style:UITableViewStylePlain];
    self.zixunTableView.backgroundColor = [UIColor clearColor];
    self.zixunTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.zixunTableView.delegate = self;
    self.zixunTableView.dataSource = self;
    self.zixunTableView.showsVerticalScrollIndicator = NO;
    self.zixunTableView.showsHorizontalScrollIndicator = NO;
    self.zixunTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.zixunTableView];
    
    UIImageView *naviImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, kPadNaviHeight + 3.0)];
    naviImageView.backgroundColor = [UIColor clearColor];
    naviImageView.image = [UIImage imageNamed:@"pad_navi_background"];
    naviImageView.userInteractionEnabled = YES;
    [self.view addSubview:naviImageView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    backButton.frame = CGRectMake(0.0, 0.0, 2 * 66.0, kPadNaviHeight);
    UIImage *backImage = [UIImage imageNamed:@"pad_navi_back_n"];
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(66.0 - kPadNaviHeight + 20.0, 0.0, kPadNaviHeight, kPadNaviHeight)];
    backImageView.backgroundColor = [UIColor clearColor];
    backImageView.image = backImage;
    [backButton addSubview:backImageView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(66.0, 0.0, 66.0, kPadNaviHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.textColor = COLOR(148.0, 172.0, 172.0, 1.0);
    titleLabel.text = @"咨询记录";
    [backButton addSubview:titleLabel];
    [backButton addTarget:self action:@selector(didBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [naviImageView addSubview:backButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)didBackButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kFetchZixunResponse])
    {
        self.zixunArray = [[BSCoreDataManager currentManager] fetchAllZixunWithType:nil keyword:self.member.memberName memberID:nil zixunID:nil];
        [self.zixunTableView reloadData];
    }
    else if ([notification.name isEqualToString:kPadSelectMemberCardFinish])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource && UIScrollViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.zixunArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDZixun *zixun = self.zixunArray[indexPath.row];
    if ([self checkInkImageExist:zixun])
    {
        return 310.0;
    }
    else
    {
        return 175.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PadCardProductCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    else
    {
        for (UIView *view in cell.subviews)
        {
            [view removeFromSuperview];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CDZixun *zixun = self.zixunArray[indexPath.row];
    
    UILabel *customerStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 30, 50, 16)];
    customerStateLabel.textColor = COLOR(37, 37, 37, 1);
    customerStateLabel.font = [UIFont boldSystemFontOfSize:16];
    customerStateLabel.text = zixun.customer_state_name;
    [cell addSubview:customerStateLabel];
    
    UILabel *designLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 300, 16)];
    designLabel.textColor = COLOR(37, 37, 37, 1);
    designLabel.font = [UIFont systemFontOfSize:16];
    designLabel.text = [NSString stringWithFormat:@"设计师：%@，设计总监：%@", zixun.designer_name, zixun.director_name];
    [cell addSubview:designLabel];
    
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(450, 30, 100, 16)];
    stateLabel.textColor = COLOR(90, 211, 213, 1);
    stateLabel.textAlignment = NSTextAlignmentRight;
    stateLabel.font = [UIFont systemFontOfSize:16];
    stateLabel.text = zixun.state_name;
    //[cell addSubview:stateLabel];
    
    NSString *timeAndRoomString = [NSString stringWithFormat:@"咨询时间：%@   咨询室：%@", zixun.advisory_start_date, zixun.room_name];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
    CGSize size = [timeAndRoomString boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    CGFloat timeAndRoomWidth = size.width;
    UILabel *timeAndRoomLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 66, timeAndRoomWidth, 16)];
    timeAndRoomLabel.textColor = COLOR(112, 109, 110, 1);
    timeAndRoomLabel.font = [UIFont systemFontOfSize:14];
    timeAndRoomLabel.text = timeAndRoomString;
    [cell addSubview:timeAndRoomLabel];
    
    if ([self checkPhotoExist:zixun])
    {
        UIButton *checkPhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(timeAndRoomWidth+65, 67, 100, 14)];
        NSMutableAttributedString* titleString = [[NSMutableAttributedString alloc] initWithString:@"查看照片"];
        [titleString addAttribute:NSUnderlineStyleAttributeName
                          value:@(NSUnderlineStyleSingle)
                          range:(NSRange){0,[titleString length]}];
        [titleString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0,[titleString length])];
        //此时如果设置字体颜色要这样
        [titleString addAttribute:NSForegroundColorAttributeName value:COLOR(47, 143, 255, 1)  range:NSMakeRange(0,[titleString length])];
        //设置下划线颜色...
        [titleString addAttribute:NSUnderlineColorAttributeName value:COLOR(47, 143, 255, 1) range:(NSRange){0,[titleString length]}];
        [checkPhotoButton setAttributedTitle:titleString forState:UIControlStateNormal];
        checkPhotoButton.tag = indexPath.row;
        [checkPhotoButton addTarget:self action:@selector(checkPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:checkPhotoButton];
        
        NSMutableArray *photoUrlArray = [[NSMutableArray alloc] init];
        NSArray *imageArray = [zixun.image_urls componentsSeparatedByString:@","];
        for (NSString *url in imageArray)
        {
            NSString *last = [url componentsSeparatedByString:@"@"].lastObject;
            if ([last isEqualToString:@"f"])
            {
                [photoUrlArray addObject:[url componentsSeparatedByString:@"@"][1]];
            }
        }
        [self.photoImageDictionary setObject:photoUrlArray forKey:[NSString stringWithFormat:@"%d",checkPhotoButton.tag]];
    }
    
    CGFloat adjustHeight = 0.0;
    NSMutableArray *imageUrlArray = [[NSMutableArray alloc] init];
    if ([self checkInkImageExist:zixun])
    {
        adjustHeight = 135;
        NSArray *imageArray = [zixun.image_urls componentsSeparatedByString:@","];
        for (NSString *url in imageArray)
        {
            NSString *last = [url componentsSeparatedByString:@"@"].lastObject;
            if ([last isEqualToString:@"t"])
            {
                [imageUrlArray addObject:[url componentsSeparatedByString:@"@"][1]];
            }
        }
        UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(50, 100, 530, 124)];
        imageScrollView.contentSize = CGSizeMake(530, 124+134*(int)(imageUrlArray.count/4));
        //imageScrollView.pagingEnabled = YES;
        imageScrollView.scrollEnabled = YES;
        imageScrollView.showsVerticalScrollIndicator = YES;
        imageScrollView.showsHorizontalScrollIndicator = NO;
        imageScrollView.bounces = YES;
        [imageScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        imageScrollView.delegate = self;
        //imageScrollView.backgroundColor = [UIColor yellowColor];
        for (int i = 0; i < imageUrlArray.count; i++)
        {
            UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(0+(i%4)*134, 0+(int)(i/4)*134, 124, 124)];
            NSURL *url = [NSURL URLWithString:imageUrlArray[i]];
            UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            [imageButton setImage:image forState:UIControlStateNormal];
            imageButton.tag = 1000 * indexPath.row + i;
            [imageButton addTarget:self action:@selector(checkInkImage:) forControlEvents:UIControlEventTouchUpInside];
            [imageScrollView addSubview:imageButton];
            [self.inkImageDictionary setObject:image forKey:[NSString stringWithFormat:@"%d",imageButton.tag]];
        }
        [cell addSubview:imageScrollView];
    }
    
    UILabel *productLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 103+adjustHeight, 500, 16)];
    productLabel.textColor = COLOR(112, 109, 110, 1);
    productLabel.font = [UIFont systemFontOfSize:14];
    productLabel.text = [NSString stringWithFormat:@"方案项目：%@", zixun.product_names];
    [cell addSubview:productLabel];
    
    UILabel *conditionLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 122+adjustHeight, 500, 16)];
    conditionLabel.textColor = COLOR(112, 109, 110, 1);
    conditionLabel.font = [UIFont systemFontOfSize:14];
    conditionLabel.text = [NSString stringWithFormat:@"咨询备注：%@", zixun.condition];
    [cell addSubview:conditionLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(50, 174+adjustHeight, 503, 1)];
    line.backgroundColor = COLOR(220, 224, 224, 1);
    [cell addSubview:line];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (BOOL)checkPhotoExist:(CDZixun *)zixun
{
    NSArray *imageArray = [zixun.image_urls componentsSeparatedByString:@","];
    for (NSString *url in imageArray)
    {
        NSString *last = [url componentsSeparatedByString:@"@"].lastObject;
        if ([last isEqualToString:@"f"])
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)checkInkImageExist:(CDZixun *)zixun
{
    NSArray *imageArray = [zixun.image_urls componentsSeparatedByString:@","];
    for (NSString *url in imageArray)
    {
        NSString *last = [url componentsSeparatedByString:@"@"].lastObject;
        if ([last isEqualToString:@"t"])
        {
            return YES;
        }
    }
    return NO;
}

- (void)checkPhoto:(UIButton *)button
{
    NSLog(@"%d",button.tag);
    NSLog(@"%@",[self.photoImageDictionary objectForKey:[NSString stringWithFormat:@"%d",button.tag]]);
    NSArray *imageUrlArray = [self.photoImageDictionary objectForKey:[NSString stringWithFormat:@"%d",button.tag]];
    CGRect fullScreenFrame = [UIApplication sharedApplication].keyWindow.rootViewController.view.frame;
    self.bgView = [[UIView alloc] initWithFrame:fullScreenFrame];
    self.bgView.backgroundColor = COLOR(0, 0, 0, 0.3);
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(150, 0, 724, 768)];
    centerView.backgroundColor = [UIColor whiteColor];
    
    UIView *topNaviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 724, 78)];
    topNaviView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pad_navi_background"]];
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
    [closeButton setImage:[UIImage imageNamed:@"pad_close_button_n"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeBgView) forControlEvents:UIControlEventTouchUpInside];
    [topNaviView addSubview:closeButton];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(300, 0, 124, 75)];
    titleLabel.text = @"查看照片";
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [topNaviView addSubview:titleLabel];
    [centerView addSubview:topNaviView];
    
    UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(70, 105, 580, 660)];
    imageScrollView.contentSize = CGSizeMake(580, 660+660*(int)(imageUrlArray.count/12));
    imageScrollView.scrollEnabled = YES;
    imageScrollView.showsVerticalScrollIndicator = YES;
    imageScrollView.showsHorizontalScrollIndicator = NO;
    imageScrollView.bounces = YES;
    [imageScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    imageScrollView.delegate = self;
    for (int i = 0; i < imageUrlArray.count; i++)
    {
        UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(0+(i%3)*190, 0+(int)(i/3)*166, 184, 138)];
        NSURL *url = [NSURL URLWithString:imageUrlArray[i]];
        
        imageButton.tag = 10000 * button.tag + i;
        [imageButton addTarget:self action:@selector(checkInkImage:) forControlEvents:UIControlEventTouchUpInside];
        imageButton.backgroundColor = [UIColor blackColor];
        [imageScrollView addSubview:imageButton];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0+(i%3)*190, 0+(int)(i/3)*166, 184, 138)];
        UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        if (image == nil)
        {
            break;
        }
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageScrollView addSubview:imageView];
        [self.inkImageDictionary setObject:image forKey:[NSString stringWithFormat:@"%d",imageButton.tag]];
    }
    [centerView addSubview:imageScrollView];
    [self.bgView addSubview:centerView];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.bgView];
}

- (void)checkInkImage:(UIButton *)button
{
    NSLog(@"%d",button.tag);
    NSLog(@"%@",[self.inkImageDictionary objectForKey:[NSString stringWithFormat:@"%d",button.tag]]);
    [self showInk:[self.inkImageDictionary objectForKey:[NSString stringWithFormat:@"%d",button.tag]]];
}

- (void)showInk:(UIImage *)image
{
    self.inkView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.rootViewController.view.frame];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.inkView.frame];
    imageView.backgroundColor = [UIColor blackColor];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.inkView addSubview:imageView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeInk)];
    [self.inkView addGestureRecognizer:tapGesture];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.inkView];
}

- (void)closeInk
{
    self.inkView.hidden = YES;
    [self.inkView removeFromSuperview];
}

- (void)closeBgView
{
    self.bgView.hidden = YES;
    [self.bgView removeFromSuperview];
}

@end
