//
//  HPatientShoushuLineTagViewController.m
//  meim
//
//  Created by jimmy on 2017/8/14.
//
//

#import "HPatientShoushuLineTagViewController.h"
#import "UIImage+Resizable.h"
#import "HPatientShoushuTagSelectTableViewCell.h"
#import "HPatientShoushuTagCreateTableViewCell.h"
#import "CreateH9ShoushuTagRequest.h"
#import "CBLoadingView.h"
#import "CBMessageView.h"
#import "ChineseToPinyin.h"

@interface HPatientShoushuLineTagViewController ()<UISearchBarDelegate>
@property(nonatomic, weak)IBOutlet UIView* bgView;
@property (nonatomic, strong)UISearchBar* searchBar;
@property(nonatomic, weak)IBOutlet UITableView* tableView;
@property(nonatomic, strong)NSArray* tagArray;
@property(nonatomic, strong)NSMutableSet* selectedTagSet;
@end

@implementation HPatientShoushuLineTagViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setHeaderView];
}

- (void)reloadData
{
    self.tagArray = [[BSCoreDataManager currentManager] fetchH9Shoushutag:self.searchBar.text];
    [self.tableView reloadData];
}

- (void)showWithAnimation:(NSArray*)tagIDs
{
    __block CGRect frame = self.bgView.frame;
    frame.origin.x = 1024;
    self.bgView.frame = frame;
    
    [UIView animateWithDuration:0.15 animations:^{
        frame.origin.x = 684;
        self.bgView.frame = frame;
    }];
    
    self.selectedTagSet = [NSMutableSet set];
    
    for ( NSString* n in tagIDs )
    {
        if ( [n isKindOfClass:[NSString class]] )
        {
            CDH9ShoushuTag* tag = [[BSCoreDataManager currentManager] findEntity:@"CDH9ShoushuTag" withValue:n forKey:@"tag_id"];
            if ( tag )
            {
                [self.selectedTagSet addObject:tag];
            }
        }
    }
    
    [self reloadData];
}

- (void)hideWithAnimation
{
    [UIView animateWithDuration:0.15 animations:^{
        CGRect frame = self.bgView.frame;
        frame.origin.x = 1024;
        self.bgView.frame = frame;
    } completion:^(BOOL finished) {
        self.view.superview.hidden = YES;
    }];
}

- (IBAction)didBackButtonPressed:(id)sender
{
    [self hideWithAnimation];
}

- (IBAction)didConfirmButtonPressed:(id)sender
{
    NSMutableArray* tagIDs = [NSMutableArray array];
    NSMutableArray* tagNames = [NSMutableArray array];
    NSArray* objects = [self.selectedTagSet.allObjects sortedArrayUsingComparator:^NSComparisonResult(CDH9ShoushuTag*  _Nonnull obj1, CDH9ShoushuTag*  _Nonnull obj2) {
        return [obj1.memberNameLetter compare:obj2.memberNameLetter];
    }];
    
    for (CDH9ShoushuTag* tag in objects )
    {
        [tagIDs addObject:tag.tag_id];
        [tagNames addObject:tag.name];
    }
    
    self.didTagSelectedFinsihed(tagIDs, [tagNames componentsJoinedByString:@","]);
    
    [self hideWithAnimation];
}

