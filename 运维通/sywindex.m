//
//  sywindex.m
//  运维通
//
//  Created by abc on 15/8/10.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "sywindex.h"
#import"MBProgressHUD+MJ.h"

@interface sywindex ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *realname;
@property (weak, nonatomic) IBOutlet UIButton *renz;
@property (weak, nonatomic) IBOutlet UILabel *wdyd;
@property (weak, nonatomic) IBOutlet UILabel *wcyd;
@property (weak, nonatomic) IBOutlet UILabel *dwcyd;

@end

@implementation sywindex

-(void)viewDidAppear:(BOOL)animated{

  self.navigationController.navigationBarHidden=NO;
    self.navigationItem.hidesBackButton=YES;
    self.tabBarController.tabBar.hidden=YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self network];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *Certify = [userDefaultes stringForKey:@"Certify"];
     NSString *RealName = [userDefaultes stringForKey:@"RealName"];
     NSString *UserImg = [userDefaultes stringForKey:@"UserImg"];
    self.realname.text=RealName;
    if ([Certify isEqualToString:@"0"]) {
        [self.renz setTitle:@"未认证" forState:UIControlStateNormal];
    }else if ([Certify isEqualToString:@"1"]) {
        [self.renz setTitle:@"已认证" forState:UIControlStateNormal];
    }
    
    if ([UserImg isEqualToString:@"/Upload/defaultPhoto.png"]) {
        return;
    }else{
        NSString *img=[NSString stringWithFormat:@"%@%@",urlt,UserImg];
        NSLog(@"%@",img);
        NSURL *imgurl=[NSURL URLWithString:img];
        UIImage *imgstr=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl]];
        self.icon.image=imgstr;

    }


    
}

-(void)network{
    
    
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/YWT_User.ashx?action=getordernum&q0=%@",urlt,myString];
    
    NSString *str = @"type=focus-c";
    
    NSLog(@"＝＝＝＝＝＝%@",urlStr);
    AFHTTPRequestOperation *op=[self POSTurlString:urlStr parameters:str];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict=responseObject;
        NSDictionary *dict1=dict[@"ResultObject"];
        self.wdyd.text=[NSString stringWithFormat:@"%@",dict1[@"AllNum"]];
        self.wcyd.text=[NSString stringWithFormat:@"%@",dict1[@"FinishNum"]];
        self.dwcyd.text=[NSString stringWithFormat:@"%@",dict1[@"NOFinishNum"]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        [MBProgressHUD showError:@"网络请求出错"];
        
        return ;
        
    }];
    
    
    
    [[NSOperationQueue mainQueue] addOperation:op];
    
    
    
}

@end
