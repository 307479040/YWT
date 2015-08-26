//
//  writedate.m
//  运维通
//
//  Created by abc on 15/8/3.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "writedate.h"
#import "MBProgressHUD+MJ.h"

@interface writedate ()
@property (weak, nonatomic) IBOutlet UITextField *bt;
@property (weak, nonatomic) IBOutlet UITextView *content;

@end

@implementation writedate



-(void)viewDidAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden=YES;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self tapBackground];
    [self tapOnce];
}

- (IBAction)save:(id)sender {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
    
    [self postJSON:myString :self.bt.text :self.content.text :@"123456.png" :@"0"];
}

- (IBAction)post:(id)sender {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
    
    [self postJSON:myString :self.bt.text :self.content.text :@"123456.png" :@"1"];
}

- (void)postJSON:(NSString *)text1:(NSString *)text2:(NSString *)text3:(NSString *)pic:(NSString *)text4

{
    
    NSString *urlstr=[NSString stringWithFormat:@"%@/API/YWT_YWLog.ashx",urlt];
    
    
     NSString *dater=[NSString stringWithFormat:@"{\"UserID\":\"%@\",\"Title\":\"%@\", \"Content\":\"%@\", \"LogStatus\":\"%@\"}",text1,text2,text3,text4];
    
    NSString *tu=[NSString stringWithFormat:@"[{\"FileName\":\"%@\"}]",pic];
    
    NSString *str = [NSString stringWithFormat:@"action=addedit&q0=%@&q1=%@",dater,tu];
    
    NSLog(@"%@?%@",urlstr,str);
    
    
    
    AFHTTPRequestOperation *op=[self POSTurlString:urlstr parameters:str];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        NSDictionary *dict=responseObject;
        
        NSString *sta=[NSString stringWithFormat:@"%@",dict[@"Status"]];
         NSString *msg=[NSString stringWithFormat:@"%@",dict[@"ReturnMsg"]];
        
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            if ([sta isEqualToString:@"1"]){
                
                [MBProgressHUD showSuccess:@"提交成功！"];
                
                [[self navigationController] popViewControllerAnimated:YES];
                
                
                
            }else{
                
                [MBProgressHUD showError:msg];
                
                return ;
                
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
    [self.bt resignFirstResponder];
    [self.content resignFirstResponder];

}

@end
