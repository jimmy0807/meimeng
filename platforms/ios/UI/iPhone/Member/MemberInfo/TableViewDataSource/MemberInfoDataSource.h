//
//  MemberInfoDataSource.h
//  Boss
//
//  Created by lining on 16/3/22.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum kInfoSection
{
    kInfoSectionOne,
    kInfoSectionTwo,
    kInfoSectionThree,
    kInfoSectionFour,
    kInfoSectionNum
}kInfoSection;

typedef enum InfoSectionOneRow
{
    InfoSection_row_pic,
    InfoSection_row_name,
    InfoSection_row_phone,
    InfoSection_row_shop,
    InfoSectionRow_row_guwen,
    InfoSectionRow_row_jishi,
    InfoSectionOne_row_num,
    InfoSection_row_no,
}InfoSectionOneRow;


typedef enum InfoSectionTwoRow
{
    InfoSection_row_birthday,
    InfoSection_row_gender,
    InfoSection_row_weika,
    InfoSectionTwo_row_num,
   
}InfoSectionTwoRow;

typedef enum InfoSectionThreeRow
{
    InfoSection_row_zhicheng,
    InfoSection_row_qq,
    InfoSection_row_weixin,
    InfoSection_row_email,
    InfoSection_row_address,
    InfoSectionThree_row_num,
    InfoSection_row_date,
}InfoSectionThreeRow;


typedef enum InfoSectionFourRow
{
    InfoSectionRow_row_tuijian_vip,
    InfoSectionRow_row_tuijian_member,
    InfoSectionRow_row_fenlei,
    InfoSectionFourRow_row_num
}InfoSectionFourRow;

typedef enum kMemberInfoType
{
    kMemberInfoType_Detail,
    kMemberInfoType_Create,
}kMemberInfoType;


@protocol MemberInfoDataSourceDelegate <NSObject>
@optional
- (void)didItemSelectedAtIndexPath:(NSIndexPath *)indexPath;
- (void)didEditTextField:(UITextField *)textField atIndexPath:(NSIndexPath *)indexPath;
- (void)didCheckBoxSelcted:(bool)selected atIndexPath:(NSIndexPath *)indexPath;
@end

@interface MemberInfoDataSource : NSObject<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
- (instancetype)initWithMember:(CDMember *)member tableView:(UITableView *)tableView;
@property (nonatomic, assign) kMemberInfoType type;
@property (nonatomic, weak) id<MemberInfoDataSourceDelegate>delegate;
@property (nonatomic, assign) BOOL isHaveImage;
@property (nonatomic, strong) UIImage *picImage;
@property (nonatomic, assign) BOOL canEdit;
@end
