//
//  ICColoredLabel.m
//  BetSize
//
//  Created by jimmy on 12-10-31.
//
//

#import "ICColoredLabel.h"
#import <CoreText/CoreText.h>

@implementation ICColoredLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {

    }
    return self;
}

-(void)setTextWithOutFontAndColor:(NSString *)text
{
    [self setText:text WithFont:self.font AndColor:self.textColor];
}

-(void)setText:(NSString *)text WithFont:(UIFont *)font AndColor:(UIColor *)color
{
    if ([text length] == 0)
    {
        text = @" ";
    }
    self.text = text;
    int len = [text length];
    CFStringRef name = (CFStringRef)font.fontName;
    NSMutableAttributedString *mutaString = [[NSMutableAttributedString alloc]initWithString:text];
    [mutaString addAttribute:(NSString *)(kCTForegroundColorAttributeName) value:(id)color.CGColor range:NSMakeRange(0, len)];
    CTFontRef ctFont2 = CTFontCreateWithName(name, font.pointSize,NULL);
    [mutaString addAttribute:(NSString *)(kCTFontAttributeName) value:(id)ctFont2 range:NSMakeRange(0, len)];
    
    //CFRelease(name);
    
    CTTextAlignment alignment = kCTLeftTextAlignment;
    
    CTParagraphStyleSetting alignmentStyle;
    
    if (self.textAlignment == NSTextAlignmentCenter)
    {
        alignment = kCTCenterTextAlignment;
    }
    else if (self.textAlignment == NSTextAlignmentRight)
    {
        alignment = kCTRightTextAlignment;
    }
    else
    {
        alignment = kCTLeftTextAlignment;
    }
    
    alignmentStyle.spec=kCTParagraphStyleSpecifierAlignment;
    alignmentStyle.valueSize=sizeof(alignment);
    alignmentStyle.value=&alignment;
    
    CTParagraphStyleSetting settings[]=
    {
        alignmentStyle
    };
    
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings)/sizeof(CTParagraphStyleSetting));
    [mutaString addAttribute:(NSString *)(kCTParagraphStyleAttributeName) value:(id)paragraphStyle range:NSMakeRange(0, len)];
    CFRelease(paragraphStyle);
    CFRelease(ctFont2);
    resultAttributedString = [mutaString retain];
    [mutaString release];
    
    CGSize maximumLabelSize = CGSizeMake(self.frame.size.width,self.frame.size.height);
    CGSize size = [self.text sizeWithFont:self.font
                        constrainedToSize:maximumLabelSize
                            lineBreakMode:NSLineBreakByWordWrapping];
    CGRect frame = self.frame;
    frame.origin.y += ( self.frame.size.height - size.height)/2;
    frame.size.height = size.height;
    self.frame = frame;
}

-(void)setKeyWordTextArray:(NSArray *)keyWordArray WithFont:(UIFont *)font AndColor:(UIColor *)keyWordColor
{
    if ( font == nil )
    {
        font = self.font;
    }

    NSMutableArray *rangeArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [keyWordArray count]; i++)
    {
        NSString *keyString = [keyWordArray objectAtIndex:i];
        NSString* str = self.text;
        NSInteger toIndex = 0;
        NSInteger sum = 0;
        while (1)
        {
            NSRange range = [str rangeOfString:keyString];
            
            if (range.length > 0)
            {
                toIndex = range.location;
                range.location += sum;
    
                NSValue *value = [NSValue valueWithRange:range];
                [rangeArray addObject:value];
                
                if ( range.location + range.length == [str length] )
                    break;
                
                str = [str substringFromIndex:toIndex + 1];
                sum += toIndex + 1;
            }
            else
            {
                break;
            }
        }
    }
    
    for (NSValue *value in rangeArray) {
        NSRange keyRange = [value rangeValue];
        [resultAttributedString addAttribute:(NSString *)(kCTForegroundColorAttributeName) value:(id)keyWordColor.CGColor range:keyRange];
        CFStringRef name = (CFStringRef)font.fontName;
        
        CTFontRef ctFont1 = CTFontCreateWithName(name, font.pointSize,NULL);
        
        //CFRelease(name);
        
        [resultAttributedString addAttribute:(NSString *)(kCTFontAttributeName) value:(id)ctFont1 range:keyRange];
        CFRelease(ctFont1);
    }
    
    [rangeArray release];
}

-(void)setKeyWordTextString:(NSString *)keyString WithFont:(UIFont *)font AndColor:(UIColor *)keyWordColor
{
    if ( font == nil )
    {
        font = self.font;
    }
    
    NSMutableArray *rangeArray = [[NSMutableArray alloc]init];
    
    NSString* str = self.text;
    NSInteger toIndex = 0;
    NSInteger sum = 0;
    while (1)
    {
        NSRange range = [str rangeOfString:keyString];
        
        if (range.length > 0)
        {
            toIndex = range.location;
            range.location += sum;
            
            NSValue *value = [NSValue valueWithRange:range];
            [rangeArray addObject:value];
            
            if ( range.location + range.length == [str length] )
                break;
            
            str = [str substringFromIndex:toIndex + range.length];
            sum += toIndex + 1;
        }
        else
        {
            break;
        }
    }
    
    for (NSValue *value in rangeArray)
    {
        NSRange keyRange = [value rangeValue];
        [resultAttributedString addAttribute:(NSString *)(kCTForegroundColorAttributeName) value:(id)keyWordColor.CGColor range:keyRange];
        CFStringRef name = (CFStringRef)font.fontName;
        CTFontRef ctFont1 = CTFontCreateWithName(name, font.pointSize,NULL);
        [resultAttributedString addAttribute:(NSString *)(kCTFontAttributeName) value:(id)ctFont1 range:keyRange];
        CFRelease(ctFont1);
        //CFRelease(name);
    }
    
    [rangeArray release];
}

- (void)drawRect:(CGRect)rect
{
    if (self.text !=nil)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 0.0, 0.0);//move
        CGContextScaleCTM(context, 1.0, -1.0);
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)resultAttributedString);
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGPathAddRect(pathRef,NULL , CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));//const CGAffineTransform *m
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), pathRef,NULL );//CFDictionaryRef frameAttributes

        CGContextTranslateCTM(context, 0, -self.bounds.size.height);
        CGContextSetTextPosition(context, 0, 0);
        CTFrameDraw(frame, context);
        CGContextRestoreGState(context);
        CGPathRelease(pathRef);
        CFRelease(framesetter);
        CFRelease(frame);
        UIGraphicsPushContext(context);
    }
}

- (void)dealloc
{
    [resultAttributedString release];
    [super dealloc];
}

@end
