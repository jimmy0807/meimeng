//
//  HPatientShoushuCreateHeader.h
//  meim
//
//  Created by jimmy on 2017/5/10.
//
//

#import <UIKit/UIKit.h>

@interface HPatientShoushuCreateHeader : UIView

@property(nonatomic, weak)IBOutlet UITextField* nameTextField;
@property(nonatomic, weak)IBOutlet UITextField* doctorTextField;
@property(nonatomic, weak)IBOutlet UITextField* zhiruTimeTextField;
@property(nonatomic, weak)IBOutlet UITextField* fuzhenDayTextField;
@property(nonatomic, weak)IBOutlet UITextField* shoushuTimeTextField;

@property(nonatomic, strong)CDHShoushu* shoushu;

@end
