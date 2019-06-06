//
//  BSProjectData.h
//  Boss
//
//  Created by XiaXianBing on 15/10/26.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PadProjectConstant.h"

@interface BSProjectData : NSObject

@property (nonatomic, assign) NSInteger otherCount;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) kPadBornCategoryType type;

@property (nonatomic, strong) NSArray *existItemIds;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, assign) BOOL isPriceSortASC;
@property (nonatomic, strong) NSArray *projectArray;
@property (nonatomic, strong) CDProjectCategory *currentCategory;
@property (nonatomic, strong) NSArray *subCategoryArray;

- (id)init;

- (void)reloadProjectItem;
- (void)reloadProjectItemWithType:(kPadBornCategoryType)type;
- (void)initCurrentCategory:(CDProjectCategory *)category;

@end
