//
//  MemberMessageTemplateViewController.m
//  Boss
//
//  Created by lining on 16/5/27.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "MemberMessageTemplateViewController.h"
#import "MessageTemplateCollectionViewCell.h"
#import "UINavigationBar+Background.h"
#import "CBMessageView.h"
#import "UIImage+Resizable.h"
#import "BSPageControl.h"
#import "MemberMessageSelectedViewController.h"


typedef enum TemplateType
{
    TemplateType_Birthday,
    TemplateType_Shalong,
    TemplateType_Jieri,
    TemplateType_Liwu,
    TemplateType_Youhui,
    TemplateType_Yuyue,
    TemplateType_Num
}TemplateType;

#define TemplateType_Birthday   @"生日"
#define TemplateType_Shalong    @"沙龙"
#define TemplateType_Jieri      @"节日"
#define TemplateType_Liwu       @"礼物"
#define TemplateType_Youhui     @"优惠"
#define TemplateType_Yuyue      @"预约"
#define TemplateType_Custom     @"自定义"

@interface MemberMessageTemplateViewController ()<MFMessageComposeViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray *templateItems;
@property (nonatomic, strong) BSPageControl *pageControl;
@end

@implementation MemberMessageTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BNBackButtonItem *backButtonItem = [[BNBackButtonItem alloc] initWithNormalImage:[UIImage imageNamed:@"navi_back_n"] highlightedImage:[UIImage imageNamed:@"navi_back_h"]];
    backButtonItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backButtonItem;
    

    if (self.selectedPeoples.count > 0) {
        self.navigationItem.title = @"群发";
        
        self.countLabel.text = [NSString stringWithFormat:@"你将发送消息给%d位会员:",self.selectedPeoples.count];
        
        NSMutableString *nameString = [NSMutableString string];
        for (CDMember *member in self.selectedPeoples) {
            [nameString appendString:member.memberName];
            [nameString appendString:@"，"];
        }
        [self.namesLabel setPreferredMaxLayoutWidth:IC_SCREEN_WIDTH - 40];
        self.namesLabel.text = [nameString substringToIndex:nameString.length - 1];
    }
    else
    {
        self.navigationItem.title = @"发送短信";
        
        self.countLabel.text = [NSString stringWithFormat:@"你将发送消息给:"];
        
        [self.namesLabel setPreferredMaxLayoutWidth:IC_SCREEN_WIDTH - 40];
        self.namesLabel.text = self.member.memberName;
    }
    
    [self initData];
    [self initCollectionView];
    
    self.templateBgView.image = [[UIImage imageNamed:@"member_msg_template_bg.png"] imageResizableWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    [self initPageControlDot];
    
}




#pragma mark - init data
- (void)initData
{
    self.templateItems = [NSMutableArray array];
    NSArray *titles;
    if (self.qunfa) {
         titles = @[TemplateType_Birthday,TemplateType_Shalong,TemplateType_Jieri,TemplateType_Liwu,TemplateType_Youhui];
    }
    else
    {
        titles = @[TemplateType_Birthday,TemplateType_Shalong,TemplateType_Jieri,TemplateType_Liwu,TemplateType_Youhui,TemplateType_Custom];
    }
   
    for (int i = 0; i < titles.count; i++) {
        TemplateItem *item = [[TemplateItem alloc] init];
        item.imgName = [NSString stringWithFormat:@"member_msg_template_%02d.png",i+1];
        item.name = titles[i];
        [self.templateItems addObject:item];
    }
}


#pragma mark - initCollectionView
- (void) initCollectionView
{
    self.collectionView.pagingEnabled = true;
    [self.collectionView registerNib:[UINib nibWithNibName:@"MessageTemplateCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MessageTemplateCollectionViewCell"];
}

#pragma mark - initControlDot
- (void) initPageControlDot
{
    int dotCount = ceil(self.templateItems.count/6.0);
    self.pageControl = [[BSPageControl alloc] initWithImgName:@"member_msg_template_dot_n.png" highlightImgName:@"member_msg_template_dot_h.png" numberOfPages:dotCount];
    [self.dotBgView addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.centerOffset(CGPointZero);
    }];
    if (dotCount == 1) {
        self.pageControl.hidden = true;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    int current = round(scrollView.contentOffset.x/self.collectionView.frame.size.width);
    self.pageControl.currentPage = current;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ceil(self.templateItems.count/6.0) * 6;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTemplateCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MessageTemplateCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.row < self.templateItems.count) {
        TemplateItem *item = [self.templateItems objectAtIndex:indexPath.row];
        collectionViewCell.item = item;
    }
    else
    {
        collectionViewCell.item = nil;
    }
    
    return collectionViewCell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.frame.size.width)/3.0, (collectionView.frame.size.height)/2.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.templateItems.count) {
        return;
    }
    
    TemplateItem *item = [self.templateItems objectAtIndex:indexPath.row];
    if ([item.name isEqualToString:TemplateType_Custom]) {
        if (self.member) {
            [self sendMsg];
        }
        return;
    }
    
    MemberMessageSelectedViewController *selectedVC = [[MemberMessageSelectedViewController alloc] init];
    selectedVC.type = @"birthday";
    selectedVC.peoples = self.selectedPeoples;
    selectedVC.qunfa = self.qunfa;
    selectedVC.member = self.member;
    [self.navigationController pushViewController:selectedVC animated:YES];
    
}


#pragma mark - send message
#pragma mark - 发送短信
-(void)sendMsg
{
    if ([BSMessageNavigationController canSendText])
    {
        __weak typeof(self) wself = self;
        [wself.navigationController.navigationBar setCustomizedNaviBar:NO];
        BSMessageNavigationController *messageVC = [[BSMessageNavigationController alloc] init];
        [messageVC.navigationBar setCustomizedNaviBar:NO];
        //        messageVC.view.backgroundColor = [UIColor clearColor];
        if ([messageVC.navigationBar respondsToSelector: @selector(setTitleTextAttributes:)])
        {
            NSDictionary* attrDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      COLOR(0, 165, 254,1), UITextAttributeTextColor,
                                      [UIFont boldSystemFontOfSize:20.0], UITextAttributeFont,
                                      nil];
            [messageVC.navigationBar setTitleTextAttributes: attrDict];
        }
        messageVC.recipients = [NSArray arrayWithObject:wself.member.mobile];
        [messageVC setBody:[NSString stringWithFormat:[NSString stringWithFormat:@""]]];
        
        messageVC.messageComposeDelegate = wself;
      
        [wself.navigationController presentViewController:messageVC animated:YES completion:nil];
    }
}


#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (result == MessageComposeResultFailed) {
        [[[CBMessageView alloc] initWithTitle:@"短信发送失败"] show];
    }
    else if (result == MessageComposeResultSent)
    {
        [[[CBMessageView alloc] initWithTitle:@"短信发送成功"] show];
    }
    [self.navigationController.navigationBar setCustomizedNaviBar:YES];
    [self performSelector:@selector(dismissMessageVC:) withObject:controller afterDelay:1.25];
}

- (void)dismissMessageVC:(MFMessageComposeViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:^{
//        [self.navigationController popViewControllerAnimated:NO];
    }];
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end


