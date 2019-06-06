//
//  BaseInfoEditModel.h
//  Boss
//
//  Created by jiangfei on 16/7/6.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseInfoEditModel : NSObject
/**  born_category*/
@property (nonatomic,assign)NSInteger born_category;
///**  category_id*/
//@property (nonatomic,assign)NSNumber *category_id;
/** 名称*/
@property (nonatomic,strong)NSString *name;
/** 图片*/
@property (nonatomic,strong)UIImage *image;
/** 售价*/
@property (nonatomic,assign)float list_price;
/** 成本*/
@property (nonatomic,assign)float standard_price;
/**  项目服务时间*/
@property (nonatomic,assign)NSInteger time;
/**  在手数量*/
@property (nonatomic,assign)NSInteger qty_available;
/**  可销售*/
@property (nonatomic,assign)BOOL sale_ok;
/**  可采购*/
@property (nonatomic,assign)BOOL purchase_ok;
/**  是否接受预约*/
@property (nonatomic,assign)BOOL book_ok;
/**  是否在收银端销售*/
@property (nonatomic,assign)BOOL available_in_pos;
///**  pos分类*/
@property (nonatomic,assign)NSNumber *pos_categ_id;
//**  产品类型(库存，消耗，服务)
@property (nonatomic,strong)NSString *type;
/** 内部货号*/
@property (nonatomic,strong)NSString *default_code;
/** 二维码*/
@property (nonatomic,strong)NSString *barcode;

/**  在微信商城中展示*/
@property (nonatomic,assign)BOOL available_in_weixin;
/**  主打商品*/
@property (nonatomic,assign)BOOL is_main_product;
/**  推荐商品*/
@property (nonatomic,assign)BOOL is_recommend;
/**  是否参与微卡活动*/
@property (nonatomic,assign)BOOL is_spread;
/**  在微卡商城中展示*/
@property (nonatomic,assign)BOOL is_show_weika;
/**  多少积分可兑换*/
@property (nonatomic,assign)NSInteger exchange;
@end
