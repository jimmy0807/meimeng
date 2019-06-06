//
//  BuweiPhotoNameTableViewCell.m
//  meim
//
//  Created by jimmy on 17/2/20.
//
//

#import "BuweiPhotoNameTableViewCell.h"

@interface BuweiPhotoNameTableViewCell ()
@property(nonatomic, weak)IBOutlet UILabel* nameLabel;
@property(nonatomic, weak)IBOutlet UILabel* countLabel;
@property(nonatomic, weak)IBOutlet UITextField* countTextField;
@end

@implementation BuweiPhotoNameTableViewCell

- (void)setBuwei:(CDYimeiBuwei *)buwei
{
    self.nameLabel.text = buwei.name;
    self.countTextField.text = [NSString stringWithFormat:@"%@",buwei.count];
}

@end
