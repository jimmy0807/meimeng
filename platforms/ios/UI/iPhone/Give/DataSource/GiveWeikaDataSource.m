//
//  GiveWeikaDataSource.m
//  Boss
//
//  Created by lining on 16/9/21.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "GiveWeikaDataSource.h"
#import "PhoneGiveCell.h"
#import "CouponSectionHead.h"

@interface GiveWeikaDataSource ()
@property (nonatomic, strong) NSFetchedResultsController *templateResultsController;
@end

@implementation GiveWeikaDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self reloadData];
    }
    return self;
}

- (void)reloadData
{
    self.templateResultsController = [[BSCoreDataManager currentManager] fetchCardTemplates];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.templateResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = self.templateResultsController.sections[section];
    return sectionInfo.numberOfObjects;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"PhoneGiveCell";
    PhoneGiveCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [PhoneGiveCell createCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = [UIColor clearColor];
    CDCardTemplate *template = [self.templateResultsController objectAtIndexPath:indexPath];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:template.template_pic_url] placeholderImage:[UIImage imageNamed:@"phone_give_default.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //        templateCell.imageView.image = image;
    }];

    cell.nameLabel.text = template.template_name;
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[template.buy_price floatValue]];
    return cell;
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CouponSectionHead *headView = [CouponSectionHead createView];
    id<NSFetchedResultsSectionInfo>sectionInfo = self.templateResultsController.sections[section];
    if ([sectionInfo.name integerValue] == 2) {
        headView.titleLabel.text = @"礼品券模板";
    }
    else
    {
        headView.titleLabel.text = @"礼品卡模板";
    }

    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     CDCardTemplate *template = [self.templateResultsController objectAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(didWeikaTemplatePressed:)]) {
        [self.delegate didWeikaTemplatePressed:template];
    }
}

#pragma mark - CouponCellDelegate
- (void)didDetailBtnPressedAtIndexPath:(NSIndexPath *)indexPath
{
//    NSInteger section = indexPath.section;
//    if (section == 0) {
//        CDCouponCard *couponCard = [self.validCoupons objectAtIndex:indexPath.row];
//        if ([self.delegate respondsToSelector:@selector(didSelectctdedCouponCard:)]) {
//            [self.delegate didSelectctdedCouponCard:couponCard];
//        }
//    }
}

@end
