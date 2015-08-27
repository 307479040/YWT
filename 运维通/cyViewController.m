//
//  cyViewController.m
//  送哪儿
//
//  Created by 南江 on 15/5/13.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import "cyViewController.h"
#import "MBProgressHUD+MJ.h"

@interface cyViewController ()
@property (weak, nonatomic) IBOutlet UITextField *cname;
@property (weak, nonatomic) IBOutlet UITextField *realname;
@property (weak, nonatomic) IBOutlet UITextField *addr;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *fax;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *mobile;
@property (weak, nonatomic) IBOutlet UIButton *regbtn;

@end

@implementation cyViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self network];
    
    [self tapBackground];
    [self tapOnce];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)network{
  
        
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"myidt2"];
    // NSString *mystring2=[NSString stringWithFormat:@"%@",strTtile];
    // NSString *tr=@"B6D13BE7-990C-4DA6-A757-088ED994D9EA";
    //NSLog(@"%@",myString)
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_Supplier.ashx?action=get&q0=%@",urlt,myString];
    
    NSURL *url = [NSURL URLWithString:urlStr];
 
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.0f];
        [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
        NSString *str = @"type=focus-c";//设置参数
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
       
        
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if(received!=nil){
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary *dictarr2=[dict objectForKey:@"ResultObject"];
            // NSDictionary *dictarr=[dictarr2 objectForKey:@"OrderMain"];
            NSLog(@"%@",url);
            self.cname.text=dictarr2[@"Company"];
            self.realname.text=dictarr2[@"ContactMan"];
            self.addr.text=dictarr2[@"Address"];
            self.phone.text=dictarr2[@"Tel"];
            self.fax.text=dictarr2[@"Fax"];
            self.email.text=dictarr2[@"Email"];
            self.mobile.text=dictarr2[@"Mobile"];
 
            
        }else
        {
            [MBProgressHUD showError:@"网络请求出错"];
            return ;
        }

    
    
    
}





- (IBAction)regbtns {
    if ([self.cname.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入公司全称！"];
        return;
    }else if([self.realname.text isEqualToString:@""]){
        [MBProgressHUD showError:@"请输入联系人姓名！"];
        return;
    }else if([self.addr.text isEqualToString:@""]){
        [MBProgressHUD showError:@"请输入地址！"];
        return;
    }else if([self.phone.text isEqualToString:@""]){
        [MBProgressHUD showError:@"请输入电话！"];
        return;
    }else if([self.mobile.text isEqualToString:@""]){
        [MBProgressHUD showError:@"请输入手机号！"];
        return;
    }else{
        
        [self postJSON:self.addr.text:self.cname.text:self.realname.text:self.email.text:self.fax.text:self.mobile.text:self.phone.text];
      
    }

    
}



- (void)postJSON:(NSString *)text1 :(NSString *)text2:(NSString *)text3:(NSString *)text4:(NSString *)text5:(NSString *)text6:(NSString *)text7
{

        NSString *urlstr=[NSString stringWithFormat:@"%@/API/YWT_Supplier.ashx",urlt];

        
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *myString = [userDefaultes stringForKey:@"myidt"];
         NSString *myString2 = [userDefaultes stringForKey:@"myidt2"];
        
        if ([myString2 isEqualToString:@""]) {
           NSString *dstr=[NSString stringWithFormat:@"{\"ID\":\"%@\",\"Address\":\"%@\", \"Company\":\"%@\", \"ContactMan\":\"%@\", \"Email\":\"%@\", \"Fax\":\"%@\", \"Mobile\":\"%@\", \"UserType\":1, \"Tel\":\"%@\"}",myString,text1,text2,text3,text4,text5,text6,text7];
            // ? 数据体
            NSString *str = [NSString stringWithFormat:@"action=addupdate&q0=%@&q1=%@",dstr,myString];
 
            
            AFHTTPRequestOperation *op=[self POSTurlString:urlstr parameters:str];
            [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"%@",responseObject);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [MBProgressHUD showError:@"网络请求出错"];
                return ;
            }];
            [[NSOperationQueue mainQueue] addOperation:op];

        }else{
           NSString *dstr=[NSString stringWithFormat:@"{\"ID\":\"%@\",\"Address\":\"%@\", \"Company\":\"%@\", \"ContactMan\":\"%@\", \"Email\":\"%@\", \"Fax\":\"%@\", \"Mobile\":\"%@\", \"UserType\":1, \"Tel\":\"%@\"}",myString2,text1,text2,text3,text4,text5,text6,text7];
            NSString *str = [NSString stringWithFormat:@"action=addupdate&q0=%@&q1=%@",dstr,myString];

            
            AFHTTPRequestOperation *op=[self POSTurlString:urlstr parameters:str];
            [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary *dict=responseObject;
                NSString *errstr2=[NSString stringWithFormat:@"%@",dict[@"Status"]];
                if ([errstr2 isEqualToString:@"0"]){
                    NSString *str=[NSString stringWithFormat:@"%@",dict[@"ReturnMsg"]];
                    [MBProgressHUD showError:str];
                    
                    return ;
                    
                }else{
                    [MBProgressHUD showSuccess:@"修改成功"];
                    [[self navigationController] popViewControllerAnimated:YES];
                    
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [MBProgressHUD showError:@"网络请求出错"];
                return ;
            }];
            [[NSOperationQueue mainQueue] addOperation:op];
            

         
        }

    
}


-(void)tapBackground
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce)];//定义一个手势
    [tap setNumberOfTouchesRequired:1];//触击次数这里设为1
    [self.view addGestureRecognizer:tap];//添加手势到View中
}


-(void)tapOnce
{
    [self.cname resignFirstResponder];
    [self.phone resignFirstResponder];
    [self.realname resignFirstResponder];
    [self.addr resignFirstResponder];
    [self.mobile resignFirstResponder];
    [self.fax resignFirstResponder];
    [self.email resignFirstResponder];
}


@end
