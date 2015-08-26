//
//  postapply.m
//  运维通
//
//  Created by ritacc on 15/7/26.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "postapply.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"


@interface postapply ()
@property (weak, nonatomic) IBOutlet UITextField *lxr;
@property (weak, nonatomic) IBOutlet UITextField *dh;
@property (weak, nonatomic) IBOutlet UITextField *time;
@property (weak, nonatomic) IBOutlet UITextView *nr;

@end

@implementation postapply
@synthesize strTtile;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tapBackground];
    [self tapOnce];
}

- (IBAction)post:(id)sender {
    [self tijiao2:self.nr.text :self.lxr.text :self.dh.text :@"" :@""];
}


-(void)tijiao2:(NSString *)t1:(NSString *)t2:(NSString *)t3:(NSString *)t4:(NSString *)t5{

    
    NSString *urlStr =[NSString stringWithFormat:@"%@/API/YWT_OrderPlatform.ashx",urlt] ;

    NSURL *url = [NSURL URLWithString:urlStr];


    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:2.0f];

    request.HTTPMethod = @"POST";
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
     NSString *mystring2=[NSString stringWithFormat:@"%@",strTtile];
    //    { Order_ID,Apply_UserID,Apply_Content,ContactMan,ContactMobile}
    
    NSString *dest=[NSString stringWithFormat:@"{\"Order_ID\":\"%@\",\"Apply_UserID\":\"%@\",\"Apply_Content\":\"%@\",\"ContactMan\":\"%@\",\"ContactMobile\":\"%@\"}",mystring2,myString,t1,t2,t3];
    NSString *str = [NSString stringWithFormat:@"action=applyyw&q0=%@&q1=%@",dest,myString];

    NSLog(@"%@?%@",urlStr,str);
    request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];


    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        NSLog(@"%@",result);
        if (!data==nil) {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSString *errstr2=[NSString stringWithFormat:@"%@",dict[@"Status"]];

            if ([errstr2 isEqualToString:@"0"]){
                NSString *str=[NSString stringWithFormat:@"%@",dict[@"ReturnMsg"]];

                [MBProgressHUD showError:str];



                return ;


            }else{
                [MBProgressHUD showSuccess:@"提交成功"];


            }

        }];

        }
        

    }];
}

-(void)tapBackground
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce)];//定义一个手势
    [tap setNumberOfTouchesRequired:1];//触击次数这里设为1
    [self.view addGestureRecognizer:tap];//添加手势到View中
}

-(void)tapOnce
{
    
    [self.lxr resignFirstResponder];
    [self.dh resignFirstResponder];
    [self.time resignFirstResponder];
    [self.nr resignFirstResponder];

    
}

@end
