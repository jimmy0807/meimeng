//
//  PrintSettingView.m
//  meim
//
//  Created by 波恩公司 on 2017/12/21.
//

#import "PrintSettingView.h"
#import "GetPrintServerRequest.h"
#import "BSUpdatePersonalInfoRequest.h"
#import "BSUploadPrintUrlRequest.h"

#define kPrintSettingViewBackgroundTag   999

@interface PrintSettingView ()

@property(nonatomic, strong)UITextField *printerAddress;
@property(nonatomic, strong)NSArray *printerArray;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIView *bottomView;
@property(nonatomic)int currentIndex;
@property(nonatomic)int selectPrinterID;
@end

@implementation PrintSettingView

- (id)init
{
    self = [super initWithFrame:CGRectMake(0.0, 0.0, IC_SCREEN_WIDTH, IC_SCREEN_HEIGHT)];
    if (self)
    {
        [self registerNofitificationForMainThread:@"GetPrintServerResponse"];
        [self registerNofitificationForMainThread:kBSUpdatePersonalInfoResponse];
        
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;

        self.bgView = [[UIImageView alloc] initWithFrame: self.bounds];
        self.bgView.alpha = 0.5;
        self.bgView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.bgView];
        
        UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(242, 98, 540, 573)];
        mainView.backgroundColor = COLOR(242, 245, 245, 1);
        mainView.layer.cornerRadius = 4;
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 540, 75)];
        topView.backgroundColor = [UIColor whiteColor];
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 85, 75)];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:COLOR(153, 153, 153, 1) forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [cancelButton addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:cancelButton];
        
        UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(455, 0, 85, 75)];
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [saveButton setTitleColor:COLOR(96, 211, 212, 1) forState:UIControlStateNormal];
        saveButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [saveButton addTarget:self action:@selector(updatePrinter) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:saveButton];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 140, 75)];
        titleLabel.text = @"打印机设置";
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.textColor = COLOR(37, 37, 37, 1);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [topView addSubview:titleLabel];
        
        UILabel *currentPrinter = [[UILabel alloc] initWithFrame:CGRectMake(25, 100, 200, 25)];
        currentPrinter.text = @"当前打印机地址";
        currentPrinter.font = [UIFont boldSystemFontOfSize:16];
        currentPrinter.textColor = COLOR(149, 171, 171, 1);
        currentPrinter.textAlignment = NSTextAlignmentLeft;
        [topView addSubview:currentPrinter];
        [mainView addSubview:topView];

        self.printerAddress = [[UITextField alloc] initWithFrame:CGRectMake(25, 140, 490, 45)];
        self.printerAddress.placeholder = @"请输入打印机的地址";
        self.printerAddress.backgroundColor = [UIColor whiteColor];
        self.printerAddress.borderStyle = UITextBorderStyleRoundedRect;
        self.printerAddress.layer.cornerRadius = 8;
        self.printerAddress.layer.borderColor = [COLOR(197, 210, 210, 0.7) CGColor];
        self.printerAddress.font = [UIFont systemFontOfSize:16];
        [mainView addSubview:self.printerAddress];
        
        UILabel *choosePrinter = [[UILabel alloc] initWithFrame:CGRectMake(25, 210, 200, 25)];
        choosePrinter.text = @"选取打印机";
        choosePrinter.font = [UIFont boldSystemFontOfSize:16];
        choosePrinter.textColor = COLOR(149, 171, 171, 1);
        choosePrinter.textAlignment = NSTextAlignmentLeft;
        [mainView addSubview:choosePrinter];
        
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(25, 250, 490, 25 + self.printerArray.count*45)];
        self.bottomView.backgroundColor = [UIColor whiteColor];
        self.bottomView.layer.cornerRadius = 8;
        self.bottomView.layer.borderColor = [COLOR(197, 210, 210, 0.7) CGColor];
        self.bottomView.layer.borderWidth = 1;
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 12, 490, (self.printerArray.count>6?6:self.printerArray.count)*45)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.bounces = NO;
        [self.bottomView addSubview:self.tableView];
        self.currentIndex = 0;
        [mainView addSubview:self.bottomView];
        
        [self addSubview:mainView];
        GetPrintServerRequest *request = [[GetPrintServerRequest alloc] init];
        [request execute];
        //[self reloadTableView];
    }
    
    return self;
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"GetPrintServerResponse"])
    {
        self.printerArray = [notification.userInfo objectForKey:@"data"];
        
        if (self.printerArray.count > 0)
        {
            NSMutableArray *newArray = [NSMutableArray arrayWithArray:self.printerArray];
            NSDictionary *selectedPrinter = [NSMutableDictionary dictionary];
            for (NSDictionary *printer in newArray) {
                if ([[PersonalProfile currentProfile].printID intValue] == [[printer objectForKey:@"id"] intValue]) {
                    selectedPrinter = printer;
                }
            }
            [newArray removeObject:selectedPrinter];
            [newArray insertObject:selectedPrinter atIndex:0];
            self.printerArray = newArray;
            self.selectPrinterID = [[self.printerArray[0] objectForKey:@"id"] intValue];
            [self reloadTableView];
        }
    }
    else if ([notification.name isEqualToString:kBSUpdatePersonalInfoResponse])
    {
        [self hidden];
    }
}

