//
//  HospitalBarCodeView.m
//  meim
//
//  Created by jimmy on 2017/5/22.
//
//

#import "HospitalBarCodeView.h"
#import "QRCodeGenerator.h"

@interface HospitalBarCodeView ()
@property(nonatomic, weak)IBOutlet UIImageView* qrCodeImageView;
@end

@implementation HospitalBarCodeView

+ (void)showWithUrl:(NSString*)url
{
    HospitalBarCodeView* v = [HospitalBarCodeView loadFromNib];
    [[UIApplication sharedApplication].keyWindow addSubview:v];
    
    v.alpha = 0;
    //v.qrCodeImageView.image = [QRCodeGenerator qrImageForString:url imageSize:235];
    [v.qrCodeImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    
    [UIView animateWithDuration:0.2 animations:^{
        v.alpha = 1;
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)didEmptyButtonPressed:(id)sender
{
    [self hide];
}

@end
