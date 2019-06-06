//
//  MemberCardInfoDataSource.h
//  Boss
//
//  Created by lining on 16/3/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum kCardInfoSection
{
    kCardInfoSectionOne,
    kCardInfoSectionTwo,
    kCardInfoSectionThree,
    kCardInfoSectionFour,
    kCardInfoSectionNum
}kInfoSection;

typedef enum CardInfoSectionOneRow
{
    CardInfoSectionOne_row_jilu,
    CardInfoSectionOne_row_num,
    CardInfoSectionOne_row_yue,             //余额
    CardInfoSectionOne_row_jifen,           //积分
}CardInfoSectionOneRow;


typedef enum CardInfoSectionTwoRow
{
    CardInfoSectionTwo_row_chongzhi,        //累计充值
    CardInfoSectionTwo_row_chongzhiqiankuan,//充值欠款
    CardInfoSectionTwo_row_xiaofeiqiankuan, //消费欠款
    CardInfoSectionTwo_row_sale,            //产品销售
    CardInfoSectionTwo_row_xiaohao,         //项目消耗
    CardInfoSectionTwo_row_num
}CardInfoSectionTwoRow;

typedef enum CardInfoSectionThreeRow
{
    CardInfoSectionThree_row_shop,             //门店
    CardInfoSectionThree_row_num,
}CardInfoSectionThreeRow;


typedef enum CardInfoSectionFourRow
{
    CardInfoSectionFourRow_row_qiandao,         //签到卡
    CardInfoSectionFourRow_row_yuangong,        //是否员工卡
    CardInfoSectionFourRow_row_kuadian,         //是否可以跨店消费
    CardInfoSectionFourRow_row_pwd,             //会员卡支付密码
    CardInfoSectionFourRow_row_defaultCode,     //实体卡支付密码
    CardInfoSectionFourRow_row_num
}CardInfoSectionFourRow;



@protocol CardInfoDataSourceDelegate <NSObject>
@optional
- (void)didSelectedItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)didEditParams:(NSDictionary *)params;
@end

@interface MemberCardInfoDataSource : NSObject<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) CDMemberCard *memberCard;
@property (nonatomic, weak) id<CardInfoDataSourceDelegate>delegate;
@property (nonatomic, assign) bool canEdit;
@end


//@interface Item : NSObject
//@property (nonatomic, assign) NSInteger section;
//@property (nonatomic, assign) NSInteger row;
//@property (nonatomic, strong) NSString *name;
//@end
