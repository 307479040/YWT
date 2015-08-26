//
//  cpassword.m
//  送哪儿
//
//  Created by 南江 on 15/5/13.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import "cpassword.h"
#import "MBProgressHUD+MJ.h"

@interface cpassword ()
@property (weak, nonatomic) IBOutlet UITextField *ypwd;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UITextField *cpwd;

@end

@implementation cpassword

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self tapBackground];
    [self tapOnce];
}
- (IBAction)btnc:(id)sender {
    if ([self.ypwd.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入原密码！"];
        return;
    }else if([self.pwd.text isEqualToString:@""]){
     [MBProgressHUD showError:@"请输入新密码！"];
    }else if(![self.pwd.text isEqualToString:self.cpwd.text]){
        [MBProgressHUD showError:@"新密码两次输入不相同！"];
    }else{
        [self postJSON:self.ypwd.text:self.pwd.text];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)postJSON:(NSString *)text1:(NSString *)text2
{
    
    NSString *urlstr=[NSString stringWithFormat:@"%@/API/YWT_User.ashx",urlt];

        
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *myString = [userDefaultes stringForKey:@"myidt"];
        NSString *str = [NSString stringWithFormat:@"action=alertpwd&q0=%@&q1=%@&q2=%@",myString,text1,text2];
    AFHTTPRequestOperation *op=[self POSTurlString:urlstr parameters:str];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict=responseObject;
        NSString *sta=[NSString stringWithFormat:@"%@",dict[@"ReturnMsg"]];
        
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if ([sta isEqualToString:@"Success"]){
                [MBProgressHUD showSuccess:@"修改密码成功,请重新登录！"];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *g2=@"";
                [userDefaults setObject:g2 forKey:@"passkey"];
                [self performSegueWithIdentifier:@"fanhui1" sender:nil];
            }else{
                [MBProgressHUD showError:@"您的原始密码错误！"];
            }
            
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络请求出错"];
        return ;
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
    
   
}
-(void)tapBackground
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce)];//定义一个手势
    [tap setNumberOfTouchesRequired:1];//触击次数这里设为1
    [self.view addGestureRecognizer:tap];//添加手势到View中
}


-(void)tapOnce
{
    [self.pwd resignFirstResponder];
    [self.cpwd resignFirstResponder];
    [self.ypwd resignFirstResponder];

}


@end