- (void)setHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 64.0)];
    headerView.backgroundColor = [UIColor clearColor];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(20, 8, self.tableView.frame.size.width - 2 * 20, 64.0 - 16)];
    
    self.searchBar.layer.borderWidth = 1;
    self.searchBar.layer.cornerRadius = 3;
    self.searchBar.layer.masksToBounds = YES;
    self.searchBar.layer.borderColor = COLOR(237, 237, 237, 1).CGColor;
    [self.searchBar setBackgroundImage:[[UIImage imageNamed:@"pad_search_bar_background"] imageResizableWithCapInsets:UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)]];
    self.searchBar.returnKeyType = UIReturnKeySearch;
    self.searchBar.placeholder = @"请输入搜索内容";
    self.searchBar.delegate = self;
    [headerView addSubview:self.searchBar];
    
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 )
    {
        if ( self.searchBar.text.length > 0 )
        {
            return 2;
        }
        else
        {
            return 1;
        }
    }
    else if ( section == 1 )
    {
        return self.tagArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 )
    {
        HPatientShoushuTagCreateTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HPatientShoushuTagCreateTableViewCell"];
        
        if ( indexPath.row == 0 )
        {
            if ( self.searchBar.text.length > 0 )
            {
                cell.nameLabel.text = [NSString stringWithFormat:@"新建\"%@\"",self.searchBar.text];
            }
            else
            {
                cell.nameLabel.text = @"创建并编辑";
            }
        }
        else
        {
            cell.nameLabel.text = @"创建并编辑";
        }
        
        return cell;
    }
    else
    {
        HPatientShoushuTagSelectTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HPatientShoushuTagSelectTableViewCell"];
        
        CDH9ShoushuTag* tag = self.tagArray[indexPath.row];
        cell.nameLabel.text = tag.name;
        cell.checkIcon.hidden = ![self.selectedTagSet containsObject:tag];
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 )
    {
        if ( indexPath.row == 0 )
        {
            if ( self.searchBar.text.length == 0 )
            {
                [self showEditView:nil];
            }
            else
            {
                [self createTag:nil text:self.searchBar.text];
            }
        }
        else
        {
            [self showEditView:nil];
        }
    }
    else if ( indexPath.section == 1 )
    {
        CDH9ShoushuTag* tag = self.tagArray[indexPath.row];
        if ( [self.selectedTagSet containsObject:tag] )
        {
            [self.selectedTagSet removeObject:tag];
        }
        else
        {
            [self.selectedTagSet addObject:tag];
        }
        [self reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section > 0 )
    {
        return TRUE;
    }
    
    return FALSE;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf;
    UITableViewRowAction* rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        CDH9ShoushuTag* tag = self.tagArray[indexPath.row];
        [weakSelf showEditView:tag];
    }];
    
    rowAction.backgroundColor = COLOR(255, 72, 72, 1);
    
    return @[rowAction];
}

- (void)showEditView:(CDH9ShoushuTag*)tag
{
    __block UITextField* tempTextField;
    
    UIAlertController *alertControll = [UIAlertController alertControllerWithTitle:@"手术标签" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *save = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self createTag:tag text:tempTextField.text];
    }];
    
    [alertControll addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = self.searchBar.text;
        textField.placeholder = @"请输入";
        tempTextField = textField;
    }];
    
    [alertControll addAction:cancel];
    [alertControll addAction:save];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertControll animated:YES completion:nil];
}

- (void)createTag:(CDH9ShoushuTag*)tag text:(NSString*)text
{
    WeakSelf;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    params[@"name"] = text;
    if ( tag )
    {
        params[@"tag_id"] = tag.tag_id;
    }
    
    CreateH9ShoushuTagRequest* request = [[CreateH9ShoushuTagRequest alloc] init];
    request.params = params;
    [request execute];
    [[CBLoadingView shareLoadingView] show];

    request.requestFinished = ^(NSDictionary *params, NSNumber *tagID) {
        [[CBLoadingView shareLoadingView] hide];
        if ( [params[@"rc"] integerValue] == 0 )
        {
            if ( tag )
            {
                tag.name = text;
                tag.memberNameLetter = [ChineseToPinyin pinyinFromChiniseString:tag.name];
                tag.memberNameFirstLetter = [[ChineseToPinyin pinyinFirstLetterString:tag.name] uppercaseString];
            }
            else
            {
                CDH9ShoushuTag* newTag = [[BSCoreDataManager currentManager] insertEntity:@"CDH9ShoushuTag"];
                newTag.name = text;
                newTag.tag_id = tagID;
                newTag.memberNameLetter = [ChineseToPinyin pinyinFromChiniseString:tag.name];
                newTag.memberNameFirstLetter = [[ChineseToPinyin pinyinFirstLetterString:tag.name] uppercaseString];
            }
            
            [[BSCoreDataManager currentManager] save];
            
            [weakSelf reloadData];
        }
        else
        {
            [[[CBMessageView alloc] initWithTitle:params[@"rm"]] show];
        }
    };
}

@end
