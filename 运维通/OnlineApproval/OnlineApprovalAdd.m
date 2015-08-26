//
//  OnlineApprovalAdd.m
//  YWTIOS
//
//  Created by ritacc on 15/8/14.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "OnlineApprovalAdd.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "UIViewController+Extension.h"
#import "SBJson.h"

#define urlt @"http://ritacc.net"


@interface OnlineApprovalAdd ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *sgType;
@property (weak, nonatomic) IBOutlet UITextView *txtContent;

- (IBAction)btnSaveClick:(id)sender;
@end

@implementation OnlineApprovalAdd

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*) SetValue {
   
    NSString *ApplyContent =  [NSString stringWithFormat:@"%@",self.txtContent.text];
    NSInteger indexseg= self.sgType.selectedSegmentIndex;
    NSString *ApplyType=@"其它";
    if (indexseg==0) {
        ApplyType=@"购买配件";
    }
    else if(indexseg==1) {
        ApplyType=@"增加人员";
    }
     

    //Json数据 {"ApplyType":"","ApplyContent":"申请内容","ApplyUserID":"申请人"}
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *Create_User = [userDefaultes stringForKey:@"myidt"];
    NSLog(@"%@",Create_User);
    
    //NSMutableArray *jsonArray = [[NSMutableArray alloc]init];//创建最外层的数组
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];//创建内层的字典
    [dic setValue:ApplyType forKey:@"ApplyType"];
    [dic setValue:ApplyContent forKey:@"ApplyContent"];
    [dic setValue:Create_User forKey:@"ApplyUserID"];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *jsonString = [jsonWriter stringWithObject:dic];
    return jsonString;
}

- (IBAction)btnSaveClick:(id)sender {
    NSString *jsonString =[self SetValue];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_OnlineApproval.ashx",urlt];
    NSString *strparameters=[NSString stringWithFormat:@"action=%@&q0=%@",@"add",jsonString];
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
@end
