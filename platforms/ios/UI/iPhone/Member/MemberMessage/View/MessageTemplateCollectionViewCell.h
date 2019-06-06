//
//  MessgeTemplateCollectionViewCell.h
//  Boss
//
//  Created by lining on 16/5/27.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemplateItem : NSObject
@property (nonatomic, strong) NSString *imgName;
@property (nonatomic, strong) NSString *name;
@end


@interface MessageTemplateCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *bgImgView;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic, strong) TemplateItem *item;

@end


