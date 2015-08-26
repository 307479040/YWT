//
//  ApplyApproval.m
//  YWTIOS
//
//  Created by ritacc on 15/8/15.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "ApplyApproval.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "UIViewController+Extension.h"


@interface ApplyApproval ()
@property (weak, nonatomic) IBOutlet UILabel *lblNo;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblType;


@property (weak, nonatomic) IBOutlet UITextView *lblContent;

@property (weak, nonatomic) IBOutlet UILabel *lblApplyUser;

@property (weak, nonatomic) IBOutlet UISegmentedControl *sgStatus;
@property (weak, nonatomic) IBOutlet UITextField *txtResult;

@property (nonatomic,strong)NSString *tempid;
- (IBAction)btnSaveClick:(id)sender;
@end

@implementation ApplyApproval
@synthesize strTtile;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self LoadItem];
    self.tempid=strTtile;
    [self tapBackground];
    [self tapOnce];
}

-(void)viewDidAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden=YES;
 
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
            self.lblContent.text= [NSString stringWithFormat:@"%@",dict2[@"ApplyContent"]];
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


- (IBAction)btnSaveClick:(id)sender {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *Create_User = [userDefaultes stringForKey:@"myidt"];
    
    NSInteger indexseg= self.sgStatus.selectedSegmentIndex;
    int istatus=1;
    if (indexseg!=0) {
        istatus=2;//拒绝
    }
     NSString *strResult=[NSString stringWithFormat:@"%@",self.txtResult.text];
    if(istatus== 2 && [self isBlankString:strResult] == YES)
    {
        [MBProgressHUD showError:@"请输入审核意见！"];
        return;
    }
    
    /*
    YWT_OnlineApproval.ashx?action=approval&q0=&q1=&q2=&q3=	审批
    q0	申请ID OnlineApproval_ID
    q1	审核人ID
    q2	1 同意 2 不同意
    q3	审批意见 审核人填写
    */
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_OnlineApproval.ashx",urlt];
    NSString *strparameters=[NSString stringWithFormat:@"action=approval&q0=%@&q1=%@&q2=%d&q3=%@"
                             ,self.tempid,Create_User,istatus,strResult];
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
    [self.txtResult resignFirstResponder];
    
}


@end
