//
//  PopupPhoneCall.m
//  Boss
//
//  Created by jimmy on 16/3/29.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "PopupPhoneCall.h"
#import "PadBookMainViewController.h"

@interface PopupPhoneCall ()
@property(nonatomic, weak)IBOutlet UIImageView* avaterImageView;
@property(nonatomic, weak)IBOutlet UILabel* userName;
@property(nonatomic, weak)IBOutlet UILabel* phoneNumberLabel;
@property(nonatomic, weak)IBOutlet UILabel* descriptionLabel;
@property(nonatomic, strong)CDMember* member;
@end

@implementation PopupPhoneCall

+ (instancetype)show
{
    return [PopupPhoneCall showWithNavigationController:nil phoneNumber:nil];
}

+ (instancetype)showWithNavigationController:(UINavigationController*)navigationController phoneNumber:(NSString*)phoneNumber
{
    PopupPhoneCall* v = [[[NSBundle mainBundle] loadNibNamed:@"PopupPhoneCall" owner:self options:nil] objectAtIndex:0];
    
    [[UIApplication sharedApplication].keyWindow addSubview:v];
    
    v.alpha = 0;
    v.navigationController = navigationController;
    v.phoneNumber = phoneNumber;
    
    CDMember* member = [[BSCoreDataManager currentManager] findEntity:@"CDMember" withValue:phoneNumber forKey:@"mobile"];
    if ( member )
    {
        v.avaterImageView.hidden = NO;
        
        [v.avaterImageView setImageWithName:[NSString stringWithFormat:@"%@_%@",member.memberID, member.memberName] tableName:@"born.member" filter:member.memberID fieldName:@"image" writeDate:member.lastUpdate placeholderString:@"pad_avatar_default" cacheDictionary:nil];
        v.userName.text = member.memberName;
        v.phoneNumberLabel.text = @"";
        
        CGRect frame = v.descriptionLabel.frame;
        frame.origin.y = 178;
        v.descriptionLabel.frame = frame;
    }
    else
    {
        v.avaterImageView.hidden = YES;
        v.userName.text = @"";
        v.phoneNumberLabel.text = phoneNumber;
        
        CGRect frame = v.descriptionLabel.frame;
        frame.origin.y = 126;
        v.descriptionLabel.frame = frame;
    }
    
    v.member = member;
    
    [UIView animateWithDuration:0.2 animations:^{
        v.alpha = 1;
    }];
    
    return v;
}

- (IBAction)didOKButtonPressed:(id)sender
{
    [self hide];
    
    PadBookMainViewController *viewController = [[PadBookMainViewController alloc] initWithNibName:@"PadBookMainViewController" bundle:nil];
    viewController.isCloseButton = YES;
    viewController.bookPhoneNumber = self.phoneNumber;
    viewController.bookMember = self.member;
    [self.navigationController pushViewController:viewController animated:NO];
}

- (IBAction)didCancelButtonPressed:(id)sender
{
    [self hide];
}

- (void)hide
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
