//
//  RecommedDetailPhoneNumberView.h
//  meim
//
//  Created by 刘伟 on 2017/9/25.
//
//

#import <UIKit/UIKit.h>

//
typedef void (^PhoneNumberBlock)(NSString *);

@interface RecommedDetailPhoneNumberView : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (strong,nonatomic) NSString *phoneNumbertext;
@property PhoneNumberBlock textFieldPhoneBlock;

@end
