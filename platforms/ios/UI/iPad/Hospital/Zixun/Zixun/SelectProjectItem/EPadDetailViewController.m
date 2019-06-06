//
//  EPadDetailViewController.m
//  meim
//
//  Created by 波恩公司 on 2018/3/23.
//

#import "EPadDetailViewController.h"
#import "EPadMenuViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

typedef enum kEPadDetailSection
{
    kEPadDetailSectionTupian = 0,
    kEPadDetailSectionXiangqing,
    kEPadDetailSectionYiqi,
    kEPadDetailSectionAnli,
    kEPadDetailSectionYisheng,
    kEPadDetailSectionXuangou,
    kEPadDetailSectionCount
}kEPadDetailSection;

@interface EPadDetailViewController ()<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) NSArray *compareArray;
@property (nonatomic, strong) NSArray *yiqiArray;
@property (nonatomic, strong) NSArray *doctorArray;
@property (nonatomic, strong) NSArray *selectItemArray;
@property (nonatomic, strong) NSArray *imgOrVideoArray;
@property (nonatomic, strong) NSArray *productArray;
@property (nonatomic, strong) NSMutableArray *videoArray;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation EPadDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR(242, 245, 245, 1);
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(175, 0, 672, 768)];
//    self.scrollView.layer.cornerRadius = 15.0;
    self.scrollView.backgroundColor = COLOR(242, 245, 245, 1);
    self.scrollView.contentSize = CGSizeMake(672, 768+44+15);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(31, 31, 36, 36)];
    [self.closeButton setImage:[UIImage imageNamed:@"pad_emenu_cross"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];
    
    self.imgOrVideoArray = [self.item objectForKey:@"main_image_ids"];
    self.yiqiArray = [self.item objectForKey:@"equipment_ids"];
    self.compareArray = [self.item objectForKey:@"mix_image_ids"];
    self.doctorArray = [self.item objectForKey:@"technician_ids"];
    self.productArray = [self.item objectForKey:@"product_ids"];
    self.videoArray = [[NSMutableArray alloc] init];
    [self initScrollView];

    NSTimer *scrollTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(settingScroll) userInfo:nil repeats:YES];
    [scrollTimer fire];
}

- (void)initScrollView
{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 672, 768 + 30 + 44)];
    view.layer.cornerRadius = 15.0;
    view.backgroundColor =[UIColor whiteColor];
    view.clipsToBounds = YES;
    
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 672, 768-44) style:UITableViewStyleGrouped];
    self.tableView.scrollEnabled = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = YES;
    self.tableView.allowsSelection = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor =[UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [view addSubview:self.tableView];
//    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(560, 420, 90, 36)];
//    addButton.layer.cornerRadius = 18.0;
//    addButton.backgroundColor = COLOR(153, 194, 64, 1);
//    UILabel *huakouLabel = [[UILabel alloc] initWithFrame:CGRectMake(560, 460, 90, 16)];
//    huakouLabel.textColor = [UIColor whiteColor];
//    huakouLabel.text = @"卡内已有项目";
//    huakouLabel.textAlignment = NSTextAlignmentCenter;
//    huakouLabel.font = [UIFont systemFontOfSize:12];
//    [view addSubview:huakouLabel];
//    huakouLabel.hidden = YES;
//    NSLog(@"Item:%@",self.item.itemID);
//    BOOL hasItemInCard = NO;
//    for (CDMemberCardProject *project in self.memberCard.projects)
//    {
//        NSLog(@"Project:%@",project.projectCount);
//        if ([project.item.itemID intValue] == [self.item.itemID intValue] && project.projectCount > 1)
//        {
//            hasItemInCard = YES;
//            break;
//        }
//        else
//        {
//            hasItemInCard = NO;
//        }
//    }
//    if (hasItemInCard) {
//        [addButton setTitle:@"划扣" forState:UIControlStateNormal];
//        huakouLabel.hidden = NO;
//    }
//    else
//    {
//        [addButton setTitle:@"添加" forState:UIControlStateNormal];
//        huakouLabel.hidden = YES;
//    }
//    addButton.titleLabel.font = [UIFont systemFontOfSize:20];
//    [addButton addTarget:self action:@selector(addItemToList) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:addButton];
//
//    UILabel *itemNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 542, 300, 22)];
//    itemNameLabel.text = self.item.itemName;
//    itemNameLabel.textColor = [UIColor blackColor];
//    itemNameLabel.font = [UIFont systemFontOfSize:22];
//    itemNameLabel.textAlignment = NSTextAlignmentLeft;
//    [view addSubview:itemNameLabel];
//    NSLog(@"%@",self.item);

//    UILabel *itemHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 730, 300, 22)];
//    itemHintLabel.text = @"[重要提示]";
//    itemHintLabel.textColor = COLOR(131, 130, 135, 1);
//    itemHintLabel.font = [UIFont systemFontOfSize:16];
//    [view addSubview:itemHintLabel];
//    UITextView *itemHintTextView = [[UITextView alloc] initWithFrame:CGRectMake(28, 760, 618, 122)];
//    if ([self.item.description_notice isEqualToString:@"0"] || self.item.description_notice.length == 0)
//    {
//        itemHintTextView.text = @"暂无提示";
//    }
//    else
//    {
//        itemHintTextView.text = self.item.description_notice;
//    }
//    itemHintTextView.textColor = COLOR(131, 130, 135, 1);
//    itemHintTextView.font = [UIFont systemFontOfSize:16];
//    [view addSubview:itemHintTextView];
//
    [self.scrollView addSubview:view];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)close
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)addItemToList
{
    NSLog(@"%@",self.parentViewController);
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[EPadMenuViewController class]])
        {
            EPadMenuViewController *parentViewController = (EPadMenuViewController *)viewController;
            //[parentViewController didItemSelected:self.item.itemID];
        }
    }
    [self close];
}

