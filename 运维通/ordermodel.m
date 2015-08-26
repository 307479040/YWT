//
//  ordermodel.m
//  送哪儿
//
//  Created by apple on 15/4/29.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import "ordermodel.h"

@implementation ordermodel
+ (instancetype)tgWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
  
        NSString *tr=@"B6D13BE7-990C-4DA6-A757-088ED994D9EA";
        NSString *urlStr = [NSString stringWithFormat:@"%@/API/HDL_Order.ashx?action=getlist&q0=0&q1=%@&q2=-1",urlt,tr];
        
        NSURL *url = [NSURL URLWithString:urlStr];
      
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.0f];
        [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
        NSString *str = @"type=focus-c";//设置参数
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
     
        
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *dictarr=[dict objectForKey:@"ResultObject"];
        NSString *dict2=dictarr[@"OrderNo"];
        self.OrderNo=dict2;
    }
    return self;
}

@end
