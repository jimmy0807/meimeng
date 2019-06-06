//
//  AttributePriceViewController.m
//  ds
//
//  Created by lining on 2016/11/8.
//
//

#import "AttributePriceViewController.h"
#import "BSAttributeLine.h"
#import "BSAttributeValue.h"
#import "ItemCell.h"
#import "AttributePriceCell.h"

@interface AttributePriceViewController ()<AttributePriceCellDelegate>

@end

@implementation AttributePriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CBBackButtonItem *backItem = [[CBBackButtonItem alloc] initWithTitle:nil];
    backItem.delegate = self;
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    BNRightButtonItem *rightButtonItem = [[BNRightButtonItem alloc] initWithTitle:@"保存"];
    rightButtonItem.delegate = self;
    
    self.navigationItem.title = @"规格附加价格";
    

    [self.tableView registerNib:[UINib nibWithNibName:@"ItemCell" bundle:nil] forCellReuseIdentifier:@"ItemCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AttributePriceCell" bundle:nil] forCellReuseIdentifier:@"AttributePriceCell"];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.attributeLines.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BSAttributeLine *attributeLine = [self.attributeLines objectAtIndex:section];
    return attributeLine.attributeValues.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    BSAttributeLine *attributeLine = [self.attributeLines objectAtIndex:section];
    if (row == 0) {
        ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
        cell.titleLabel.text = attributeLine.attributeName;
        cell.titleLabel.font = [UIFont systemFontOfSize:15];
        cell.valueLabel.text = @"";
        return cell;
    }
    else
    {
        BSAttributeValue *attributeValue = [attributeLine.attributeValues objectAtIndex:row - 1];
        AttributePriceCell *priceCell = [tableView dequeueReusableCellWithIdentifier:@"AttributePriceCell"];
        
        priceCell.delegate = self;
        priceCell.attributeValue = attributeValue;
        if (row == attributeLine.attributeValues.count) {
            priceCell.lineImgView.hidden = true;
        }
        else
        {
            priceCell.lineImgView.hidden = false;
        }
        return priceCell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.backgroundColor = [UIColor clearColor];
    return imgView;
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
