//
//  WXTemplateCell.h
//  Boss
//
//  Created by lining on 16/6/2.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WXTemplateCellDelegate <NSObject>
@optional
- (void)didSelectedBtnPressedAtIndexPath:(NSIndexPath *)indexPath;
- (void)didExpandBtnPressedAtIndexPath:(NSIndexPath *)indexPath;
- (void)didSureBtnPressedAtIndexPath:(NSIndexPath *)indexPath withCount:(NSInteger)count;
@end

@interface WXTemplateCell : UITableViewCell

+ (instancetype)createCell;

@property (weak, nonatomic) id<WXTemplateCellDelegate>delegate;
@property (strong, nonatomic) CDWXCardTemplate *WXTemplate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentCountLabel;

@property (strong, nonatomic) IBOutlet UIImageView *circleImgView;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImgView;
@property (strong, nonatomic) IBOutlet UIView *expandView;
@property (strong, nonatomic) IBOutlet UITextField *textField;

- (IBAction)circleBtnPressed:(id)sender;
- (IBAction)arrowBtnPressed:(id)sender;
- (IBAction)sureBtnPressed:(id)sender;
@end
