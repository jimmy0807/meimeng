//
//  PadProjectYimeiBuweiPhotoViewController.m
//  meim
//
//  Created by jimmy on 17/2/20.
//
//

#import "PadProjectYimeiBuweiPhotoViewController.h"
#import "BuweiPhotoNameTableViewCell.h"
#import "ProjectBuweiManager.h"

typedef enum YimeiBuweiPhotoTab
{
    YimeiBuweiPhotoTab_head,
    YimeiBuweiPhotoTab_body
}YimeiBuweiPhotoTab;

@interface PadProjectYimeiBuweiPhotoViewController ()<UIScrollViewDelegate>
{
    YimeiBuweiPhotoTab currentTabIndex;
}
@property(nonatomic, weak)IBOutlet UITableView* itemTableView;
@property(nonatomic, weak)IBOutlet UIButton* tabBuButton;
@property(nonatomic, strong)NSMutableArray* headArray;
@property(nonatomic, strong)NSMutableArray* bodyArray;
@property(nonatomic, strong)UIView* headView;
@property(nonatomic, strong)UIView* bodyView;
@end

@implementation PadProjectYimeiBuweiPhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ( self.item )
    {
        self.product = (CDPosProduct*)self.item;
    }
    
    [self loadHeadView];
    [self loadBodyView];
    self.bodyView.hidden = YES;
    
    [self.itemTableView registerNib:[UINib nibWithNibName:@"BuweiPhotoNameTableViewCell" bundle:nil] forCellReuseIdentifier:@"BuweiPhotoNameTableViewCell"];
}

- (void)loadHeadView
{
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 75, 708, 693)];
    [self.view addSubview:self.headView];
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:self.headView.bounds];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.maximumZoomScale = 4;
    scrollView.minimumZoomScale = 1.0;
    scrollView.delegate = self;
    [self.headView addSubview:scrollView];
    
    UIView* contentView = [[UIView alloc] initWithFrame:self.headView.bounds];
    contentView.tag = 101;
    [scrollView addSubview:contentView];
    
    UIImageView* bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yimei_photo_head"]];
    [contentView addSubview:bgImageView];
    
    [[ProjectBuweiManager sharedManager].headArray enumerateObjectsUsingBlock:^(NSDictionary* loc, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake([loc[@"x"] floatValue], [loc[@"y"] floatValue], [loc[@"width"] floatValue], [loc[@"height"] floatValue]);
        btn.tag = 1000 + idx;
        [btn addTarget:self action:@selector(didHeadButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btn];
    }];
}

- (void)loadBodyView
{
    self.bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, 75, 708, 693)];
    [self.view addSubview:self.bodyView];
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:self.bodyView.bounds];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.maximumZoomScale = 2.5;
    scrollView.minimumZoomScale = 1.0;
    scrollView.delegate = self;
    [self.bodyView addSubview:scrollView];
    
    UIView* contentView = [[UIView alloc] initWithFrame:self.bodyView.bounds];
    contentView.tag = 101;
    [scrollView addSubview:contentView];
    
    UIImageView* bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yimei_photo_body"]];
    [contentView addSubview:bgImageView];
    
    [[ProjectBuweiManager sharedManager].bodyArray enumerateObjectsUsingBlock:^(NSDictionary* loc, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake([loc[@"x"] floatValue], [loc[@"y"] floatValue], [loc[@"width"] floatValue], [loc[@"height"] floatValue]);
        btn.tag = 2000 + idx;
        [btn addTarget:self action:@selector(didBodyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btn];
    }];
}

- (void)didHeadButtonPressed:(UIButton*)btn
{
    NSInteger index = btn.tag - 1000;
    NSString* title = [ProjectBuweiManager sharedManager].headArray[index][@"name"];
    for ( CDYimeiBuwei* buwei in self.product.yimei_buwei )
    {
        if ( [buwei.name isEqualToString:title] )
        {
            buwei.count = @(buwei.count.floatValue + 1);
            [self.itemTableView reloadData];
            [self checkCount];
            return;
        }
    }
    
    CDYimeiBuwei* buwei = [[BSCoreDataManager currentManager] insertEntity:@"CDYimeiBuwei"];
    buwei.name = title;
    buwei.count = @(1);
    
    NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.product.yimei_buwei];
    [orderedSet addObject:buwei];
    self.product.yimei_buwei = orderedSet;
    
    [self checkCount];
    
    [[BSCoreDataManager currentManager] save:nil];
    [self.itemTableView reloadData];
}

- (void)didBodyButtonPressed:(UIButton*)btn
{
    NSInteger index = btn.tag - 2000;
    
    NSString* title = [ProjectBuweiManager sharedManager].bodyArray[index][@"name"];
    for ( CDYimeiBuwei* buwei in self.product.yimei_buwei )
    {
        if ( [buwei.name isEqualToString:title] )
        {
            buwei.count = @(buwei.count.floatValue + 1);
            [self.itemTableView reloadData];
            [self checkCount];
            return;
        }
    }
    
    CDYimeiBuwei* buwei = [[BSCoreDataManager currentManager] insertEntity:@"CDYimeiBuwei"];
    buwei.name = title;
    buwei.count = @(1);
    
    NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.product.yimei_buwei];
    [orderedSet addObject:buwei];
    self.product.yimei_buwei = orderedSet;
    
    [self checkCount];
    
    [[BSCoreDataManager currentManager] save:nil];
    [self.itemTableView reloadData];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView viewWithTag:101];
}

#if 0
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIView* v = [scrollView viewWithTag:101];
    v.center = scrollView.center;
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
    v.center = CGPointMake(scrollView.contentSize.width/2 + offsetX,scrollView.contentSize.height/2 + offsetY);
}
#endif

- (IBAction)didHeadTabPressed:(id)sender
{
    currentTabIndex = YimeiBuweiPhotoTab_head;
    [self.tabBuButton setImage:[UIImage imageNamed:@"yimei_buwei_tab_head_n"] forState:UIControlStateNormal];
    self.bodyView.hidden = YES;
    self.headView.hidden = NO;
}

- (IBAction)didBodyTabPressed:(id)sender
{
    currentTabIndex = YimeiBuweiPhotoTab_body;
    [self.tabBuButton setImage:[UIImage imageNamed:@"yimei_buwei_tab_head_h"] forState:UIControlStateNormal];
    self.bodyView.hidden = NO;
    self.headView.hidden = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.product.yimei_buwei.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuweiPhotoNameTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BuweiPhotoNameTableViewCell"];
    
    CDYimeiBuwei* buwei = self.product.yimei_buwei[indexPath.row];
    cell.buwei = buwei;
    
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.product.yimei_buwei];
        [orderedSet removeObjectAtIndex:indexPath.row];
        self.product.yimei_buwei = orderedSet;
        [self.itemTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (IBAction)didCloseButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (void)didPadNumberKeyboardDonePressed:(UITextField*)textField
{
    BuweiPhotoNameTableViewCell* cell = (BuweiPhotoNameTableViewCell*)textField.superview.superview;
    CGFloat count = [textField.text floatValue];
    NSIndexPath* path = [self.itemTableView indexPathForCell:cell];
    CDYimeiBuwei* buwei = self.product.yimei_buwei[path.row];
    buwei.count = @(count);
    [[BSCoreDataManager currentManager] save:nil];
    [self checkCount];
}

- (void)checkCount
{
    for ( CDYimeiBuwei* buwei in self.product.yimei_buwei )
    {
        
    }
}

@end
