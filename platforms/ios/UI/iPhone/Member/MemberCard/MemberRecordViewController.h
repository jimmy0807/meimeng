//
//  MemberRecordViewController.h
//  Boss
//
//  Created by lining on 16/3/28.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

#define RECORD_TYPE_CONSUME     @"消费明细"
#define RECORD_TYPE_OPERATE     @"操作明细"
#define RECORD_TYPE_AMOUNT      @"金额变动明细"
#define RECORD_TYPE_ARREAR      @"欠款还款明细"
#define RECORD_TYPE_POINT       @"积分明细"
#define RECORD_TYPE_QIANDAO     @"签到记录"
#define RECORD_TYPE_HULI        @"护理明细"
#define RECORD_TYPE_ZHUANDIAN   @"转店明细"

typedef enum RecordType
{
    RecordType_Card,
    RecordType_Member,
    
}RecordType;

@interface MemberRecordViewController : ICCommonViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) CDMember *member;
@property (strong, nonatomic) CDMemberCard *card;
@property (assign, nonatomic) RecordType type;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end
