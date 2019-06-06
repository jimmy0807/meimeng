//
//  BSFetchMemberCardProjectRequest.m
//  Boss
//
//  Created by XiaXianBing on 15/11/13.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "BSFetchMemberCardProjectRequest.h"
#import "BSFetchMemberCardRequest.h"
#import "NSDate+Formatter.h"

typedef enum kBSFetchMemberCardProjectType
{
    kBSFetchMemberCardProjectAll,
    kBSFetchMemberCardProjectWithCardID,
    kBSFetchMemberCardProjectWithMember,
    kBSFetchMemberCardProjectWithProjectIds
}kBSFetchMemberCardProjectType;

@interface BSFetchMemberCardProjectRequest ()

@property (nonatomic, strong) NSNumber *memberCardID;
@property (nonatomic, assign) kBSFetchMemberCardProjectType type;
@property (nonatomic, strong) NSNumber *memberID;
@property (nonatomic, strong) CDMember *member;
@property (nonatomic, strong) NSArray *projectIds;

@end

@implementation BSFetchMemberCardProjectRequest

- (id)init
{
    self = [super init];
    if (self)
    {
        self.type = kBSFetchMemberCardProjectAll;
    }
    
    return self;
}

- (id)initWithMemberCardID:(NSNumber *)memberCardID
{
    self = [super init];
    if (self)
    {
        self.memberCardID = memberCardID;
        self.type = kBSFetchMemberCardProjectWithCardID;
    }
    
    return self;
}

- (id)initWithMember:(CDMember *)member
{
    self = [super init];
    if (self) {
        self.memberID = member.memberID;
        self.member = member;
        self.type = kBSFetchMemberCardProjectWithMember;
    }
    return self;
}


- (id)initWithMemberCardProjectIds:(NSArray *)projectIds
{
    self = [super init];
    if (self) {
        self.projectIds = projectIds;
        self.type = kBSFetchMemberCardProjectWithProjectIds;
    }
    return self;
}

- (BOOL)willStart
{
    self.tableName = @"born.product.line";
    if (self.type == kBSFetchMemberCardProjectWithCardID)
    {
        if ( self.memberCardID == nil )
        {
            return FALSE;
        }
        self.filter = @[@[@"card_id", @"=", self.memberCardID]];
    }
    else if (self.type == kBSFetchMemberCardProjectWithMember)
    {
//        if (self.member) {
//            
//        }
//        if (self.memberID) {
//            self.filter = @[@[@"member_id",@"=",self.memberID]];
//        }
        if (self.member.product_all_ids.length > 0) {
            self.filter = @[@[@"id",@"in",[self.member.product_all_ids componentsSeparatedByString:@","]]];
        }
        else
        {
            self.filter = @[@[@"id",@"in",@[]]];
        }
        
    }
    else if (self.type == kBSFetchMemberCardProjectWithProjectIds)
    {
        self.filter = @[@[@"id",@"in",self.projectIds]];
    }
        
    self.field = @[@"id", @"card_id", @"product_id", @"product_price",@"create_date", @"name", @"price_unit", @"discount", @"price_subtotal_incl", @"operate_id", @"limited_qty", @"limited_date",  @"is_deposit", @"deposit_state", @"product_uom_qty", @"remarkproduct_uom_qty", @"qty", @"remain_qty",@"born_category",@"parent_product_id",@"member_id"];//（born_category = "2"代表卡内项目） （parent_product_id = 0代表购买项目）
    
    [self sendShopAssistantXmlSearchReadCommand];
    
    return TRUE;
}

