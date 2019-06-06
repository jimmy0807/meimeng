//
//  ICCommomManager.m
//  BetSize
//
//  Created by jimmy on 12-10-10.
//
//

#import "ICCommomManager.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "NSString+Additions.h"

static ICCommomManager* s_sharedManager = nil;

@implementation ICCommomManager
@synthesize language;
@synthesize currentVersion;
@synthesize udid;

+ (ICCommomManager*)sharedManager
{
    @synchronized(s_sharedManager)
    {
        if (s_sharedManager == nil)
        {
            s_sharedManager = [[ICCommomManager alloc] init];
        }
    }
    
    return s_sharedManager;
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        language = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] retain];
        
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
        
        udid = [ICKeyChainManager getPasswordForUsername:@"ICCommomManager_udid" forServiceName:@"ICCommomManager"];
        if ( [udid length] == 0 )
        {
            NSString *appName = [infoDict objectForKey:@"CFBundleIdentifier"];
            udid = [[NSString generateGUID] retain];
            [ICKeyChainManager storeUsername:[NSString stringWithFormat:@"%@%@",@"ICCommomManager_udid",appName] andPassword:udid forServiceName:@"ICCommomManager"];
        }
    }
    
    return self;
}


- (float)getIOSVersion
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    return version;
}

- (void)savePhotoWithData:(NSData*)data toAlubm:(NSString*)album andDelegate:(id)delegate
{
    if ( [self getIOSVersion] >= 5.0 )
    {
        ALAssetsLibrary* library = [[[ALAssetsLibrary alloc] init] autorelease];
        if ( [album length] == 0 )
        {
            album = NSLocalizedStringFromTable(@"CFBundleDisplayName", @"InfoPlist", nil); //LS(@"CFBundleDisplayName");
        }
        [library saveImage:[UIImage imageWithData:data] toAlbum:album withCompletionBlock:^(NSError *error)
        {
            if (error!=nil)
            {
                NSLog(@"Big error: %@", [error description]);
            }
        }];
    }
    else
    {
        UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:data], delegate, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (BOOL)isAdvertiseCanShow
{
#ifdef SUPPORT_91
    return TRUE;
#endif
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString* result = [userDefault objectForKey:UsingICManager];
    if ( [result floatValue] < [currentVersion floatValue] )
    {
        result = @"";
        [userDefault removeObjectForKey:UsingICManager];
    }
   
    NSLog(@"isAdvertiseCanShow : %@",result);
    return [result length] > 0 ? TRUE : FALSE;
}

- (void)setAdvertiseShow
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:currentVersion forKey:UsingICManager];
    [userDefault synchronize];
}

@end
