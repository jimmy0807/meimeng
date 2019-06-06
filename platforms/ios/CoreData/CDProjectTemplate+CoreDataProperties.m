//
//  CDProjectTemplate+CoreDataProperties.m
//  meim
//
//  Created by lining on 2017/1/17.
//
//

#import "CDProjectTemplate+CoreDataProperties.h"

@implementation CDProjectTemplate (CoreDataProperties)

+ (NSFetchRequest<CDProjectTemplate *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDProjectTemplate"];
}

@dynamic available_in_pos;
@dynamic available_in_weixin;
@dynamic barcode;
@dynamic book_ok;
@dynamic bornCategory;
@dynamic canBook;
@dynamic canPurchase;
@dynamic canSale;
@dynamic category_id;
@dynamic categoryID;
@dynamic categoryName;
@dynamic companyID;
@dynamic companyName;
@dynamic createDate;
@dynamic default_code;
@dynamic defaultCode;
@dynamic exchange;
@dynamic image;
@dynamic imageName;
@dynamic imageNameMedium;
@dynamic imageNamePad;
@dynamic imageNameSmall;
@dynamic imageNameVariant;
@dynamic imageSmallUrl;
@dynamic imageUrl;
@dynamic introduction;
@dynamic is_main_product;
@dynamic is_recommend;
@dynamic is_show_weika;
@dynamic is_spread;
@dynamic isActive;
@dynamic lastUpdate;
@dynamic list_price;
@dynamic listPrice;
@dynamic minPrice;
@dynamic pos_categ_id;
@dynamic purchase_ok;
@dynamic qty_available;
@dynamic sale_ok;
@dynamic sequence;
@dynamic standard_price;
@dynamic templateID;
@dynamic templateName;
@dynamic templateNameFirstLetter;
@dynamic templateNameLetter;
@dynamic time;
@dynamic type;
@dynamic uomID;
@dynamic uomName;
@dynamic virtual_available;
@dynamic memberPrice;
@dynamic attributeLines;
@dynamic category;
@dynamic consumables;
@dynamic projectItems;

@end
