//
//  UploadPicToZimg.m
//  ds
//
//  Created by jimmy on 16/10/27.
//
//

#import "UploadPicToZimg.h"
#import "MBProgressHUD.h"

@interface UploadPicToZimg ()
@property(nonatomic, copy) void (^finishedBlock)(BOOL, NSString*);
@property(nonatomic, strong)NSMutableData* receivedData;
@end

@implementation UploadPicToZimg

- (void)uploadPic:(UIImage*)image finished:(void (^)(BOOL ret, NSString* urlString))finished
{
    NSMutableURLRequest* rq = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@upload",[PersonalProfile currentProfile].upload_pic_url]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [rq setHTTPMethod: @"POST"];
    
    [rq setValue:@"jpeg" forHTTPHeaderField:@"Content-Type"];
    
    NSData* d = UIImageJPEGRepresentation(image, 0.9);
    [rq setHTTPBody:d];
    
    [NSURLConnection connectionWithRequest: rq delegate: self];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    HUD.label.text = @"正在提交数据 请稍后...";
    self.finishedBlock = finished;
    self.receivedData = [NSMutableData data];
}

- (void)uploadPic:(UIImage*)image withWorkFlowId:(int)workflowId finished:(void (^)(BOOL ret, NSString* urlString))finished
{
    NSMutableURLRequest* rq = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@upload/take_time=report",[PersonalProfile currentProfile].upload_pic_url]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [rq setHTTPMethod: @"POST"];
    
    [rq setValue:@"jpeg" forHTTPHeaderField:@"Content-Type"];
    
    NSData* d = UIImageJPEGRepresentation(image, 0.8);
    [rq setHTTPBody:d];
    
    [NSURLConnection connectionWithRequest: rq delegate: self];
    
    self.finishedBlock = finished;
    self.receivedData = [NSMutableData data];
}

- (void)uploadPic:(UIImage*)image withTakeTime:(NSString *)takeTime finished:(void (^)(BOOL ret, NSString* urlString))finished
{
    NSMutableURLRequest* rq = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@upload/take_time=%@",[PersonalProfile currentProfile].upload_pic_url,takeTime]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
    [rq setHTTPMethod: @"POST"];
    
    [rq setValue:@"jpeg" forHTTPHeaderField:@"Content-Type"];
    
    NSData* d = UIImageJPEGRepresentation(image, 0.8);
    [rq setHTTPBody:d];
    
    [NSURLConnection connectionWithRequest: rq delegate: self];
    
    self.finishedBlock = finished;
    self.receivedData = [NSMutableData data];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];

    if ([response isKindOfClass: [NSHTTPURLResponse class]])
    {
       
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];

    NSDictionary* result = [NSDictionary dictionaryWithJSONData:self.receivedData];
    //NSString* string  = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];

    if ( self.finishedBlock )
    {
        if ( [result[@"ret"] boolValue] )
        {
            self.finishedBlock(true, [NSString stringWithFormat:@"%@%@",[PersonalProfile currentProfile].upload_pic_url,result[@"info"][@"md5"]]);
        }
        else
        {
            self.finishedBlock(false,nil);
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];

     if ( self.finishedBlock )
     {
         self.finishedBlock(false,@"");
     }
}

- (void)dealloc
{
    
}

@end
