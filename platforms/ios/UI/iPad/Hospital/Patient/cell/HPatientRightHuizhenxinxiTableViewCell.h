//
//  HPatientRightHuizhenxinxiTableViewCell.h
//  meim
//
//  Created by jimmy on 2017/5/2.
//
//

#import <UIKit/UIKit.h>

@interface HPatientRightHuizhenxinxiTableViewCell : UITableViewCell

@property(nonatomic, copy)void (^huizhenPhotoButtonPressed)(void);

@property(nonatomic, strong)CDHHuizhen* huizhen;

@end
