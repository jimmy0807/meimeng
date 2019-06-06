//
//  CDProjectItem+CoreDataProperties.m
//  meim
//
//  Created by 波恩公司 on 2018/4/23.
//
//

#import "CDProjectItem+CoreDataProperties.h"

@implementation CDProjectItem (CoreDataProperties)

+ (NSFetchRequest<CDProjectItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CDProjectItem"];
}

@dynamic barcode;
@dynamic bornCategory;
@dynamic canBook;
@dynamic canPurchase;
@dynamic canSale;
@dynamic cardDeduct;
@dynamic categoryID;
@dynamic categoryName;
@dynamic companyID;
@dynamic companyName;
@dynamic createDate;
@dynamic defaultCode;
@dynamic departments_id;
@dynamic description_notice;
@dynamic doFixedPercent;
@dynamic doPercent;
@dynamic extraPrice;
@dynamic fixedCardDeduct;
@dynamic forecastAmount;
@dynamic giftFixedCommission;
@dynamic giftFixedPercent;
@dynamic imageName;
@dynamic imageNameMedium;
@dynamic imageNamePad;
@dynamic imageNameSmall;
@dynamic imageNameVariant;
@dynamic imageSmallUrl;
@dynamic imageUrl;
@dynamic inAddition;
@dynamic inHandAmount;
@dynamic introduction;
@dynamic isActive;
@dynamic isGiftHasCommission;
@dynamic itemID;
@dynamic itemName;
@dynamic itemNameFirstLetter;
@dynamic itemNameLetter;
@dynamic lastUpdate;
@dynamic maxPrice;
@dynamic minPrice;
@dynamic mix_image_url;
@dynamic notCardDeduct;
@dynamic notFixedCardDeduct;
@dynamic package_count;
@dynamic parent_id;
@dynamic product_group_image_url;
@dynamic project_group_id;
@dynamic project_group_name;
@dynamic sequence;
@dynamic stanardPrice;
@dynamic subItemCount;
@dynamic templateID;
@dynamic templateName;
@dynamic time;
@dynamic totalPrice;
@dynamic type;
@dynamic uomID;
@dynamic uomName;
@dynamic attributeValues;
@dynamic category;
@dynamic couponCardProject;
@dynamic memberCardProject;
@dynamic moveItem;
@dynamic orderline;
@dynamic panDianItem;
@dynamic parentItems;
@dynamic posProducts;
@dynamic projectTemplate;
@dynamic sameRelateds;
@dynamic subItems;
@dynamic subRelateds;
@dynamic useItem;
@dynamic consumeItems;
@dynamic checkItem;
@dynamic is_check_service;
@dynamic is_consumables;
@dynamic is_prescription;
@dynamic check_ids;
@dynamic consumables_ids;

@end