#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kEPadDetailSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kEPadDetailSectionTupian)
    {
        return 1;
    }
    else if (section == kEPadDetailSectionXiangqing)
    {
        return 1;
    }
    else if (section == kEPadDetailSectionYiqi)
    {
        return 1;
    }
    else if (section == kEPadDetailSectionAnli)
    {
        return self.compareArray.count;
    }
    else if (section == kEPadDetailSectionYisheng)
    {
        return self.doctorArray.count;
    }
    else if (section == kEPadDetailSectionXuangou)
    {
        return self.productArray.count/2;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == kEPadDetailSectionTupian)
    {
        return 0;
    }
    else if (section == kEPadDetailSectionXiangqing)
    {
        return 80;
    }
    else if (section == kEPadDetailSectionYiqi)
    {
        if (self.yiqiArray.count == 0)
        {
            return 0;
        }
    }
    else if (section == kEPadDetailSectionAnli)
    {
        if (self.compareArray.count == 0)
        {
            return 0;
        }
    }
    else if (section == kEPadDetailSectionYisheng)
    {
        if (self.doctorArray.count == 0)
        {
            return 0;
        }
    }
    else if (section == kEPadDetailSectionXuangou)
    {
        if (self.productArray.count == 0)
        {
            return 0;
        }
    }
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kEPadDetailSectionTupian)
    {
        return 504;
    }
    else if (indexPath.section == kEPadDetailSectionXiangqing)
    {
        if ([[NSString stringWithFormat:@"%@", [self.item objectForKey:@"note"]] isEqualToString:@"0"] || [[NSString stringWithFormat:@"%@", [self.item objectForKey:@"note"]] length] == 0)
        {
            return 0;
        }
        CGFloat contentheight = [[self.item objectForKey:@"note"] boundingRectWithSize:CGSizeMake(614,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]} context:nil].size.height+40;
        return contentheight;
    }
    else if (indexPath.section == kEPadDetailSectionYiqi)
    {
        if (self.yiqiArray.count == 0)
        {
            return 0;
        }
        else
        {
            return 192;
        }
    }
    else if (indexPath.section == kEPadDetailSectionAnli)
    {
        if (self.compareArray.count == 0)
        {
            return 0;
        }
        else
        {
            return 318;
        }
    }
    else if (indexPath.section == kEPadDetailSectionYisheng)
    {
        if (self.doctorArray.count == 0)
        {
            return 0;
        }
        else
        {
            return 180;
        }
    }
    else if (indexPath.section == kEPadDetailSectionXuangou)
    {
        if (self.productArray.count == 0)
        {
            return 0;
        }
        else
        {
            return 123;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 672, 80)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 40, 200, 40)];
    label.font = [UIFont systemFontOfSize:22 weight:UIFontWeightMedium];
    if (section == kEPadDetailSectionTupian)
    {
        headerView.frame = CGRectZero;
    }
    else if (section == kEPadDetailSectionXiangqing)
    {
        label.text = [self.item objectForKey:@"name"];
    }
    else if (section == kEPadDetailSectionYiqi)
    {
        label.text = @"仪器";
    }
    else if (section == kEPadDetailSectionAnli)
    {
        label.text = @"客户案例";
    }
    else if (section == kEPadDetailSectionYisheng)
    {
        label.text = @"医生介绍";
    }
    else if (section == kEPadDetailSectionXuangou)
    {
        label.text = @"选购项目";
    }
    [headerView addSubview:label];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == kEPadDetailSectionXuangou)
    {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 672, 66)];
        footerView.backgroundColor = [UIColor whiteColor];
        return footerView;
    }
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kEPadDetailSectionTupian)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kEPadDetailSectionTupian"];
        UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 672, 504)];
        imageScrollView.pagingEnabled = NO;
        imageScrollView.contentSize = CGSizeMake(672 * self.imgOrVideoArray.count, 504);
        imageScrollView.tag = 9999;
        imageScrollView.delegate = self;
        imageScrollView.showsHorizontalScrollIndicator = NO;
        if (self.imgOrVideoArray.count > 1)
        {
            self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(300, 450, 72, 20)];
            self.pageControl.numberOfPages = self.imgOrVideoArray.count;
            CGSize pointSize = [self.pageControl sizeForNumberOfPages:self.imgOrVideoArray.count];
            CGFloat page_x = -(self.pageControl.bounds.size.width - pointSize.width) / 2 ;
            [self.pageControl setBounds:CGRectMake(page_x, self.pageControl.bounds.origin.y,self.pageControl.bounds.size.width, self.pageControl.bounds.size.height)];
            self.pageControl.currentPage = 0;
            self.pageControl.currentPageIndicatorTintColor = COLOR(153, 194, 64, 1);
            //self.pageControl.backgroundColor = [UIColor blueColor];
            self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        }
        for (int i=0; i<self.imgOrVideoArray.count; i++)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*672, 0, 672, 504)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[self.imgOrVideoArray[i] objectForKey:@"image_url"]] placeholderImage:[UIImage imageNamed:@"pad_project_background_h"] completed:nil];
            [imageScrollView addSubview:imageView];
            if ([[self.imgOrVideoArray[i] objectForKey:@"type"] isEqualToString:@"video"])
            {
                NSURL *url;
                if ([[self.imgOrVideoArray[i] objectForKey:@"video_upload_type"] isEqualToString:@"online"])
                {
                    NSLog(@"%@",[self.imgOrVideoArray[i] objectForKey:@"video_url"]);
                    NSString *str = [[self.imgOrVideoArray[i] objectForKey:@"video_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    url = [NSURL URLWithString:str];
                    [self.videoArray addObject:url];

//                    NSURLRequest *request=[NSURLRequest requestWithURL:url];
//                    [videoWebView loadRequest:request];
//                    [videoWebView stopLoading];
                }
                else
                {
                    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                    doc=[doc stringByAppendingPathComponent:[self.imgOrVideoArray[i] objectForKey:@"file_name"]];
                    url = [NSURL fileURLWithPath:doc];
                    [self.videoArray addObject:url];

//                    NSURLRequest *request=[NSURLRequest requestWithURL:url];
//                    [videoWebView loadRequest:request];
                }

                
                UIButton *playVideo = [[UIButton alloc] initWithFrame:CGRectMake(i*672+306, 220, 60, 60)];
                [playVideo setImage:[UIImage imageNamed:@"play_video"] forState:UIControlStateNormal];
                [playVideo addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
                playVideo.tag = i;
                [imageScrollView addSubview:playVideo];
//                UIWebView *videoWebView = [[UIWebView alloc] initWithFrame:CGRectMake(i*672, 0, 672, 504)];
//                videoWebView.contentMode = UIViewContentModeScaleAspectFill;
//                videoWebView.scalesPageToFit = YES;
//                videoWebView.mediaPlaybackRequiresUserAction = YES;
//                videoWebView.scrollView.scrollEnabled = NO;
//                NSLog(@"%@",doc);
//
//                NSURL *url;
//                NSString *urlStr;
//                NSLog(@"%@",url);
//
//                [imageScrollView addSubview:videoWebView];
            }
            else
            {
                NSURL *url = [[NSURL alloc] init];
                [self.videoArray addObject:url];
            }
        }
        [cell addSubview:imageScrollView];
        [cell addSubview:self.pageControl];
        return cell;
    }
    else if (indexPath.section == kEPadDetailSectionXiangqing)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kEPadDetailSectionXiangqing"];
        UILabel *itemIntroLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 300, 22)];
        itemIntroLabel.text = @"[简介]";
        itemIntroLabel.textColor = COLOR(131, 130, 135, 1);
        itemIntroLabel.font = [UIFont systemFontOfSize:16];
        //[cell addSubview:itemIntroLabel];
        NSLog(@"%@",[self.item objectForKey:@"note"]);
        if ([[NSString stringWithFormat:@"%@", [self.item objectForKey:@"note"]] isEqualToString:@"0"] || [[NSString stringWithFormat:@"%@", [self.item objectForKey:@"note"]] length] == 0)
        {
            return cell;
        }
        CGFloat contentheight = [[self.item objectForKey:@"note"] boundingRectWithSize:CGSizeMake(614,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]} context:nil].size.height + 40;
        UITextView *itemIntroTextView = [[UITextView alloc] initWithFrame:CGRectMake(30, 20, 614, contentheight)];
        
        NSLog(@"%@",self.item);
        if ([[NSString stringWithFormat:@"%@", [self.item objectForKey:@"note"]] isEqualToString:@"0"] || [[NSString stringWithFormat:@"%@", [self.item objectForKey:@"note"]] length] == 0)
        {
            itemIntroTextView.text = @"暂无简介";
        }
        else
        {
            itemIntroTextView.text = [self.item objectForKey:@"note"];
        }
        itemIntroTextView.editable = NO;
        itemIntroTextView.textColor = COLOR(131, 130, 135, 1);
        itemIntroTextView.font = [UIFont systemFontOfSize:16];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 6;// 字体的行间距
        
        NSDictionary *attributes = @{NSForegroundColorAttributeName:COLOR(131.0, 130.0, 135.0, 1.0), NSFontAttributeName:[UIFont systemFontOfSize:16], NSParagraphStyleAttributeName:paragraphStyle};
        itemIntroTextView.attributedText = [[NSAttributedString alloc] initWithString:itemIntroTextView.text attributes:attributes];
        [cell addSubview:itemIntroTextView];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(30, contentheight-1, 612, 1)];
        line.backgroundColor = COLOR(0, 0, 0, 0.19);
        //[cell addSubview:line];
        return cell;
    }
    else if (indexPath.section == kEPadDetailSectionYiqi)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kEPadDetailSectionYiqi"];
        UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(30, 24, 612, 192)];
        imageScrollView.pagingEnabled = YES;
        imageScrollView.contentSize = CGSizeMake(276 * 5 - 20, 192);
        imageScrollView.showsHorizontalScrollIndicator = NO;
        for (int i=0; i<self.yiqiArray.count; i++)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*276, 0, 256, 192)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[self.yiqiArray[i] objectForKey:@"image_url"]] placeholderImage:[UIImage imageNamed:@"pad_project_background_h"] completed:nil];
            imageView.layer.cornerRadius = 2;
            [imageScrollView addSubview:imageView];
        }
        [cell addSubview:imageScrollView];
        return cell;
        
    }
    else if (indexPath.section == kEPadDetailSectionAnli)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kEPadDetailSectionAnli"];
        UIImageView *mixImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 24, 612, 294)];
        if ([[self.compareArray[indexPath.row] objectForKey:@"image_url"] length] > 0)
        {
            [mixImageView sd_setImageWithURL:[self.compareArray[indexPath.row] objectForKey:@"image_url"]];
        }
        [cell addSubview:mixImageView];
        return cell;
    }
    else if (indexPath.section == kEPadDetailSectionYisheng)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kEPadDetailSectionYisheng"];
        UIImageView *doctorHeadImage = [[UIImageView alloc] initWithFrame:CGRectMake(30, 20, 80, 80)];
        [doctorHeadImage sd_setImageWithURL:[NSURL URLWithString:[self.doctorArray[indexPath.row] objectForKey:@"main_image_id"]] placeholderImage:[UIImage imageNamed:@"pad_project_background_h"] completed:nil];
        doctorHeadImage.layer.cornerRadius = 14;
        doctorHeadImage.layer.masksToBounds = YES;
        [cell addSubview:doctorHeadImage];
        
        UILabel *doctorName = [[UILabel alloc] initWithFrame:CGRectMake(120, 20, 100, 18)];
        doctorName.font = [UIFont systemFontOfSize:18];
        doctorName.text = [NSString stringWithFormat:@"%@",[self.doctorArray[indexPath.row] objectForKey:@"name"]];
        [cell addSubview:doctorName];
        
        UILabel *doctorTitle = [[UILabel alloc] initWithFrame:CGRectMake(220, 22, 300, 18)];
        doctorTitle.font = [UIFont systemFontOfSize:14];
        doctorTitle.textColor = COLOR(112, 109, 110, 1);
        doctorTitle.text = [NSString stringWithFormat:@"职位：%@", [self.doctorArray[indexPath.row] objectForKey:@"title"]];
        [cell addSubview:doctorTitle];
        
        UILabel *doctorTechnique = [[UILabel alloc] initWithFrame:CGRectMake(120, 45, 520, 35)];
        doctorTechnique.font = [UIFont systemFontOfSize:14];
        doctorTechnique.textColor = COLOR(112, 109, 110, 1);
        doctorTechnique.numberOfLines = 0;
        doctorTechnique.text = [NSString stringWithFormat:@"擅长项目：%@", [self.doctorArray[indexPath.row] objectForKey:@"technique"]];
        //[cell addSubview:doctorTechnique];
        
        UITextView *doctorRemark = [[UITextView alloc] initWithFrame:CGRectMake(120, 45, 520, 120)];
        doctorRemark.font = [UIFont systemFontOfSize:14];
        doctorRemark.textColor = COLOR(112, 109, 110, 1);
        doctorRemark.text = [NSString stringWithFormat:@"擅长项目：%@\n介绍：%@", [self.doctorArray[indexPath.row] objectForKey:@"technique"],[self.doctorArray[indexPath.row] objectForKey:@"remark"]];
        //doctorRemark.numberOfLines = 0;
        [cell addSubview:doctorRemark];
        
        UIView *line = [[UIView alloc] init];
        if (indexPath.row == self.doctorArray.count-1)
        {
            line.frame = CGRectMake(30, 170, 610, 1);
        }
        else
        {
            line.frame = CGRectMake(120, 170, 520, 1);
        }
        line.backgroundColor = COLOR(205, 206, 211, 1);
        [cell addSubview:line];
        return cell;
    }
    else if (indexPath.section == kEPadDetailSectionXuangou)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kEPadDetailSectionXuangou"];
        
        CDProjectItem *leftItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:[self.productArray[indexPath.row*2] objectForKey:@"product_template_id"] forKey:@"itemID"];
        UIImageView *leftItemImage = [[UIImageView alloc] initWithFrame:CGRectMake(30, 20, 80, 80)];
        leftItemImage.layer.cornerRadius = 14;
        [leftItemImage sd_setImageWithURL:[NSURL URLWithString:leftItem.imageUrl] placeholderImage:[UIImage imageNamed:@"pad_project_background_h"] completed:nil];
        [cell addSubview:leftItemImage];
        
        UILabel *leftItemName = [[UILabel alloc] initWithFrame:CGRectMake(120, 20, 180, 50)];
        leftItemName.font = [UIFont systemFontOfSize:16];
        leftItemName.text = leftItem.itemName;
        leftItemName.numberOfLines = 2;
        CGFloat contentWidth = [leftItem.itemName boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,40.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.width;
        if (contentWidth < 180) {
            leftItemName.text = [leftItem.itemName stringByAppendingString:@"\n"];
        }
        [cell addSubview:leftItemName];
        
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 70, 80, 30)];
        leftButton.layer.cornerRadius = 15;
        leftButton.tag = indexPath.row*2;
        UILabel *leftHuakouLabel = [[UILabel alloc] initWithFrame:CGRectMake(205, 70, 80, 30)];
        leftHuakouLabel.text = @"卡内已有项目";
        leftHuakouLabel.textColor = COLOR(153, 153, 153, 1);
        leftHuakouLabel.font = [UIFont systemFontOfSize:10];
        [cell addSubview:leftHuakouLabel];
        BOOL hasItemInCardLeft = NO;
        for (CDMemberCardProject *project in self.memberCard.projects)
        {
            NSLog(@"Project:%@",project.projectCount);
            if ([project.item.itemID intValue] == [leftItem.itemID intValue] && [project.projectCount intValue] > 0)
            {
                hasItemInCardLeft = YES;
                break;
            }
            else
            {
                hasItemInCardLeft = NO;
            }
        }
        if (hasItemInCardLeft) {
            [leftButton setTitle:@"划扣" forState:UIControlStateNormal];
            [leftButton setTitleColor:COLOR(153, 194, 64, 1) forState:UIControlStateNormal];
            leftButton.backgroundColor = COLOR(242, 245, 245, 1);
            [leftButton addTarget:self action:@selector(huakouItem:) forControlEvents:UIControlEventTouchUpInside];
            leftHuakouLabel.hidden = NO;
        }
        else
        {
            [leftButton setTitle:@"购买" forState:UIControlStateNormal];
            [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            leftButton.backgroundColor = COLOR(153, 194, 64, 1);
            [leftButton addTarget:self action:@selector(buyItem:) forControlEvents:UIControlEventTouchUpInside];
            leftHuakouLabel.hidden = YES;
        }
        [cell addSubview:leftButton];
        
        if(indexPath.row*2+1 >= self.productArray.count)
        {
            return cell;
        }
        CDProjectItem *rightItem = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:[self.productArray[indexPath.row*2+1] objectForKey:@"product_template_id"] forKey:@"itemID"];
        UIImageView *rightItemImage = [[UIImageView alloc] initWithFrame:CGRectMake(350, 20, 80, 80)];
        rightItemImage.layer.cornerRadius = 14;
        [rightItemImage sd_setImageWithURL:[NSURL URLWithString:rightItem.imageUrl] placeholderImage:[UIImage imageNamed:@"pad_project_background_h"] completed:nil];
        [cell addSubview:rightItemImage];
        
        UILabel *rightItemName = [[UILabel alloc] initWithFrame:CGRectMake(440, 20, 180, 50)];
        rightItemName.font = [UIFont systemFontOfSize:16];
        rightItemName.text = rightItem.itemName;
        rightItemName.numberOfLines = 2;
        CGFloat rightContentWidth = [rightItem.itemName boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,40.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.width;
        if (rightContentWidth < 180) {
            rightItemName.text = [rightItem.itemName stringByAppendingString:@"\n"];
        }
        [cell addSubview:rightItemName];
        
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(440, 70, 80, 30)];
        rightButton.layer.cornerRadius = 15;
        rightButton.tag = indexPath.row*2+1;
        UILabel *rightHuakouLabel = [[UILabel alloc] initWithFrame:CGRectMake(525, 70, 80, 30)];
        rightHuakouLabel.text = @"卡内已有项目";
        rightHuakouLabel.textColor = COLOR(153, 153, 153, 1);
        rightHuakouLabel.font = [UIFont systemFontOfSize:10];
        [cell addSubview:rightHuakouLabel];
        BOOL hasItemInCardRight = NO;
        for (CDMemberCardProject *project in self.memberCard.projects)
        {
            NSLog(@"Project:%@",project.projectCount);
            if ([project.item.itemID intValue] == [rightItem.itemID intValue] && [project.projectCount intValue] > 1)
            {
                hasItemInCardRight = YES;
                break;
            }
            else
            {
                hasItemInCardRight = NO;
            }
        }
        if (hasItemInCardRight) {
            [rightButton setTitle:@"划扣" forState:UIControlStateNormal];
            [rightButton setTitleColor:COLOR(153, 194, 64, 1) forState:UIControlStateNormal];
            rightButton.backgroundColor = COLOR(242, 245, 245, 1);
            [rightButton addTarget:self action:@selector(huakouItem:) forControlEvents:UIControlEventTouchUpInside];
            rightHuakouLabel.hidden = NO;
        }
        else
        {
            [rightButton setTitle:@"购买" forState:UIControlStateNormal];
            [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            rightButton.backgroundColor = COLOR(153, 194, 64, 1);
            [rightButton addTarget:self action:@selector(buyItem:) forControlEvents:UIControlEventTouchUpInside];
            rightHuakouLabel.hidden = YES;
        }
        [cell addSubview:rightButton];
        
//        UILabel *doctorTitle = [[UILabel alloc] initWithFrame:CGRectMake(200, 22, 200, 18)];
//        doctorTitle.font = [UIFont systemFontOfSize:14];
//        doctorTitle.textColor = COLOR(112, 109, 110, 1);
//        doctorTitle.text = [NSString stringWithFormat:@"职位：%@", [self.doctorArray[indexPath.row] objectForKey:@"title"]];
//        [cell addSubview:doctorTitle];
        
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kEPadDetailDefault"];
        return cell;
    }
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
////    if (scrollView == self.tableView) {
////        NSLog(@"TableView Scrolled");
////    }
//    if(scrollView == self.scrollView)
//    {
//        if (scrollView.contentOffset.y > 0) {
//            self.tableView.scrollEnabled = YES;
//        }
//        else{
//            self.tableView.scrollEnabled = NO;
//        }
//    }
//}

