//
//  HHuifangCreateContainerViewController.m
//  meim
//
//  Created by jimmy on 2017/4/27.
//
//

#import "HHuifangCreateContainerViewController.h"
#import "HHuifangCreateLeftViewController.h"
#import "HHuifangCreateRightPhotoViewController.h"
#import "UIImage+Scale.h"
#import "UIImage+Orientation.h"
#import "CBLoadingView.h"
#import "HMemberVisitCreateRequest.h"

@interface HHuifangCreateContainerViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property(nonatomic, weak)IBOutlet UILabel* titleLabel;
@property(nonatomic, strong)HHuifangCreateLeftViewController* leftChildVc;
@property(nonatomic, strong)HHuifangCreateRightPhotoViewController* rightChildVc;
@end

@implementation HHuifangCreateContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerNofitificationForMainThread:kHMemberVisitCreateResponse];
}

- (void)didReceiveNotificationOnMainThread:(NSNotification *)notification
{
    if ([notification.name isEqualToString:kHMemberVisitCreateResponse])
    {
        [[CBLoadingView shareLoadingView] hide];
        if([[notification.userInfo valueForKey:@"rc"] integerValue] == 0)
        {
            if ( [self.visit.visit_id integerValue] == 0 )
            {
                self.visit.visit_id = notification.object;
            }
            [[BSCoreDataManager currentManager] save:nil];
            [self.parentViewController.navigationController popViewControllerAnimated:YES];
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
    if ( self.visit == nil )
    {
        self.visit = [[BSCoreDataManager currentManager] insertEntity:@"CDMemberVisit"];
    }
    
    if ( [[segue destinationViewController] isKindOfClass:[HHuifangCreateLeftViewController class]] )
    {
        HHuifangCreateLeftViewController* vc = [segue destinationViewController];
        vc.visit = self.visit;
        self.leftChildVc = vc;
    }
    else if ( [[segue destinationViewController] isKindOfClass:[HHuifangCreateRightPhotoViewController class]] )
    {
        HHuifangCreateRightPhotoViewController* vc = [segue destinationViewController];
        vc.visit = self.visit;
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
    yimeiImage.huifang = self.visit;
    yimeiImage.type = @"local";
    yimeiImage.status = @"prepare";
    [[BSCoreDataManager currentManager] save:nil];
    
    [self.rightChildVc didYimeiPhotoAdded];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker = nil;
}

- (IBAction)didBackButtonPressed:(id)sender
{
    if ( [self.visit.visit_id integerValue] == 0 )
    {
        [[BSCoreDataManager currentManager] deleteObject:self.visit];
        self.visit = nil;
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didSaveButtonPressed:(id)sender
{
    [[CBLoadingView shareLoadingView] show];
    NSMutableArray* imageIDs = [NSMutableArray array];
    for ( CDYimeiImage* yimeiImage in self.visit.photos )
    {
        if ( [yimeiImage.imageID integerValue] != 0 )
            continue;
        
        if ( [yimeiImage.type isEqualToString:@"server_local"] )
        {
            NSArray *array = @[@(0), @(NO), @{@"image_url":yimeiImage.url}];
            [imageIDs addObject:array];
        }
    };
    
    HMemberVisitCreateRequest* request = [[HMemberVisitCreateRequest alloc] initWithVisitID:self.visit.visit_id params:@{@"visit_image_ids":imageIDs}];
    [request execute];
}

- (void)dealloc
{
    
}

@end
