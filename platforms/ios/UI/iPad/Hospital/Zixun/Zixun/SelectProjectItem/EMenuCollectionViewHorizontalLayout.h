//
//  EMenuCollectionViewHorizontalLayout.h
//  meim
//
//  Created by 波恩公司 on 2018/4/2.
//

#import <UIKit/UIKit.h>

@interface EMenuCollectionViewHorizontalLayout : UICollectionViewFlowLayout

//  一行中 cell 的个数
@property (nonatomic,assign) NSUInteger itemCountPerRow;

//    一页显示多少行
@property (nonatomic,assign) NSUInteger rowCount;

@end
