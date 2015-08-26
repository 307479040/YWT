//
//  CustomerEidt.m
//  YWTIOS
//
//  Created by ritacc on 15/8/16.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "CustomerEidt.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "UIViewController+Extension.h"
#import "SBJson.h"


@interface CustomerEidt ()
@property (weak, nonatomic) IBOutlet UITextField *txtCusShort;
@property (weak, nonatomic) IBOutlet UITextField *txtCusFullName;
@property (weak, nonatomic) IBOutlet UITextField *txtContactMan;
@property (weak, nonatomic) IBOutlet UITextField *txtContactMobile;
@property (weak, nonatomic) IBOutlet UITextField *txtContactAddress;

@property (nonatomic,strong)NSString *tempid;
- (IBAction)btnSaveClick:(id)sender;

@end

@implementation CustomerEidt
@synthesize strTtile;

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self isBlankString:strTtile] == NO) {
        self.tempid=[NSString stringWithFormat:@"%@",strTtile];
        [self LoadItem];
    }
    [self tapBackground];
    [self tapOnce];
}
-(void) LoadItem
{
    self.tempid =strTtile;
    
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_Customer.ashx?action=getitem&q0=%@",urlt,strTtile];
    
    NSLog(@"%@",urlStr2);
    AFHTTPRequestOperation *op=[self GETurlString:urlStr2];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *json=responseObject;
        NSString *Status=[NSString stringWithFormat:@"%@",json[@"Status"]];
        if ([Status isEqualToString:@"0"]){
            NSString *ReturnMsg=[NSString stringWithFormat:@"%@",json[@"ReturnMsg"]];
            [MBProgressHUD showError:ReturnMsg];
            NSLog(@"%@",ReturnMsg);
        }else{
            NSDictionary *dict2=json[@"ResultObject"];
                        
            self.txtCusShort.text= [NSString stringWithFormat:@"%@",dict2[@"CusShort"]];
            self.txtCusFullName.text= [NSString stringWithFormat:@"%@",dict2[@"CusFullName"]];
            self.txtContactMan.text= [NSString stringWithFormat:@"%@",dict2[@"ContactMan"]];
            self.txtContactMobile.text= [NSString stringWithFormat:@"%@",dict2[@"ContactMobile"]];
            self.txtContactAddress.text= [NSString stringWithFormat:@"%@",dict2[@"ContactAddress"]];
        }
        NSLog(@"加载数据完成。");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD showError:@"网络异常！"];
        return ;
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
    //NSLog(@"LoadItem.strTtile=%@",strTtile);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*) SetValue {
    NSString *CusShort = [NSString stringWithFormat:@"%@",self.txtCusShort.text];
    NSString *CusFullName =  [NSString stringWithFormat:@"%@",self.txtCusFullName.text];
    NSString *ContactMan = [NSString stringWithFormat:@"%@",self.txtContactMan.text];
    NSString *ContactMobile = [NSString stringWithFormat:@"%@",self.txtContactMobile.text];
    NSString *ContactAddress = [NSString stringWithFormat:@"%@",self.txtContactAddress.text];
    
    
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *Create_User = [userDefaultes stringForKey:@"myidt"];
    NSLog(@"%@",Create_User);
    
    //NSMutableArray *jsonArray = [[NSMutableArray alloc]init];//创建最外层的数组
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];//创建内层的字典
    [dic setValue:CusShort forKey:@"CusShort"];
    [dic setValue:CusFullName forKey:@"CusFullName"];
    [dic setValue:ContactMan forKey:@"ContactMan"];
    [dic setValue:ContactMobile forKey:@"ContactMobile"];
    [dic setValue:Create_User forKey:@"Create_User"];
    
    [dic setValue:ContactAddress forKey:@"ContactAddress"];
    
    if ([self isBlankString:self.tempid] == NO) {
        [dic setValue:self.tempid forKey:@"CustomerID"];
    }
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *jsonString = [jsonWriter stringWithObject:dic];
    return jsonString;
}

- (IBAction)btnSaveClick:(id)sender {
    NSString *jsonString =[self SetValue];
    NSString *straction =[NSString stringWithFormat:@"add"];
    
    if ([self isBlankString:self.tempid] == NO) {
        straction =[NSString stringWithFormat:@"edit"];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_Customer.ashx",urlt];
    NSString *strparameters=[NSString stringWithFormat:@"action=%@&q0=%@",straction,jsonString];
    NSLog(@"%@",urlStr);
    NSLog(@"%@",strparameters);
    AFHTTPRequestOperation *op=  [self POSTurlString:urlStr parameters:strparameters];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *json=responseObject;
        
        NSString *Status=[NSString stringWithFormat:@"%@",json[@"Status"]];
        if ([Status isEqualToString:@"0"]){
            NSString *ReturnMsg=[NSString stringWithFormat:@"%@",json[@"ReturnMsg"]];
            [MBProgressHUD showError:ReturnMsg];
            NSLog(@"%@",ReturnMsg);
            return ;
        }else{
            [MBProgressHUD showSuccess:@"保存成功！"];
            [[self navigationController] popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络异常！"];
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
    [self.txtContactAddress resignFirstResponder];
    [self.txtContactMan resignFirstResponder];
    [self.txtContactMobile resignFirstResponder];
    [self.txtCusFullName resignFirstResponder];
    [self.txtCusShort resignFirstResponder];
}

@end
