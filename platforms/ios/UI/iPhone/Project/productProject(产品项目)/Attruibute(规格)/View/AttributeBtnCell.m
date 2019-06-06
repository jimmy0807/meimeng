//
//  AttributeValueCell.m
//  ds
//
//  Created by lining on 2016/11/3.
//
//

#import "AttributeBtnCell.h"
#import "UIImage+Resizable.h"
#import "BSButton.h"


@interface AttributeBtnCell ()
{
//    bool isSelectedDelete;
}


@property (strong, nonatomic) IBOutlet BSButton *btn;

@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@end

@implementation AttributeBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.deleteBtn.hidden = true;
    
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [self.btn addGestureRecognizer:longGesture];
}

- (void)setBtnSelected:(BOOL)btnSelected
{
    _btnSelected = btnSelected;
    self.btn.selected = btnSelected;
}


- (void)setDeleteBtnShow:(BOOL)deleteBtnShow
{
    _deleteBtnShow = deleteBtnShow;
    self.deleteBtn.hidden = !deleteBtnShow;
}

- (void)setNormalImageName:(NSString *)normalImageName
{
    _normalImageName = normalImageName;
    UIImage *normalImg = [[UIImage imageNamed:normalImageName] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    [self.btn setBackgroundImage:normalImg forState:UIControlStateNormal];
}

- (void)setSelectedImageName:(NSString *)selectedImageName
{
    _selectedImageName = selectedImageName;
    UIImage *selectedImg = [[UIImage imageNamed:selectedImageName] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    [self.btn setBackgroundImage:selectedImg forState:UIControlStateSelected];
}

- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    [self.btn setTitleColor:normalColor forState:UIControlStateNormal];
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    [self.btn setTitleColor:selectedColor forState:UIControlStateSelected];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self.btn setTitle:title forState:UIControlStateNormal];
}


- (void)longPressed:(UILongPressGestureRecognizer *)longGesture
{
    if (self.longPressedDelete) {
        
        self.deleteBtn.hidden = false;
        if ([self.delegate respondsToSelector:@selector(didLongPressedObject:atIndexPath:)]) {
            [self.delegate didLongPressedObject:self.object atIndexPath:self.indexPath];
        }
    }
}


- (IBAction)btnPressed:(id)sender {
    
    if (self.deleteBtn.hidden == false) {
        self.deleteBtn.hidden = true;
        return;
    }
    self.btn.selected = !self.btn.selected;
    if ([self.delegate respondsToSelector:@selector(didBtnSelected:object:atIndexPath:)]) {
        [self.delegate didBtnSelected:self.btn.selected object:self.object atIndexPath:self.indexPath];
    }
}

- (IBAction)deleteBtnPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didDeleteBtnPressedObject:atIndexPath:)]) {
        [self.delegate didDeleteBtnPressedObject:self.object atIndexPath:self.indexPath];
    }
}


@end
