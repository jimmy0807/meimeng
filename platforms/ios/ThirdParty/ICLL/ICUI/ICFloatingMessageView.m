//
//  ICFloatingMessageView.m
//  BetSize
//
//  Created by jimmy on 12-10-15.
//
//

#import "ICFloatingMessageView.h"

@implementation ICDefaultFloatingMessageViewObj
IMPSharedManager(ICDefaultFloatingMessageViewObj)

- (void)dealloc
{
    self.default_text_color = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        self.default_display_time = 2;
        self.default_moving_distance = 40;
    }
    return self;
}

@end

@implementation ICFloatingMessageView
@synthesize color;
@synthesize fromHeight;
@synthesize duration;
@synthesize moveDistance;
@synthesize messageLabel;

+(void)setDefaultTextColor:(UIColor*)color
{
    [ICDefaultFloatingMessageViewObj sharedManager].default_text_color = color;
}

+(void)setDefaultDisplayTime:(CGFloat)time
{
    [ICDefaultFloatingMessageViewObj sharedManager].default_display_time = time;
}

+(void)setDefaultMovingDistance:(CGFloat)distance
{
    [ICDefaultFloatingMessageViewObj sharedManager].default_moving_distance = distance;
}

+(void)setDefaultFromHeight:(CGFloat)height
{
    [ICDefaultFloatingMessageViewObj sharedManager].default_from_height = height;
}

-(id)init
{
    self = [super init];
    if ( self )
    {
        self.frame = CGRectMake(30, 0, 260, 50);
        self.center = CGPointMake(160, [ICDefaultFloatingMessageViewObj sharedManager].default_from_height?[ICDefaultFloatingMessageViewObj sharedManager].default_from_height:[[UIScreen mainScreen] bounds].size.height/2);
        self.messageLabel = [[[usingColoredLabel ? NSClassFromString(@"ICColoredLabel"):NSClassFromString(@"UILabel") alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)] autorelease];
        messageLabel.textColor = [ICDefaultFloatingMessageViewObj sharedManager].default_text_color? [ICDefaultFloatingMessageViewObj sharedManager].default_text_color:[UIColor greenColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.font = [UIFont boldSystemFontOfSize:16];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
        [self addSubview:messageLabel];
    }
    
    return self;
}

-(id)initWithMesasge:(NSString*)msg
{
    self = [self init];
    self.messageLabel.text = msg;
    return self;
}

-(id)initWithColoredMesasge:(NSString*)msg
{
    usingColoredLabel = TRUE;
    self = [self init];
    [((ICColoredLabel*)self.messageLabel) setTextWithOutFontAndColor:msg];
    return self;
}

-(void)setKeyWordTextArray:(NSArray *)keyWordArray WithFont:(UIFont *)font AndColor:(UIColor *)keyWordColor
{
    [((ICColoredLabel*)self.messageLabel) setKeyWordTextArray:keyWordArray WithFont:font AndColor:keyWordColor];
}

-(void)setKeyWordTextString:(NSString *)keyWordStr WithFont:(UIFont *)font AndColor:(UIColor *)keyWordColor
{
    [((ICColoredLabel*)self.messageLabel) setKeyWordTextString:keyWordStr WithFont:font AndColor:keyWordColor];
}

-(void)show
{
    UIWindow *mainWindow=[[UIApplication sharedApplication].windows objectAtIndex:0];
    [mainWindow addSubview: self]; 

    [self startAnimations];
}

-(void)showInView:(UIView*)view
{
    [view addSubview:self];
    //NSLog(@"%f",view.frame.size.height);
    self.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
    [self startAnimations];
}

-(void)showInView:(UIView*)view fromHeight:(CGFloat)height
{
    [view addSubview:self];
    self.center = CGPointMake(160, height);
    [self startAnimations];
}

-(void)showFromHeight:(CGFloat)height
{
    self.center = CGPointMake(160, height);
    [self show];
}

-(void)startAnimations
{
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration: self.duration?self.duration:[ICDefaultFloatingMessageViewObj sharedManager].default_display_time];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDidStopSelector:@selector(onStoped)];
    [UIView setAnimationDelegate: self];
    //NSLog(@"%f",self.center.y);
    self.center = CGPointMake(self.center.x, self.center.y - ([ICDefaultFloatingMessageViewObj sharedManager].default_moving_distance?[ICDefaultFloatingMessageViewObj sharedManager].default_moving_distance:self.moveDistance));
    [UIView commitAnimations];
}

-(void)onStoped
{
    [self retain];
    [self removeFromSuperview];
    [self autorelease];
}

-(void)dealloc
{
    self.messageLabel = nil;
    self.color = nil;
    [super dealloc];
}

@end
