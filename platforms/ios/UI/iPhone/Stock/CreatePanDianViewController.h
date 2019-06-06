//
//  CreatePanDianViewController.h
//  Boss
//
//  Created by lining on 15/9/14.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

#define PopToPanDianVCRefresh @"PopToPanDianVCRefresh"


typedef enum PanDianType
{
    PanDianType_create,
    PanDianType_edit,
    PanDianType_confirm,
    PanDianType_look,
}PanDianType;

typedef enum PanDianSection
{
    PanDianSection_one,
    PanDianSection_two,
    PanDianSection_num,
    
}OrderSection;

typedef enum SectionRowOne
{
    SectionRowOne_name,
    SectionRowOne_location,
    SectionRowOne_type,
    SectionRowOne_num,
    SectionRowOne_company,

}SectionRowOne;

@interface CreatePanDianViewController : ICCommonViewController
@property(nonatomic, assign) PanDianType type;
@property(nonatomic, strong) CDPanDian *panDian;
@end
