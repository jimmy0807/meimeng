//
//  MemberDetailViewController.h
//  Boss
//
//  Created by mac on 15/7/23.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

typedef enum MemberDetailType
{
    MemberDetailType_create,
    MemberDetailType_edit
}MemberDetailType;
@interface MemberDetailViewController : ICCommonViewController



@property(nonatomic,strong)NSMutableDictionary *selectList;

@property(nonatomic, strong)NSMutableDictionary *params;
@property(nonatomic,assign)BOOL isAddController;
@property(nonatomic,strong)NSIndexPath *selectIndexPath;
@property(nonatomic,strong)UIDatePicker *datePicker;

@property(nonatomic,assign)BOOL shouldCreateCard;
@property(nonatomic,assign)BOOL isHaveImage;

@property(nonatomic,assign) MemberDetailType type;
@property(nonatomic,strong) CDMember *member;


@end