- (void)settingScroll
{
//    if (self.scrollView.contentOffset.y >= 44)
//    {
//        self.tableView.scrollEnabled = YES;
//    }
//    else
//    {
//        self.tableView.scrollEnabled = NO;
//    }
//    if (self.tableView.contentOffset.y == 0)
//    {
//        self.scrollView.scrollEnabled = YES;
//    }
//    else
//    {
//        self.scrollView.scrollEnabled = NO;
//    }
}

- (void)buyItem:(UIButton *)button
{
    if ([self.fromView isEqualToString:@"Home"]) {
        return;
    }
    
    CDProjectItem *item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:[self.productArray[button.tag] objectForKey:@"product_template_id"] forKey:@"itemID"];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"是否确定购买%@", item.itemName] message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[EPadMenuViewController class]])
            {
                EPadMenuViewController *parentViewController = (EPadMenuViewController *)viewController;
                //[parentViewController didItemSelected:[self.productArray[button.tag] objectForKey:@"product_template_id"]];
                [parentViewController didBuyItemSelected:item.itemID andName:item.itemName];
            }
        }
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)huakouItem:(UIButton *)button
{
    CDProjectItem *item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:[self.productArray[button.tag] objectForKey:@"product_template_id"] forKey:@"itemID"];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"是否确定划扣%@", item.itemName] message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[EPadMenuViewController class]])
            {
                EPadMenuViewController *parentViewController = (EPadMenuViewController *)viewController;
                CDProjectItem *item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:[self.productArray[button.tag] objectForKey:@"product_template_id"] forKey:@"itemID"];
                [parentViewController didUseItemSelected:item.itemID andName:item.itemName];
                
            }
        }
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)playVideo:(UIButton *)button
{
    
    //1、创建AVPlayer
    /*
     本地视频
     NSURL *url = [[NSBundle mainBundle]URLForResource:@"IMG_9638.m4v" withExtension:nil];
     AVPlayer *player = [AVPlayer playerWithURL:url];
     */
    //网页视频
    AVPlayer *player1 = [AVPlayer playerWithURL:self.videoArray[button.tag]];
    //2、创建视频播放视图的控制器
    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc]init];
    //3、将创建的AVPlayer赋值给控制器自带的player
    playerVC.player = player1;
    //4、跳转到控制器播放
    [self presentViewController:playerVC animated:YES completion:nil];
    [playerVC.player play];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 9999)
    {
        int page = scrollView.contentOffset.x / scrollView.frame.size.width;
        self.pageControl.currentPage = page;
    }
}

@end
