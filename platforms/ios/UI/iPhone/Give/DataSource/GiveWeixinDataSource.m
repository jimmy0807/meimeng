//
//  GiveWeixinDataSource.m
//  Boss
//
//  Created by lining on 16/9/21.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "GiveWeixinDataSource.h"
#import "PhoneGiveCell.h"


@interface GiveWeixinDataSource()
@property (nonatomic, strong) NSArray *WXTemplates;

@end

@implementation GiveWeixinDataSource
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
    self.WXTemplates = [[BSCoreDataManager currentManager] fetchWXCardTemplatesList];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.WXTemplates.count;
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
    CDWXCardTemplate *template = [self.WXTemplates objectAtIndex:indexPath.row];
//    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:template.template_pic_url] placeholderImage:[UIImage imageNamed:@"phone_give_default.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        //        templateCell.imageView.image = image;
//    }];
    cell.imgView.image = [UIImage imageNamed:@"phone_give_default.png"];
    
    cell.nameLabel.text = template.title;
    cell.priceLabel.font = [UIFont systemFontOfSize:12];
    cell.priceLabel.text = [NSString stringWithFormat:@"总库存%@张，现有库存%@张",template.quantity,template.current_quantity];
    return cell;
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDWXCardTemplate *template = [self.WXTemplates objectAtIndex:indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(didWeixinTemplatedPressed:)]) {
        [self.delegate didWeixinTemplatedPressed:template];
    }
}


@end
