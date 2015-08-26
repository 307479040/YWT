//
//  OnlineApprovalView.m
//  YWTIOS
//
//  Created by ritacc on 15/8/15.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "OnlineApprovalView.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "UIViewController+Extension.h"




@interface OnlineApprovalView ()
@property (weak, nonatomic) IBOutlet UILabel *lblNo;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UITextView *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *ApprovalTime;
@property (weak, nonatomic) IBOutlet UILabel *ApprovalResult;

@property (weak, nonatomic) IBOutlet UIImageView *img;

@end

@implementation OnlineApprovalView
@synthesize strTtile;

-(void)viewDidAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden=YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self LoadItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) LoadItem
{
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_OnlineApproval.ashx?action=getitem&q0=%@",urlt,strTtile];
    
    AFHTTPRequestOperation *op=[self GETurlString:urlStr2];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *json=responseObject;
        NSString *Status=[NSString stringWithFormat:@"%@",json[@"Status"]];
        if ([Status isEqualToString:@"0"]){
            NSString *ReturnMsg=[NSString stringWithFormat:@"%@",json[@"ReturnMsg"]];
            [MBProgressHUD showError:ReturnMsg];
            //NSLog(@"%@",ReturnMsg);
        }else{
            NSDictionary *dict2=json[@"ResultObject"];
            self.lblNo.text= [NSString stringWithFormat:@"%@",dict2[@"ApplyNo"]];
            self.lblTime.text=[self DateFormartMDHM:dict2[@"ApplyDate"]];
            self.lblType.text= [NSString stringWithFormat:@"%@",dict2[@"ApplyType"]];
            self.lblStatus.text= [NSString stringWithFormat:@"%@",dict2[@"ApprovalStatusName"]];
            self.lblContent.text= [NSString stringWithFormat:@"%@",dict2[@"ApplyContent"]];
            
            NSString *strStatus=[NSString stringWithFormat:@"%@",dict2[@"ApprovalStatus"]];
            NSLog(@"－－－－%@",strStatus);
            
            if ([strStatus isEqualToString:@"0"]){
                  self.img.image=[UIImage imageNamed:@"MoreAbout"];
                
            }else if([strStatus isEqualToString:@"2"]){
                self.ApprovalTime.text= [self DateFormartMDHM:dict2[@"ApprovalTime"]];
                self.ApprovalResult.text= [NSString stringWithFormat:@"%@",dict2[@"ApprovalResult"]];
                self.img.image=[UIImage imageNamed:@"jrzx_icon_ jxz2-1"];
            }else{
                self.ApprovalTime.text= [self DateFormartMDHM:dict2[@"ApprovalTime"]];
                self.ApprovalResult.text= [NSString stringWithFormat:@"%@",dict2[@"ApprovalResult"]];
            }
            
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

@end
