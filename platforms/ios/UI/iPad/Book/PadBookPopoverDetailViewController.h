//
//  PadBookPopoverDetailViewController.h
//  Boss
//
//  Created by lining on 15/12/10.
//  Copyright © 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

#define kBookLookMemberDetail @"kBookLookMemberDetail"

typedef enum PadBookType
{
    PadBookType_create,
    PadBookType_edit
}PadBookType;

@protocol PadBookPopoverControllerDelegate <NSObject>
@optional
- (void) cancelBtnPressed:(CDBook *)book;
- (void) deleteBtnPressed:(CDBook *)book;
- (void) doneBtnPressedWithBook:(CDBook *)book type:(PadBookType)type;
@end

@interface PadBookPopoverDetailViewController : ICCommonViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CDBook *book;
@property (assign, nonatomic) PadBookType type;
@property (Weak, nonatomic) id<PadBookPopoverControllerDelegate>delegate;
@property (strong, nonatomic) NSArray *technicians;
@property (strong, nonatomic) NSArray *tables;

@property(nonatomic, strong)NSString* bookPhoneNumber;
@property(nonatomic, strong)CDMember* bookMember;

- (IBAction)cacelBtnPressed:(UIButton *)sender;

- (IBAction)doneBtnPressed:(UIButton *)sender;


@end
