//
//  XiaXianBingDebug.h
//  Boss
//
//  Created by XiaXianBing on 15/8/28.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#ifndef XiaXianBing_DEBUG_H
#define XiaXianBing_DEBUG_H

/*
 * 功能
 *
 * Project:
 * typedef enum kProjectItemType
 * {
 *      kProjectItemDefault,        // 产品项目
 *      kProjectItemConsumable,     // 项目消耗
 *      kProjectItemSubItem,        // 组合清单
 *      kProjectItemSameItem,       // 可替换项目
 *      kProjectItemPurchase,       // 可采购项目
 *      kProjectItemCardItem,       // 卡内项目
 *      kProjectItemCardBuyItem     // 可购买项目
 * }kProjectItemType;
 *
 *  -项目消耗:
 *  -组合清单:
 *  -可替换项目:
 *  -可采购项目:
 *  -卡内项目:
 *  -可购买项目:
 *
 *
 */

/*
 * NOTE
 *
 * 1. 删除项目和疗程时, 删除了"product.product"对应的数据, 却没有删除对应的"product.template"。
 * 2. 现在在新建疗程和套餐时, "list_price"字段必须传(该值为组合清单里的产品项目的价格总值), 如果不传, 创建出的疗程或套餐的价格就会为1.0。编辑疗程和套餐时则不必传"list_price", Request成功后系统会自动会计算该值。
 *
 *
 *
 *
 *
 */


/*
 * 修改
 *
 *
 * - 2015.09.01 改: "product.product"中@"sale_ok", @"book_ok", @"purchase_ok"三个字段从"product.template"中获取。
 *
 *
 * -
 *
 *
 *
 */


#endif
