//
//  SeletctListViewController.m
//  meim
//
//  Created by jimmy on 2017/4/21.
//
//

#import "SeletctListViewController.h"
#import "ChineseToPinyin.h"
#import "UIImage+Resizable.h"
#import "SelectListViewTableViewCell.h"

@interface SelectSectionObj : NSObject
@property(nonatomic, strong)NSString* name;
@property(nonatomic, strong)NSString* nameFirstLetter;
@property(nonatomic, strong)NSString* nameSingleLetter;
@property(nonatomic, strong)NSString* letter;
@property(nonatomic, strong)NSString* rightInfo;
@property(nonatomic)NSInteger index;
@end

@implementation SelectSectionObj
@end

@interface SeletctListViewController ()<UISearchBarDelegate>
@property(nonatomic, weak)IBOutlet UITableView* tableView;
@property(nonatomic, strong)NSMutableArray* selectArray;
@property (nonatomic, strong) NSArray *sectionKeyArray;
@property (nonatomic, strong) NSMutableDictionary *sectionKeyDictionary;
@property (nonatomic, strong)UISearchBar* searchBar;
@property(nonatomic, weak)IBOutlet UIView* bgView;
@property(nonatomic, weak)IBOutlet UIButton* okButton;
@end

@implementation SeletctListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ( self.multiSelect )
    {
        self.okButton.hidden = NO;
    }
    
    [self setHeaderView];
    
    [self realoadData:@""];
    
    [self.tableView registerNib:[UINib nibWithNibName: @"SelectListViewTableViewCell" bundle: nil] forCellReuseIdentifier:@"SelectListViewTableViewCell"];
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
    return self.sectionKeyArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionKey = [self.sectionKeyArray objectAtIndex:section];
    NSArray *values = [self.sectionKeyDictionary objectForKey:sectionKey];
    
    return values.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectListViewTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SelectListViewTableViewCell"];
    
    NSString *key = [self.sectionKeyArray objectAtIndex:indexPath.section];
    NSArray *objs = [self.sectionKeyDictionary objectForKey:key];
    SelectSectionObj *obj = [objs objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = obj.name;
    cell.rightLabel.text = obj.rightInfo;
    
    if ( [self.selectIndexSet containsObject:@(obj.index)] )
    {
        cell.checkIcon.hidden = NO;
    }
    else
    {
        cell.checkIcon.hidden = YES;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

//#if 0
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[self.sectionKeyArray objectAtIndex:section] isEqualToString:@"0"])
    {
        return 0;
    }
    return 0;
    //return 24.0;
}
//#endif

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];//[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 24.0)];
//    headerView.backgroundColor = COLOR(180.0, 218.0, 213.0, 1.0);
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 1.0, 200, 24.0)];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.textAlignment = NSTextAlignmentLeft;
//    titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
//    titleLabel.text = [self.sectionKeyArray objectAtIndex:section];
//    [headerView addSubview:titleLabel];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *key = [self.sectionKeyArray objectAtIndex:indexPath.section];
    NSArray *objs = [self.sectionKeyDictionary objectForKey:key];
    SelectSectionObj *obj = [objs objectAtIndex:indexPath.row];
    if ( self.multiSelect )
    {
        NSNumber* index = @(obj.index);
        if ( [self.selectIndexSet containsObject:index] )
        {
            [self.selectIndexSet removeObject:index];
        }
        else
        {
            [self.selectIndexSet addObject:index];
        }
        [self.tableView reloadData];
    }
    else
    {
        self.selectAtIndex(obj.index);
        [self didBackButtonPressed:nil];
    }
    
    //NSArray *members = [self.memberParams objectForKey:key];
    //CDMember *member = [members objectAtIndex:indexPath.row];
}

- (IBAction)didBackButtonPressed:(id)sender
{
    [self hideWithAnimation];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AdditionTableViewShouldHide" object:nil];
    [self realoadData:searchText];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)realoadData:(NSString*)keyword
{
    self.selectArray = [NSMutableArray array];
    self.sectionKeyArray = [NSArray array];
    self.sectionKeyDictionary = [NSMutableDictionary dictionary];
    
    NSMutableArray* noSortArray = [NSMutableArray array];
    
    BOOL bNeedInitSelect = FALSE;
    if ( self.selectIndexSet == nil )
    {
        bNeedInitSelect = TRUE;
        self.selectIndexSet = [NSMutableOrderedSet orderedSet];
    }
    
    for (NSInteger i = 0; i < self.countOfTheList(); i++ )
    {
        SelectSectionObj* obj = [SelectSectionObj new];
        obj.name = self.nameAtIndex(i);
        if ( self.rightInfoAtIndex )
        {
            obj.rightInfo = self.rightInfoAtIndex(i);
        }
        obj.letter = [ChineseToPinyin pinyinFromChiniseString:obj.name];
        obj.nameFirstLetter = [[ChineseToPinyin pinyinFirstLetterString:obj.name] uppercaseString];
        obj.index = i;
        
        if ( keyword.length > 0 && (![obj.name containsString:keyword] && ![obj.nameFirstLetter containsString:[keyword uppercaseString]] && ![obj.letter containsString:[keyword uppercaseString]] && ![obj.rightInfo containsString:[keyword uppercaseString]]))
            continue;

        if ( bNeedInitSelect )
        {
            if ( self.isSelected && self.isSelected(i) )
            {
                [self.selectIndexSet addObject:@(i)];
            }
        }
        
        if ( obj.nameFirstLetter.length > 0 )
        {
            NSString *singleLetter = [obj.nameFirstLetter substringToIndex:1];
            if ([ChineseToPinyin isFirstLetterValidate:singleLetter])
            {
                obj.nameSingleLetter = singleLetter;
            }
            else
            {
                obj.nameSingleLetter = @"a";
            }
        }
        else
        {
            obj.nameSingleLetter = @"#";
        }
        
        [self.selectArray addObject:obj];
        
        NSMutableArray *mutableArray = [self.sectionKeyDictionary objectForKey:obj.nameSingleLetter];
        if ( mutableArray == nil )
        {
            mutableArray = [NSMutableArray array];
            [self.sectionKeyDictionary setObject:mutableArray forKey:obj.nameSingleLetter];
            if ( self.noSort )
            {
                [noSortArray addObject:obj.nameSingleLetter];
            }
        }
        
        [mutableArray addObject:obj];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
    if ( self.noSort )
    {
        self.sectionKeyArray = noSortArray;
    }
    else
    {
        self.sectionKeyArray = [self.sectionKeyDictionary.allKeys sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    }
    
    [self.tableView reloadData];
}

- (void)showWithAnimation
{
    __block CGRect frame = self.bgView.frame;
    frame.origin.x = 1024;
    self.bgView.frame = frame;
    
    [UIView animateWithDuration:0.15 animations:^{
        frame.origin.x = 684;
        self.bgView.frame = frame;
    }];
}

- (void)hideWithAnimation
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AdditionTableViewShouldHide" object:nil];
    [UIView animateWithDuration:0.15 animations:^{
        CGRect frame = self.bgView.frame;
        frame.origin.x = 1024;
        self.bgView.frame = frame;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

- (IBAction)didOKButtonPressed:(id)sender
{
    if ( self.multiSelectFinish )
    {
        self.multiSelectFinish(self.selectIndexSet);
    }
    
    [self didBackButtonPressed:nil];
}

- (void)close
{
    [self didBackButtonPressed:nil];
}
@end
