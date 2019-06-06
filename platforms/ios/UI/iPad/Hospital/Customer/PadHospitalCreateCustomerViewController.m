//
//  PadHospitalCreateCustomerViewController.m
//  meim
//
//  Created by jimmy on 2017/4/12.
//
//

#import "PadHospitalCreateCustomerViewController.h"
#import "PadProjectConstant.h"
#import "HCustomerCreateRequest.h"
#import "UIImage+Resizable.h"
#import "UIImage+Orientation.h"
#import "UIImagePickerController+Landscape.h"
#import "CBLoadingView.h"
#import "UIView+Frame.h"
#import "BSFetchStaffRequest.h"
#import "BSFetchMemberSourceRequest.h"
#import "BSFetchPartnerRequest.h"
#import "FetchHCustomerRequest.h"
#import "ChineseToPinyin.h"

typedef enum PickerViewEnum
{
    PickEnum_Customer,
    PickEnum_Member,
    PickEnum_Partner,
    PickEnum_Count,
}PickerViewEnum;

@interface PadHospitalCreateCustomerViewController ()

//add by ala 2017/04/27 layout design
@property(nonatomic, weak)IBOutlet UIImageView* logoImageView;
@property(nonatomic, weak)IBOutlet UITextField* nameTextFieldView;
@property(nonatomic, weak)IBOutlet UITextField* phoneTextFieldView;
@property(nonatomic, weak)IBOutlet UITextField* streetTextFieldView;
@property(nonatomic, weak)IBOutlet UITextField* noteTextFieldView;
@property(nonatomic, weak)IBOutlet UISwitch* genderSwitchView;
@property(nonatomic, weak)IBOutlet UILabel* genderDescriptionLabel;

@end

@implementation PadHospitalCreateCustomerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ( self.customer )
    {
        [self.logoImageView setImageWithName:[NSString stringWithFormat:@"%@_%@",self.customer.memberID, self.customer.memberName] tableName:@"born.medical.customer" filter:self.customer.memberID fieldName:@"image" writeDate:self.customer.lastUpdate placeholderString:@"" cacheDictionary:nil];
        
        self.nameTextFieldView.text = self.customer.memberName;
        self.phoneTextFieldView.text = self.customer.mobile;
        self.streetTextFieldView.text = self.customer.member_address;
        self.noteTextFieldView.text = self.customer.remark;
        if ( [self.customer.gender isEqualToString:@"Male"] )
        {
            self.genderSwitchView.on = YES;
            self.genderDescriptionLabel.text = @"男";
        }
        else
        {
            self.genderSwitchView.on = NO;
            self.genderDescriptionLabel.text = @"女";
        }
    }
}

- (IBAction)didAvatarButtonClick:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (self.logoImageView.image != nil)
    {
        BNActionSheet *actionSheet = [[BNActionSheet alloc] initWithItems:[NSArray arrayWithObjects:LS(@"Camera"), LS(@"ChooseFromAlbum"), LS(@"Delete"), nil] cancelTitle:LS(@"Cancel") delegate:self];
        [actionSheet show];
    }
    else
    {
        BNActionSheet *actionSheet = [[BNActionSheet alloc] initWithItems:[NSArray arrayWithObjects:LS(@"Camera"), LS(@"ChooseFromAlbum"), nil] cancelTitle:LS(@"Cancel") delegate:self];
        [actionSheet show];
    }
}

- (IBAction)didGenderChanged:(UISwitch*)sender
{
    if ( sender.on )
    {
        self.genderDescriptionLabel.text = @"男";
    }
    else
    {
        self.genderDescriptionLabel.text = @"女";
    }
}

- (void)didConfirmButtonClick:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if ( !self.customer && ( self.nameTextFieldView.text.length == 0 || self.phoneTextFieldView.text.length == 0 ) )
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@""
                                                           message:@"名字和电话号码必填"
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return ;
    }
    
    NSNumber *storeID = [[PersonalProfile currentProfile].shopIds firstObject];
    CDMember *member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:self.phoneTextFieldView.text forKey:[NSString stringWithFormat:@"storeID = %@ && mobile", storeID]];
    if ( member && !self.customer )
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:LS(@"PadMemberPhoneIsExist")
                                                           delegate:self
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:LS(@"PadMemberView"), nil];
        [alertView show];
        return;
    }
    
    //NSString *regex = @"^1[3|4|5|8|7][0-9]\\d{8}$";
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    //if (![predicate evaluateWithObject:self.memberPhoneNumber.text])
    if ( self.phoneTextFieldView.text.length != 11 )
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:LS(@"PadMemberPhoneNumberNotCorrect")
                                                           delegate:nil
                                                  cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return ;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:self.nameTextFieldView.text forKey:@"name"];
    self.customer.memberName = self.nameTextFieldView.text;
    self.customer.memberNameLetter = [ChineseToPinyin pinyinFromChiniseString:self.customer.memberName];
    self.customer.memberNameFirstLetter = [[ChineseToPinyin pinyinFirstLetterString:self.customer.memberName] uppercaseString];
    
    if ( self.genderSwitchView.on )
    {
        [params setObject:@"Male" forKey:@"gender"];
        self.customer.gender = @"Male";
    }
    else
    {
        [params setObject:@"Female" forKey:@"gender"];
        self.customer.gender = @"Female";
    }
    
    [params setObject:self.phoneTextFieldView.text forKey:@"mobile"];
    [params setObject:self.streetTextFieldView.text forKey:@"street"];
    [params setObject:self.noteTextFieldView.text forKey:@"note"];

    self.customer.mobile = self.phoneTextFieldView.text;
    self.customer.member_address = self.streetTextFieldView.text;
    self.customer.remark = self.noteTextFieldView.text;
    
    if (self.logoImageView.image != nil)
    {
        NSData *data = UIImageJPEGRepresentation(self.logoImageView.image, 0.7);
        NSString *imagestr = [data base64Encoding];
        [params setObject:imagestr forKey:@"image"];
    }
    else
    {
        [params setObject:[NSNumber numberWithBool:NO] forKey:@"image"];
    }
    
    [[CBLoadingView shareLoadingView] show];
    
    if ( self.customer )
    {
        HCustomerCreateRequest *request = [[HCustomerCreateRequest alloc] initWithMemberID:self.customer.memberID params:params];
        [request execute];
    }
    else
    {
        HCustomerCreateRequest *request = [[HCustomerCreateRequest alloc] initWithParams:params];
        [request execute];
    }
}

#pragma mark -
#pragma mark BNActionSheetDelegate Methods

- (void)bnActionSheet:(BNActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }
            break;
            
        case 1:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }
            break;
            
        case 2:
        {
            if (self.logoImageView.image != nil)
            {
                self.logoImageView.image = nil;
            }
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate Methods

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker = nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (picker.allowsEditing)
    {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    self.logoImageView.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker = nil;
}

- (void)dealloc
{
    
}

@end
