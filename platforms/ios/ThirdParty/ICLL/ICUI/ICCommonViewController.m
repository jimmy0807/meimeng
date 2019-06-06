//
//  ICCommonViewController.m
//  CardBag
//
//  Created by jimmy on 13-9-23.
//  Copyright (c) 2013年 Everydaysale. All rights reserved.
//

#import "ICCommonViewController.h"
#import "PadNumberKeyboard.h"

#define kNumKeyBoardDoneHeight 50

static UITextField* currentTextField;

@interface ICCommonViewController ()<PadNumberKeyboardDelegate>
{
    CGFloat keyBoardHeigh;
    BOOL responseKeyBorad;
    CGFloat originFrameY;
}

@property(nonatomic, strong)UISwipeGestureRecognizer *swipGesture;
@property(nonatomic, strong)UIButton* emptyButton;
@property(nonatomic, strong)UIView *numKeyboardDoneView;

@end

@implementation ICCommonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        ;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.swipGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipBack:)];
    //self.swipGesture.direction = UISwipeGestureRecognizerDirectionRight;
    //[self.view addGestureRecognizer:self.swipGesture];
    if ([self respondsToSelector: @selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    if ([self respondsToSelector: @selector(setExtendedLayoutIncludesOpaqueBars:)])
    {
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    
    if ([self respondsToSelector: @selector(setModalPresentationCapturesStatusBarAppearance:)])
    {
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
#ifdef ShopAssistant
    UISwipeGestureRecognizer *swipNextGesture = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipNext:)] autorelease];
    swipNextGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    swipNextGesture.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:swipNextGesture];
#endif
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    originFrameY = self.view.frame.origin.y;
    if (!self.noKeyboardNotification && ![PersonalProfile currentProfile].useBlueToothKeyBoard )
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditingNotification:) name:UITextFieldTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditingNotification:) name:UITextFieldTextDidEndEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillShowNotification object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

#ifdef ShopAssistant
-(void)swipNext:(UIGestureRecognizer *)gesture
{
    
}

#endif

- (void)keyboardWillShowOrHide:(NSNotification *)notification
{
    
    if ( !responseKeyBorad )
        return;
    
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //CGFloat animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if ( keyboardRect.size.height > 0 )
    {
        keyBoardHeigh = keyboardRect.size.height;
    }
    else
    {
        keyBoardHeigh = 216;
    }
    
    CGRect textFrame = [currentTextField convertRect:currentTextField.bounds toView:nil];
    
    float textY = textFrame.origin.y + textFrame.size.height;
    float bottomY = [UIScreen mainScreen].bounds.size.height - textY;
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    if( bottomY >= keyBoardHeigh )
    {
        frame.origin.y = originFrameY;
        self.view.frame = frame;
        return;
    }
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    frame.origin.y = frame.origin.y + bottomY - keyBoardHeigh - 10;
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)dealloc
{
    self.swipGesture = nil;
    self.emptyButton = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
#ifdef Staff
    return UIStatusBarStyleDefault;
#else
    return UIStatusBarStyleLightContent;
#endif
}

- (BOOL)prefersStatusBarHidden
{
    if (DEVICE_IS_IPAD)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (DEVICE_IS_IPAD)
    {
        return UIInterfaceOrientationMaskLandscape;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (DEVICE_IS_IPAD)
    {
        return ((interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (interfaceOrientation == UIDeviceOrientationLandscapeRight));
    }
    else
    {
        return (interfaceOrientation == UIDeviceOrientationPortrait);
    }
}

#pragma mark -
#pragma mark Gesture Action

-(void)swipBack:(UIGestureRecognizer *)gesture
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addSwipGesture
{
    [self.view addGestureRecognizer:self.swipGesture];
}

- (void)forbidSwipGesture
{
    [self.view removeGestureRecognizer:self.swipGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)textFieldDidBeginEditingNotification:(NSNotification *)notification
{
    UITextField* textField = notification.object;
 
    if ( currentTextField == textField )
        return;
    
    responseKeyBorad = TRUE;
    
    if (textField.keyboardType == UIKeyboardTypeNumberPad || textField.keyboardType == UIKeyboardTypeDecimalPad)
    {
        if (DEVICE_IS_IPAD)
        {
            PadNumberKeyboard* v = [textField customNumberKeyBoard];
            v.delegate = self;
        }
        else
        {
            [self initNumKeyboardDoneButton];
            textField.inputAccessoryView = self.numKeyboardDoneView;
        }
    }
    
    currentTextField = textField;
    
    if ( self.hideKeyBoardWhenClickEmpty )
    {
        self.emptyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.emptyButton.frame = self.view.bounds;
        [self.emptyButton addTarget:self action:@selector(hideKeyBoardInICCommonViewController:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.emptyButton];
    }
}

-(void)textFieldDidEndEditingNotification:(NSNotification *)notification
{
    UITextField* textField = notification.object;
    
    if ( currentTextField != textField )
        return;
    
    [self.emptyButton removeFromSuperview];
    self.emptyButton = nil;
    
    if (originFrameY == 0) {
        NSLog(@"--------");
    }
    
    CGRect frame = self.view.frame;
    frame.origin.y = originFrameY;
    
    
    NSTimeInterval animationDuration = 0.35f;
    
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    
    responseKeyBorad = FALSE;
//    originFrameY = 0;
    NSLog(@"----originFrameY %.2f----",originFrameY);

    currentTextField = nil;
}

- (void)initNumKeyboardDoneButton
{
    if ( self.numKeyboardDoneView )
        return;
    
    self.numKeyboardDoneView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height , [UIScreen mainScreen].bounds.size.width, kNumKeyBoardDoneHeight)];
    self.numKeyboardDoneView.backgroundColor = COLOR(240, 240, 240, 1);
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.numKeyboardDoneView.frame.size.width, 0.5)];
    topLine.backgroundColor = COLOR(200, 200, 200, 1);
    [self.numKeyboardDoneView addSubview:topLine];

    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(self.numKeyboardDoneView.frame.size.width - 20 - 50, (kNumKeyBoardDoneHeight - 20)/2.0, 50, 20);
    [doneBtn addTarget:self action:@selector(hideKeyBoardInICCommonViewController:) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setTitleColor:AppThemeColor forState:UIControlStateNormal]; //COLOR(11, 169, 250, 1)
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.numKeyboardDoneView addSubview:doneBtn];

    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, kNumKeyBoardDoneHeight - 0.5, self.numKeyboardDoneView.frame.size.width, 0.5)];
    bottomLine.backgroundColor = COLOR(166, 166, 166, 1);
}


- (void)hideKeyBoardInICCommonViewController:(id)sender
{
    [currentTextField resignFirstResponder];
    currentTextField = nil;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

@end
