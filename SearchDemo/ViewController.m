//
//  ViewController.m
//  SearchDemo
//
//  Created by xfq on 2020/12/8.
//  Copyright © 2020 xfq. All rights reserved.
//

#import "ViewController.h"
#import "TestController.h"
#import "ChineseToPinyin.h"

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)buttonAction:(id)sender {
    TestController *test= [[TestController alloc] init];
    [self.navigationController pushViewController:test animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];

   
}


+ (BOOL)IsContainsChinese:(NSString *)str{
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}
+ (NSString *) pinyinFromChiniseString:(NSString *)string {
    if(!string || ![string length]) return nil;
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding( kCFStringEncodingGB_18030_2000);
    NSData *gb2312_data = [string dataUsingEncoding:enc];
    
    unsigned char ucHigh, ucLow;
    int nCode;
    NSString *strValue = @"";
    int iLen = [gb2312_data length];
    char *gb2312_string = (char *)[gb2312_data bytes];
    for (int i = 0; i < iLen; i++) {
        if ((unsigned char)gb2312_string[i] < 0x80 ) {
            strValue = [strValue stringByAppendingFormat:@"%c", gb2312_string[i] > 95 ? gb2312_string[i] - 32 : gb2312_string[i]];
            continue;
        }
        
        ucHigh = (unsigned char)gb2312_string[i];
        ucLow  = (unsigned char)gb2312_string[i + 1];
        if ( ucHigh < 0xa1 || ucLow < 0xa1)
            continue;
        else
            nCode = (ucHigh - 0xa0) * 100 + ucLow - 0xa0;
        
        NSString *strRes = FindLetter(nCode);
        strValue = [strValue stringByAppendingString:strRes];
        i++;
    }
    return [[NSString alloc] initWithString:strValue]
            ;
}


+ (NSString *)getHeaderLetterWithString:(NSString *)str
{
    NSString *headerLetter = @"";
    NSInteger length = [str length];
    if (length >= 1) {
        int loop;
        if (length >= 2) {
            loop = 2;
        }else{
            loop = 1;
        }
        int i = 0;
        for (; loop > 0 ; loop--,i++) {
            NSString *letter = [str substringWithRange:NSMakeRange(0 + i, 1)];
            if ([self IsContainsChinese:letter]) {
               
            }else{
                char c = [[letter uppercaseString] characterAtIndex:0];
                
                if (!(c>='A'&& c<='Z')) {
                    NSString *string = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
                    NSString *pyString = [self pinyinFromChiniseString:string];
                    if ([pyString length] >=1) {
                        c = [[[pyString substringWithRange:NSMakeRange(0, 1)] uppercaseString] characterAtIndex:0];
                        if (!(c>='A'&& c<='Z')) {
                            letter =  [NSString stringWithFormat:@"%c",c];
                        }
                    }
                    
                }else{
                    letter = [NSString stringWithFormat:@"%c",c];
                }
            }
            headerLetter = [NSString stringWithFormat:@"%@%@",headerLetter,letter];
        }
        
    }else {
        
        headerLetter = @"#";
    }
    
    return headerLetter;
}



@end
