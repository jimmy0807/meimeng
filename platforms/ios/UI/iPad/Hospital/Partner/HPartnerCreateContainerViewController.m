//
//  HPartnerCreateContainerViewController.m
//  meim
//
//  Created by jimmy on 2017/4/27.
//
//

#import "HPartnerCreateContainerViewController.h"
#import "HPartnerCreateLeftViewController.h"
#import "HPartnerCreateRightPhotoViewController.h"
#import "UIImage+Scale.h"
#import "UIImage+Orientation.h"
#import "CBLoadingView.h"

@interface HPartnerCreateContainerViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property(nonatomic, weak)IBOutlet UILabel* titleLabel;
@property(nonatomic, strong)HPartnerCreateLeftViewController* leftChildVc;
@property(nonatomic, strong)HPartnerCreateRightPhotoViewController* rightChildVc;
@end

@implementation HPartnerCreateContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerNofitificationForMainThread:kHPartnerCreateResponse];
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kHPartnerCreateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            if ( [self.partner.partner_id integerValue] == 0 )
            {
                self.partner.partner_id = notification.object;
            }
            [[BSCoreDataManager currentManager] save:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSString *message = [notification.userInfo stringValueForKey:@"rm"];
            if(message.length != 0)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:message
                                                                   delegate:nil
                                                          cancelButtonTitle:LS(@"IKnewButtonTitle")
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( self.partner == nil )
    {
        self.partner = [[BSCoreDataManager currentManager] insertEntity:@"CDPartner"];
    }
    
    if ( [[segue destinationViewController] isKindOfClass:[HPartnerCreateLeftViewController class]] )
    {
        HPartnerCreateLeftViewController* vc = [segue destinationViewController];
        vc.partner = self.partner;
        self.leftChildVc = vc;
    }
    else if ( [[segue destinationViewController] isKindOfClass:[HPartnerCreateRightPhotoViewController class]] )
    {
        HPartnerCreateRightPhotoViewController* vc = [segue destinationViewController];
        vc.partner = self.partner;
        self.rightChildVc = vc;
    }
}

- (IBAction)didUploadPhotoButtonPressed:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
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
    
    image = [image orientation];
    
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    CGFloat imageDestWidth = imageWidth;
    CGFloat imageDestHeight = imageHeight;
    if (imageWidth > 1024)
    {
        imageDestWidth = 1024;
        imageDestHeight = (imageDestWidth) * imageHeight / imageWidth;
    }
    
    UIImage* compressedImage = [image scaleToSize:CGSizeMake(imageDestWidth, imageDestHeight)];
    
    NSString* url = [NSString stringWithFormat:@"%ld",[[NSDate date] timeIntervalSince1970]];
    [[SDWebImageManager sharedManager] saveImageToCache:compressedImage forURL:[NSURL URLWithString:url]];
    
    CDYimeiImage* yimeiImage = [[BSCoreDataManager currentManager] insertEntity:@"CDYimeiImage"];
    yimeiImage.url = url;
    yimeiImage.partner = self.partner;
    yimeiImage.type = @"local";
    yimeiImage.status = @"prepare";
    [[BSCoreDataManager currentManager] save:nil];
    
    [self.rightChildVc didYimeiPhotoAdded];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker = nil;
}

- (IBAction)didBackButtonPressed:(id)sender
{
    if ( [self.partner.partner_id integerValue] == 0 )
    {
        [[BSCoreDataManager currentManager] deleteObject:self.partner];
        self.partner = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didSaveButtonPressed:(id)sender
{
    [self.leftChildVc didSaveButtonPressed];
}

@end