- (void)didFinishOnMainThread
{
    NSArray *resultArray = [BNXmlRpc arrayWithXmlRpc:resultStr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([resultArray isKindOfClass:[NSArray class]])
    {
        NSMutableArray *oldProjectArray = [NSMutableArray array];
        NSArray *projectArray;
        if (self.type == kBSFetchMemberCardProjectAll)
        {
            projectArray = [[BSCoreDataManager currentManager] fetchAllMemberCardProject];
        }
        else if (self.type == kBSFetchMemberCardProjectWithCardID)
        {
            projectArray = [[BSCoreDataManager currentManager] fetchCardProjectsWithMemberCardID:self.memberCardID];
        }
        else if (self.type == kBSFetchMemberCardProjectWithMember)
        {
            projectArray = [[BSCoreDataManager currentManager] fetchMemberProductsWithMemberID:self.memberID];
        }
        else if (self.type == kBSFetchMemberCardProjectWithProjectIds)
        {
            projectArray = [[BSCoreDataManager currentManager] fetchCardProjectsWithProjectIds:self.projectIds];
        }
        
        oldProjectArray = [NSMutableArray arrayWithArray:projectArray];
        for (NSDictionary *params in resultArray)
        {
            NSNumber *productLineId = [params numberValueForKey:@"id"];
            CDMemberCardProject *project = [[BSCoreDataManager currentManager] findEntity:@"CDMemberCardProject" withValue:productLineId forKey:@"productLineID"];
            if(!project)
            {
                project = [[BSCoreDataManager currentManager] insertEntity:@"CDMemberCardProject"];
                project.productLineID = productLineId;
            }
            else
            {
                [oldProjectArray removeObject:project];
            }
            
            NSArray *productIds = [params arrayValueForKey:@"product_id"];
            if ([productIds isKindOfClass:[NSArray class]] && productIds.count > 1)
            {
                project.projectID = [productIds objectAtIndex:0];
                project.projectName = [productIds objectAtIndex:1];
            }
            project.projectPrice = [NSNumber numberWithFloat:[[params stringValueForKey:@"product_price"] floatValue]];
            project.discount = [NSNumber numberWithFloat:[[params stringValueForKey:@"discount"] floatValue]];
            project.projectPriceUnit = [NSNumber numberWithFloat:[[params stringValueForKey:@"price_unit"] doubleValue]];
            project.born_category = [params numberValueForKey:@"born_category"];
//            project.section_category = [params stringValueForKey:@"born_category"];
            
            CDBornCategory *bornCategory = [[BSCoreDataManager currentManager] findEntity:@"CDBornCategory" withValue:project.born_category forKey:@"code"];
            project.section_category = bornCategory.bornCategoryName;
            
            project.parent_product_id = [params arrayIDValueForKey:@"parent_product_id"];
            project.projectTotalPrice = [NSNumber numberWithFloat:[[params stringValueForKey:@"price_subtotal_incl"] floatValue]];
            NSArray *operates = [params arrayValueForKey:@"operate_id"];
            if ([operates isKindOfClass:[NSArray class]] && operates.count > 1)
            {
                project.operateID = [operates objectAtIndex:0];
                project.operateName = [operates objectAtIndex:1];
            }
            project.isLimited = [NSNumber numberWithBool:[[params objectForKey:@"limited_qty"] boolValue]];
            
            project.create_date = [params stringValueForKey:@"create_date"];
            project.section_date = [[NSDate dateFromString:project.create_date] dateStringWithFormatter:@"yyyy-MM"];
            project.limitedDate = [params stringValueForKey:@"limited_date"];
            project.isDeposit = [NSNumber numberWithBool:[[params objectForKey:@"is_deposit"] boolValue]];
            project.depositState = [params stringValueForKey:@"deposit_state"];
            project.depositQty = [params numberValueForKey:@"product_uom_qty"];
            project.remainDepositQty = [params numberValueForKey:@"remarkproduct_uom_qty"];
            project.purchaseQty = [params numberValueForKey:@"qty"];
            project.remainQty = [params numberValueForKey:@"remain_qty"];
            if (project.isDeposit.boolValue)
            {
                project.projectCount = [NSNumber numberWithInteger:project.remainDepositQty.integerValue];
            }
            else
            {
                project.projectCount = [NSNumber numberWithInteger:project.remainQty.integerValue];
            }
            
            
            project.card_id = [params arrayIDValueForKey:@"card_id"];
            project.card_name = [params arrayNameValueForKey:@"card_id"];
            
            project.member_id = [params arrayIDValueForKey:@"member_id"];
            project.member_name = [params arrayNameValueForKey:@"member_id"];
            
            CDProjectItem *item = [[BSCoreDataManager currentManager] findEntity:@"CDProjectItem" withValue:project.projectID forKey:@"itemID"];
            if (item == nil)
            {
                item = [[BSCoreDataManager currentManager] insertEntity:@"CDProjectItem"];
                item.itemID = project.projectID;
            }
            else
            {
                project.defaultCode = item.defaultCode;
                project.uomID = item.uomID;
                project.uomName = item.uomName;
            }
            project.item = item;
            
//            if (project.uomName.length == 0)
//            {
//                project.uomName = LS(@"PadDefaultUomName");
//            }
//            if (project.defaultCode.length == 0)
//            {
//                project.defaultCode = @"0";
//            }
        }
        
        [[BSCoreDataManager currentManager] deleteObjects:oldProjectArray];
        [[BSCoreDataManager currentManager] save:nil];
        
        if (self.type == kBSFetchMemberCardProjectAll)
        {
            BSFetchMemberCardRequest *request = [[BSFetchMemberCardRequest alloc] init];
            [request execute];
        }
    }
    else
    {
        dict = [self generateResponse:@"服务器异常, 请稍后重试"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSFetchMemberCardProjectResponse object:nil userInfo:dict];
}

@end
