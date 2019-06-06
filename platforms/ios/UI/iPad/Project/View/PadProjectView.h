//
//  PadProjectView.h
//  Boss
//
//  Created by XiaXianBing on 15/10/10.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PadProjectData.h"
#import "PadProjectConstant.h"
#import "PadProjectCollectionView.h"
#import "PadProjectHeaderView.h"

@protocol PadProjectViewDelegate <NSObject>

- (void)didPadFreeCombinationCreate;
- (void)didPadProjectViewItemClick:(NSObject *)object;

@end

@interface PadProjectView : UIView <PadProjectCollectionViewDataSource, PadProjectCollectionViewDelegate, UIScrollViewDelegate>

- (void)reloadProjectViewWithData:(PadProjectData *)data;

@property (nonatomic, assign) id<PadProjectViewDelegate> delegate;
@property (nonatomic, strong) PadProjectHeaderView *headerView;

@end
