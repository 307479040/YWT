//
//  WarehouseAdd.m
//  znar
//
//  Created by ritacc on 15/8/8.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "WarehouseAdd.h"

#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "UIViewController+Extension.h"
#import "SBJson.h"
#import "WarehouseListController.h"

#define urlt @"http://ritacc.net"

@interface WarehouseAdd ()

@property (weak, nonatomic) IBOutlet UITextField *txtProductName;
@property (weak, nonatomic) IBOutlet UITextField *txtBrand;
@property (weak, nonatomic) IBOutlet UITextField *txtModel;
@property (weak, nonatomic) IBOutlet UITextField *txtNum;

@property (weak, nonatomic) IBOutlet UITextField *txtUnit;
@property (nonatomic,strong)NSString *tempid;



- (IBAction)BtnSaveClick:(id)sender;
@end

@implementation WarehouseAdd
@synthesize strTtile;
//@synthesize _locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
  if ([self isBlankString:strTtile] == NO) {
      self.tempid=[NSString stringWithFormat:@"%@",strTtile];
      [self LoadItem];
  }
    [self tapOnce];
    [self tapBackground];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) LoadItem
{
//    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//    NSString *Create_User = [userDefaultes stringForKey:@"myidt"];
    
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_Warehouse.ashx?action=getitem&q0=%@",urlt,strTtile];
    //YWT_YWLog.ashx?action=getcompanylist&q0=45885420-6c17-4b93-b367-d3eb55a8077c&q1=-1
    
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
            self.txtProductName.text= [NSString stringWithFormat:@"%@",dict2[@"Prodeuct_Name"]];;
            self.txtBrand.text= [NSString stringWithFormat:@"%@",dict2[@"Product_Brand"]];
            self.txtModel.text= [NSString stringWithFormat:@"%@",dict2[@"Prodeuct_Model"]];
            self.txtNum.text= [NSString stringWithFormat:@"%@",dict2[@"Number"]];
            self.txtUnit.text= [NSString stringWithFormat:@"%@",dict2[@"Unit"]];
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


-(NSString*) SetValue {
    NSString *ProductName = [NSString stringWithFormat:@"%@",self.txtProductName.text];
    NSString *Brand =  [NSString stringWithFormat:@"%@",self.txtBrand.text];
    NSString *Model = [NSString stringWithFormat:@"%@",self.txtModel.text];
    NSString *Number = [NSString stringWithFormat:@"%@",self.txtNum.text];
    NSString *Unit = [NSString stringWithFormat:@"%@",self.txtUnit.text];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *Create_User = [userDefaultes stringForKey:@"myidt"];
    NSLog(@"%@",Create_User);
    
    //NSMutableArray *jsonArray = [[NSMutableArray alloc]init];//创建最外层的数组
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];//创建内层的字典
    [dic setValue:ProductName forKey:@"Prodeuct_Name"];
    [dic setValue:Brand forKey:@"Product_Brand"];
    [dic setValue:Model forKey:@"Prodeuct_Model"];
    [dic setValue:Unit forKey:@"Unit"];
    [dic setValue:Create_User forKey:@"Create_User"];
    [dic setValue:@"" forKey:@"Prodeuct_Img"];
  
    if ([self isBlankString:self.tempid] == NO) {
        [dic setValue:self.tempid forKey:@"Warehouse_ID"];
    }
    
    if ([self isBlankString:Number] == NO) {
        [dic setValue:Number forKey:@"Number"];
    }

    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *jsonString = [jsonWriter stringWithObject:dic];
    return jsonString;
}

- (IBAction)BtnSaveClick:(id)sender {
    //{"Prodeuct_Name":"产品名称","Product_Brand":"品牌","Prodeuct_Model":"型号","Number":数量,"Unit":"单位： 个、件、套、米、台","Create_User":"添加、修改人ID"}
    NSString *jsonString =[self SetValue];
    NSString *straction =[NSString stringWithFormat:@"add"];

    if ([self isBlankString:self.tempid] == NO) {
       straction =[NSString stringWithFormat:@"edit"];
   }
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_Warehouse.ashx",urlt];
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

   // [jsonArray addObject:dic];
}


-(void)tapBackground
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce)];//定义一个手势
    [tap setNumberOfTouchesRequired:1];//触击次数这里设为1
    [self.view addGestureRecognizer:tap];//添加手势到View中
}

-(void)tapOnce
{
    [self.txtProductName resignFirstResponder];
        [self.txtBrand resignFirstResponder];
        [self.txtModel resignFirstResponder];
        [self.txtNum resignFirstResponder];
        [self.txtUnit resignFirstResponder];
}

@end
