//
//  POSHelper.m
//  Boss
//
//  Created by jimmy on 16/4/20.
//  Copyright © 2016年 BORN. All rights reserved.
//

#import "POSHelper.h"
#import <CommonCrypto/CommonCryptor.h>

#define gIv @"0102030405060708"
#define AES_DECODE_PWD @"AA70CD77125FC304FEBF5E3EA4E9AFBD" //@"dynamicode"的MD5

#define AES_PWD @"635CDADD10338ACEFF167117A04C75DA" //@"ZFT1234%"


@implementation POSHelper

// 解密方法
+ (NSString*)decrypt:(NSString*)encryptText
{
    return [POSHelper decrypt:encryptText password:AES_DECODE_PWD];
}

+ (NSString*)decrypt:(NSString*)encryptText password:(NSString *)pwd
{
    if ( encryptText.length == 0 )
        return @"";
    
    NSData *encryptData = [POSHelper stringToHex:encryptText];
    
    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeAES128) & ~(kCCBlockSizeAES128 - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [pwd UTF8String];
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithmAES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySizeAES128,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                     length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    if (bufferPtr != NULL) {
        free(bufferPtr);
        bufferPtr = NULL;
    }
    return result;
}

+ (NSString*)encrypt:(NSString*)plainText
{
    return [POSHelper encrypt:plainText password:AES_PWD];
}

+ (NSString*)encrypt:(NSString*)plainText password:(NSString *)pwd
{
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeAES128) & ~(kCCBlockSizeAES128 - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [pwd UTF8String];
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithmAES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySizeAES128,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString *result=[POSHelper hexStringFromString:myData];
    if (bufferPtr != NULL)
    {
        free(bufferPtr);
        bufferPtr = NULL;
    }
    //bufferPtrSize=nil;
    return result;
}

+ (NSString *)hexStringFromString:(NSData *)myD{
    
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

+(NSData *)stringToHex:(NSString *)hexString{
    
    
    int j=0;
    int length=[hexString length];
    Byte bytes[length];  ///3ds key的Byte 数组， 128位
    
    for(int i=0;i<length;i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    
    
    NSData *encryptData = [[NSData alloc] initWithBytes:bytes length:j];
    return encryptData;
    
    
}

@end
