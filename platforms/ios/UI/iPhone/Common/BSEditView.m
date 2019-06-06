//
//  BSCommonEditView.m
//  meim
//
//  Created by lining on 2016/12/13.
//
//

#import "BSEditView.h"

#define MaxTableHeight 360

#define AnimationDuration 0.35

@interface BSEditView ()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIButton *bgBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@end

@implementation BSEditView

+ (instancetype)createViewWithDataSource:(id<BSEditViewDataSource>)dataSource
{
    return [self createViewWithDataSource:dataSource addToView:[UIApplication sharedApplication].keyWindow];
}

+ (instancetype)createViewWithDataSource:(id<BSEditViewDataSource>)dataSource addToView:(UIView *)superView
{
    BSEditView *editView = [self loadFromNib];
    
    [superView addSubview:editView];
    [editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    editView.hidden = true;
    [editView initView];
    editView.datasource = dataSource;
    
    return editView;
}

- (void)initView
{
    self.backgroundColor = [UIColor clearColor];
    
    self.bgBtn.alpha = 0.0;
    self.bgBtn.backgroundColor = [UIColor clearColor];
    
    [self removeConstraint:self.bottomConstraint];
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom);
    }];
}

- (void)setDatasource:(id<BSEditViewDataSource>)datasource
{
    _datasource = datasource;
    
    datasource.editView = self;
    self.tableView.dataSource = datasource;
    self.tableView.delegate = datasource;
}

- (void)setTableViewHeight:(CGFloat)tableViewHeight
{
    if (tableViewHeight >= MaxTableHeight) {
        tableViewHeight = MaxTableHeight;
        self.tableView.scrollEnabled = true;
    }
    else
    {
        self.tableView.scrollEnabled = false;
    }
     _tableViewHeight = tableViewHeight;
    self.tableViewHeightConstraint.constant = tableViewHeight;
}


- (void)setEditObject:(NSObject *)editObject
{
    _editObject = editObject;
    self.datasource.editObject = editObject;
}

- (void)show
{
    self.hidden = false;
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
    }];
    
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.bgBtn.alpha = 0.6;
        [self layoutIfNeeded];
    }];
}

- (void)hide
{
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(0);
    }];
    
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.bgBtn.alpha = 0.0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
         self.hidden = true;
     }];
}

- (IBAction)bgBtnPressed:(id)sender {
    [self hide];
}

- (IBAction)cancelBtnPressed:(id)sender {
    [self hide];
}

- (IBAction)leftBtnPressed:(id)sender {
    [self hide];
    
    if ([self.delegate respondsToSelector:@selector(didLeftBtnPressed)]) {
        [self.delegate didLeftBtnPressed];
    }
}


- (IBAction)rightBtnPressed:(id)sender {
    [self hide];
    if ([self.datasource respondsToSelector:@selector(editAfterObject)]) {
        self.editObject = [self.datasource editAfterObject];
    }
    else
    {
        self.editObject = self.datasource.editObject;
    }
   
    if ([self.delegate respondsToSelector:@selector(didRightBtnPressed:)]) {
        [self.delegate didRightBtnPressed:self.editObject];
    }
}



@end
