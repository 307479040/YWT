//
//  ritaccreg.m
//  运维通
//
//  Created by nan on 15-7-12.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "ritaccreg.h"
#import "MBProgressHUD+MJ.h"


@interface ritaccreg ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UITextField *cpwd;
@property (weak, nonatomic) IBOutlet UIButton *regbtn;



@end

@implementation ritaccreg



- (void)viewDidLoad
{
    [super viewDidLoad];
      [self tapBackground];
    [self tapOnce];


}



- (IBAction)reg:(id)sender {
    
    if ([self.username.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入账号"];
        return;
    }else if([self.pwd.text isEqualToString:@""]){
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }else if(![self.pwd.text isEqualToString:self.cpwd.text]){
        [MBProgressHUD showError:@"两次密码不一致请重新输入"];
        return;
    }else{
        
        NSUUID *uuid=[UIDevice currentDevice].identifierForVendor;
        NSString *uuidstr=uuid.UUIDString;
        NSString *uuids=[NSString stringWithFormat:@"%@0000",uuidstr];
        NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
        NSString *os=[NSString stringWithFormat:@"ios%@",phoneVersion];
        NSString* phoneModel = [[UIDevice currentDevice] model];
        NSString* xh=[NSString stringWithFormat:@"%@",phoneModel];
        
       
        [self postJSON:self.username.text :self.pwd.text :@"":self.username.text :@"0" :uuids :os];
        
        
    }
    
    
    
    
}



- (void)postJSON:(NSString *)text1 :(NSString *)text2:(NSString *)text3 :(NSString *)text4:(NSString *)text5 :(NSString *)text6:(NSString *)text7
{
    
    NSString *strurl=[NSString stringWithFormat:@"%@/api/YWT_User.ashx",urlt];
    NSURL *url = [NSURL URLWithString:strurl];

        // 2. Request
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:2.0f];
        
        request.HTTPMethod = @"POST";

        NSString *dstr=[NSString stringWithFormat:@"{\"UserName\":\"%@\",\"PassWord\":\"%@\", \"Mobile\":%@, \"RealName\":\"%@\", \"UserType\":\"%@\",\"IMEI\":\"%@\", \"OS\":\"%@\"}",text1,text2,text3,text4,text5,text6,text7];
        
        // ? 数据体
        NSString *str = [NSString stringWithFormat:@"action=reg&q0=%@",dstr];
        // 将字符串转换成数据
        NSLog(@"%@?%@",url,str);
        request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
        // 把字典转换成二进制数据流, 序列化
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data==nil) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{                [MBProgressHUD showError:@"网络异常"];
                
                return ;
              }];
            }else{
             NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSString *errstr2=[NSString stringWithFormat:@"%@",dict[@"Status"]];
                
                if ([errstr2 isEqualToString:@"0"]){
                    NSString *str=[NSString stringWithFormat:@"%@",dict[@"ReturnMsg"]];
                    
                    [MBProgressHUD showError:str];
                    
                    return ;
                    
                }else{
                    
                    NSString* result= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"－－－－－－－%@",result);
                    NSData *data5 = [result dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *dict5=[NSJSONSerialization JSONObjectWithData:data5 options:NSJSONReadingMutableLeaves error:nil];
                    
                    NSDictionary *dict3=[dict5 objectForKey:@"ResultObject"];
                    NSString *myid=[NSString stringWithFormat:@"%@",dict3[@"ID"]];
                     NSString *mystyle=[NSString stringWithFormat:@"%@",dict3[@"UserType"]];                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:self.username.text forKey:@"iphone"];
                    [userDefaults setObject:myid forKey:@"myid"];
                       [userDefaults setObject:mystyle forKey:@"mystyle"];                      [userDefaults synchronize];
                    [MBProgressHUD showSuccess:@"恭喜您注册成功，只剩最后一步了哦！"];
                    [self performSegueWithIdentifier:@"zc" sender:nil];
                    
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
    [self.username resignFirstResponder];
    [self.pwd resignFirstResponder];
    [self.cpwd resignFirstResponder];
    
}

@end
