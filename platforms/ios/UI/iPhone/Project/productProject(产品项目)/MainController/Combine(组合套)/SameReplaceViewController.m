//
//  SameReplaceViewController.m
//  ds
//
//  Created by lining on 2016/11/15.
//
//

#import "SameReplaceViewController.h"
#import "ConsumeEditCell.h"
#import "ShopCartCell.h"
#import "ProductProjectMainController.h"


@interface SameReplaceViewController ()

@end

@implementation SameReplaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *backItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    backItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.navigationItem.title = @"可替换项目";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopCartCell" bundle:nil] forCellReuseIdentifier:@"ShopCartCell"];
    [self registerNofitificationForMainThread:@"kAddSameItemDone"];
}


#pragma mark - ReceivedNotification
- (void)didReceiveNotificationOnMainThread:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"kAddSameItemDone"]) {
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sameItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDProjectItem *item = [self.sameItems objectAtIndex:indexPath.row];
    
    ShopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopCartCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = item.itemName;
//    cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",item.];
//    cell.countLable.text = [NSString stringWithFormat:@"x%d",consumable.count];
    [cell.imgeView sd_setImageWithURL:[NSURL URLWithString:item.imageSmallUrl] placeholderImage:[UIImage imageNamed:@"BornCategoryPleceHoledImage"]];
    if (indexPath.row == self.sameItems.count - 1) {
        cell.lineImgView.hidden = true;
    }
    else
    {
        cell.lineImgView.hidden = false;
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.sameItems removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self performSelector:@selector(reloadView) withObject:nil afterDelay:0.1];
    }
}

- (void)reloadView
{
    [self.tableView reloadData];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.sameItems.count == 0) {
        return 0;
    }
    return 20;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - btn action
- (IBAction)addBtnPressed:(id)sender {
    ProductProjectMainController *productMainController = [[ProductProjectMainController alloc] init];
    productMainController.controllerType = ProductControllerType_SameItem;
    productMainController.sameItems = self.sameItems;
    [self.navigationController pushViewController:productMainController animated:YES];
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
