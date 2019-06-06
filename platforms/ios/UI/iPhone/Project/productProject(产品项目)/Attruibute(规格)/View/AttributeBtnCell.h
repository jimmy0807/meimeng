//
//  AttributeValueCell.h
//  ds
//
//  Created by lining on 2016/11/3.
//
//

#import <UIKit/UIKit.h>
#import "BSAttributeValue.h"

@protocol AttributeBtnCellDelegate <NSObject>
@optional
- (void)didBtnSelected:(BOOL)selected object:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath;
- (void)didLongPressedObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath;
- (void)didDeleteBtnPressedObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath;
@end

@interface AttributeBtnCell : UICollectionViewCell

@property (nonatomic, strong) NSString *normalImageName;
@property (nonatomic, strong) NSString *selectedImageName;

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectedColor;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) BOOL longPressedDelete;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL deleteBtnShow;
@property (nonatomic, assign) BOOL btnSelected;

@property (nonatomic, strong) NSObject *object;


@property (nonatomic, weak) id<AttributeBtnCellDelegate>delegate;

@end
