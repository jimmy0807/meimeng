//
//  CreateProviderViewController.h
//  Boss
//
//  Created by lining on 15/6/23.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

typedef enum ProviderSection
{
    ProviderSection_one,
    ProviderSection_two,
    ProviderSection_num
}ProviderSection;

typedef enum SectionRowOne
{
    SectionRowOne_pic,
    SectionRowOne_name,
    SectionRowOne_telePhone,
    SectionRowOne_num,
    SectionRowOne_contact,
}SectionRowOne;


typedef enum SectionRowTwo
{
    SectionRowTwo_fax,
    SectionRowTwo_website,
    SectionRowTwo_area,
    SectionRowTwo_num
}SectionRowTwo;


@interface CreateProviderViewController : ICCommonViewController

@end
