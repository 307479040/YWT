//
//  WarehouseView.m
//  YWTIOS
//
//  Created by ritacc on 15/8/9.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "WarehouseView.h"

#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "UIViewController+Extension.h"



#define urlt @"http://ritacc.net"


@interface WarehouseView ()


@property (weak, nonatomic) IBOutlet UILabel *txtProductName;
@property (weak, nonatomic) IBOutlet UILabel *txtBrand;
@property (weak, nonatomic) IBOutlet UILabel *txtModel;
@property (weak, nonatomic) IBOutlet UILabel *txtNum;



@end

@implementation WarehouseView
@synthesize strTtile;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self isBlankString:strTtile] == NO) {
        [self LoadItem];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) LoadItem
{
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_Warehouse.ashx?action=getitem&q0=%@",urlt,strTtile];

   
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
            self.txtProductName.text= [NSString stringWithFormat:@"%@",dict2[@"Prodeuct_Name"]];;
            self.txtBrand.text= [NSString stringWithFormat:@"%@",dict2[@"Product_Brand"]];
            self.txtModel.text= [NSString stringWithFormat:@"%@",dict2[@"Prodeuct_Model"]];
            self.txtNum.text= [NSString stringWithFormat:@"%@ %@",dict2[@"Number"],dict2[@"Unit"]];
            //self.txtUnit.text= [NSString stringWithFormat:@"%@",dict2[@"Unit"]];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
