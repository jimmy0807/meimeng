//
//  ProjectCreateViewController.h
//  Boss
//
//  Created by XiaXianBing on 15/8/6.
//  Copyright (c) 2015年 BORN. All rights reserved.
//

#import "ICCommonViewController.h"

#import "BSEditCell.h"
#import "BSSwitchCell.h"
#import "BNActionSheet.h"
#import "QRCodeView.h"
#import "ProjectViewController.h"
#import "AlbumViewController.h"
#import "BSCameraPickerController.h"
#import "BNScanCodeViewController.h"

typedef enum kProjectEditType
{
    kProjectItemEdit,
    kProjectItemCreate,
    kProjectTemplateEdit,
    kProjectTemplateCreate
}kProjectEditType;


@interface ProjectCreateViewController : ICCommonViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, BNActionSheetDelegate, QRCodeViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AlbumViewControllerDelegate, BSCameraPickerControllerDelegate, BNScanCodeDelegate, BSSwitchCellDelegate>

- (id)initWithProjectType:(kPadBornCategoryType)type;
- (id)initWithProjectItem:(CDProjectItem *)projectItem;
- (id)initWithEditType:(kProjectEditType)editType projectTemplate:(CDProjectTemplate *)projectTemplate;

@end
