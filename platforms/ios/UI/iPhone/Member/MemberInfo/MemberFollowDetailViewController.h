//
//  MemberFollowDetailViewController.h
//  Boss
//
//  Created by lining on 16/5/10.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

@interface MemberFollowDetailViewController : ICCommonViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(strong, nonatomic) CDMemberFollow *follow;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
