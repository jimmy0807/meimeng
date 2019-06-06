//
//  MemberMessageTemplateViewController.h
//  Boss
//
//  Created by lining on 16/5/27.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"
#import "BSMessageNavigationController.h"

typedef enum MessgeSendType
{
    MessgeSendType_qunfa,
    MessgeSendType_personal
    
}MessgeSendType;

@interface MemberMessageTemplateViewController : ICCommonViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *namesLabel;
@property (strong, nonatomic) IBOutlet UIImageView *templateBgView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *dotBgView;
@property (nonatomic, strong) NSArray *selectedPeoples;
@property (nonatomic, strong) CDMember *member;
@property (nonatomic, assign) BOOL qunfa;
@end