- (void)reloadTableView
{
    self.bottomView.frame = CGRectMake(25, 250, 490, 25 + self.printerArray.count*45);
    self.tableView.frame = CGRectMake(0, 12, 490, (self.printerArray.count>6?6:self.printerArray.count)*45);
    self.printerAddress.text = [self.printerArray[self.currentIndex] objectForKey:@"url"];
    [self.tableView reloadData];
}

- (void)show
{
    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
    NSLog(@"%@",mainWindow.gestureRecognizers);
    [mainWindow addSubview:self];
}

- (void)hidden
{
    [self removeFromSuperview];
    [self removeNotificationOnMainThread:@"GetPrintServerResponse"];
    [self removeNotificationOnMainThread:kBSUpdatePersonalInfoResponse];
}

- (void)removeSubviews
{
    for (UIView *subview in self.subviews)
    {
        if (subview.tag != kPrintSettingViewBackgroundTag)
        {
            [subview removeFromSuperview];
        }
    }
    
    self.navi = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.printerArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentIndex = indexPath.row;
    self.printerAddress.text = [self.printerArray[indexPath.row] objectForKey:@"url"];
    self.selectPrinterID = [[self.printerArray[indexPath.row] objectForKey:@"id"] intValue];
    [self reloadTableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PrinterCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    else
    {
        for (UIView *subView in cell.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    UILabel *printerName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 490, 45)];
    NSLog(@"%@",self.printerArray[indexPath.row]);
    printerName.text = [self.printerArray[indexPath.row] objectForKey:@"name"];
    printerName.textAlignment = NSTextAlignmentCenter;
    if (self.currentIndex == indexPath.row)
    {
        printerName.textColor = [UIColor whiteColor];
        cell.backgroundColor = COLOR(96, 211, 212, 1);
    }
    else
    {
        printerName.textColor = COLOR(153, 153, 153, 1);
        cell.backgroundColor = [UIColor whiteColor];
    }
    printerName.tag = 200+indexPath.row;
    if (indexPath.row > 0)
    {
        UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 490, 1)];
        separatorLine.backgroundColor = COLOR(224, 230, 230, 1);
        [cell addSubview:separatorLine];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = 100+indexPath.row;
    [cell addSubview:printerName];
    return cell;
}

- (void)updatePrinter
{
    [PersonalProfile currentProfile].printUrl = self.printerAddress.text;
    [PersonalProfile currentProfile].printID = [NSNumber numberWithInt:self.selectPrinterID];
    [[PersonalProfile currentProfile] save];
    //BSUpdatePersonalInfoRequest *request = [[BSUpdatePersonalInfoRequest alloc] initWithParams:@{@"print_url":self.printerAddress.text}];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    BSUploadPrintUrlRequest *request = [[BSUploadPrintUrlRequest alloc] init];
    params[@"print_url"] = self.printerAddress.text;
    params[@"print_id"] = @(self.selectPrinterID);
    request.params = params;
    [request execute];
    [self hidden];
}
@end
