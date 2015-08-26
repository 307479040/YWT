//
//  CbscsController.m
//  送哪儿
//
//  Created by pan on 15/7/8.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import "CbscsController.h"
#import "AFNetworkTool.h"
#import"MBProgressHUD+MJ.h"
#import<CoreLocation/CoreLocation.h>

@interface CbscsController ()<CLLocationManagerDelegate,UIAlertViewDelegate>
{
    NSDictionary *_dict;
    NSMutableArray *_dd;

    NSString *_addressName;
    int requestNumber;
    UIAlertView *alert;
}

@property (weak, nonatomic) IBOutlet UIScrollView *cbscsScrollV;
@property (weak, nonatomic) IBOutlet UILabel *DispatchNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *SendTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ReceiveIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *CustomerLabel;
@property (weak, nonatomic) IBOutlet UILabel *SupplierNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *DCDAndDriverLabel;
@property (weak, nonatomic) IBOutlet UILabel *AddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *ContactLabel;
@property (weak, nonatomic) IBOutlet UILabel *PickDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *TamountLabel;
@property (weak, nonatomic) IBOutlet UILabel *TContactLabel;
@property (weak, nonatomic) IBOutlet UILabel *TAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *DeliveryDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *NoteLabel;
- (IBAction)didClickCost:(id)sender;
- (IBAction)didClickSign:(id)sender;

- (IBAction)didClickLogisticsTrace:(id)sender;
- (IBAction)didClickChooseDriver:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *chooseDriverLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseDriverBut;
@property (weak, nonatomic) IBOutlet UIButton *conditionBut;
- (IBAction)didClickConditionBut:(id)sender;
@property(nonatomic,strong)CLLocationManager *locationManger;
@property(nonatomic,strong)CLGeocoder *geocoder;
@property (weak, nonatomic) IBOutlet UILabel *aaaBut;
@property (weak, nonatomic) IBOutlet UILabel *FYDNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *YDNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sureImageV;
@property (weak, nonatomic) IBOutlet UILabel *sureNameLabel;

@end
@implementation CbscsController
//测试数据
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cbscsScrollV.contentSize=CGSizeMake(320, 1000);
    self.conditionBut.hidden=YES;
    self.aaaBut.hidden=YES;
    
    self.sureNameLabel.hidden=YES;
    self.sureImageV.hidden=YES;

    requestNumber=0;
    [self.cbscsScrollV addSubview:self.aaaBut];
    
    self.locationManger = [[CLLocationManager alloc] init];
    self.locationManger.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManger.delegate = self;

    self.geocoder=[[CLGeocoder alloc]init];

    [self request];
}
-(void)requestaaa
{
    NSString *orderq= self.receiveOrderq;
    NSString *myString= self.receiveMyString;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/HDL_Order.ashx?action=getaorderall&q0=%@&q1=%@",urlt,orderq,myString];
    AFHTTPRequestOperation *op=[self GETurlString:urlStr];

    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@,%d",   [NSThread mainThread],[NSThread isMainThread]);
        NSLog(@"JSON: %@", responseObject);
        _dict=responseObject;

        NSMutableDictionary *bb=_dict[@"ResultObject"];
        NSMutableDictionary *gg=[bb objectForKey:@"OrderMain"];
        self.FYDNumLabel.text=[NSString stringWithFormat:@"%@",gg[@"FYDNum"]];
        self.YDNumLabel.text=[NSString stringWithFormat:@"%@",gg[@"YDNum"]];
        if([[NSString stringWithFormat:@"%@", gg[@"Status"]] isEqualToString:@"7"]){
            self.conditionBut.hidden=NO;
            self.aaaBut.hidden=NO;
            self.chooseDriverLabel.text=gg[@"DriverID_Name"];  //司机名字
            self.chooseDriverBut.userInteractionEnabled=NO;
            NSLog(@"%@",gg[@"Next_Status_Name"]);
            NSString *aa=gg[@"Next_Status_Name"];
            self.aaaBut.text=aa;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD showError:@"网络异常！"];

        return ;
        
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];

}

-(void)request
{
    
    NSString *orderq= self.receiveOrderq;
    NSString *myString= self.receiveMyString;
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/HDL_Order.ashx?action=getaorderall&q0=%@&q1=%@",urlt,orderq,myString];
    AFHTTPRequestOperation *op=[self GETurlString:urlStr];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSLog(@"%@,%d",   [NSThread mainThread],[NSThread isMainThread]);

        _dict=responseObject;
        NSMutableDictionary *bb=_dict[@"ResultObject"];
        NSMutableDictionary *cc=[bb objectForKey:@"appWLSend"];
        NSMutableDictionary *jj=[bb objectForKey:@"OrderMain"];
        
        NSLog(@"运费单%@,签收单%@",jj[@"FYDNum"],jj[@"YDNum"]);
        if (requestNumber==0) {
            self.DispatchNoLabel.text=cc[@"DispatchNo"];
            self.SendTypeLabel.text=cc[@"SendType"];
            self.ReceiveIDLabel.text=[NSString stringWithFormat:@"%@",cc[@"ReceiveID"]];
            self.CustomerLabel.text=cc[@"Customer"];
            self.SupplierNameLabel.text=cc[@"SupplierName"];
            self.DCDAndDriverLabel.text=cc[@"DCDAndDriver"];
            self.AddressLabel.text=cc[@"Address"];
            self.ContactLabel.text=cc[@"Contact"];
      
            NSString *dt3=cc[@"PickDate"];
            dt3=[dt3 stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
            dt3=[dt3 stringByReplacingOccurrencesOfString:@")/" withString:@""];
            NSString * timeStampString3 =dt3;
            NSTimeInterval _interval3=[timeStampString3 doubleValue] / 1000;
            NSDate *date3 = [NSDate dateWithTimeIntervalSince1970:_interval3];
            NSDateFormatter *objDateformat3 = [[NSDateFormatter alloc] init];
            [objDateformat3 setDateFormat:@"yyyy-MM-dd HH:mm"];
            self.PickDateLabel.text=[objDateformat3 stringFromDate: date3];
            
            self.TamountLabel.text=[NSString stringWithFormat:@"%@",cc[@"Tamount"]];
            self.TContactLabel.text=cc[@"TContact"];
            self.TAddressLabel.text=cc[@"TAddress"];
            
            NSString *dt4=cc[@"DeliveryDate"];
            dt4=[dt4 stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
            dt4=[dt4 stringByReplacingOccurrencesOfString:@")/" withString:@""];
            NSString * timeStampString4 =dt4;
            NSTimeInterval _interval4=[timeStampString4 doubleValue] / 1000;
            NSDate *date4 = [NSDate dateWithTimeIntervalSince1970:_interval4];
            NSDateFormatter *objDateformat4 = [[NSDateFormatter alloc] init];
            [objDateformat4 setDateFormat:@"yyyy-MM-dd HH:mm"];
            self.DeliveryDateLabel.text=[objDateformat4 stringFromDate: date4];
            
            self.NoteLabel.text=cc[@"Note"];
            self.FYDNumLabel.text=[NSString stringWithFormat:@"%@",jj[@"FYDNum"]];
            self.YDNumLabel.text=[NSString stringWithFormat:@"%@",jj[@"YDNum"]];
    
        }
        requestNumber++;
        NSMutableDictionary *gg=[bb objectForKey:@"OrderMain"];
        if([[NSString stringWithFormat:@"%@", gg[@"Status"]] isEqualToString:@"7"]){
            
            self.conditionBut.hidden=NO;
            self.aaaBut.hidden=NO;
            self.chooseDriverLabel.text=gg[@"DriverID_Name"];  //司机名字
            self.chooseDriverBut.userInteractionEnabled=NO;
            NSLog(@"%@",gg[@"Next_Status_Name"]);
            
            NSString *aa=gg[@"Next_Status_Name"];
            self.aaaBut.text=aa;
            
        }
        
        if([[NSString stringWithFormat:@"%@", gg[@"Status"]] isEqualToString:@"31"]){

            self.conditionBut.hidden=NO;
            self.aaaBut.hidden=NO;
            self.chooseDriverBut.userInteractionEnabled=NO;
            self.chooseDriverLabel.text=gg[@"DriverID_Name"];  //司机名字
            NSLog(@"%@",gg[@"Next_Status_Name"]);
            NSString *pp=gg[@"Next_Status_Name"];
            self.conditionBut.titleLabel.text=pp;
            self.aaaBut.text=pp;
   
        }
        
        if([[NSString stringWithFormat:@"%@", gg[@"Status"]] isEqualToString:@"32"]){
            self.conditionBut.hidden=NO;
            self.aaaBut.hidden=NO;
            self.chooseDriverBut.userInteractionEnabled=NO;
            self.chooseDriverLabel.text=gg[@"DriverID_Name"];  //司机名字

            NSLog(@"%@",gg[@"Next_Status_Name"]);
            NSString *kk=gg[@"Next_Status_Name"];
            self.conditionBut.titleLabel.text=kk;
            self.aaaBut.text=kk;

        }
        
        if([[NSString stringWithFormat:@"%@", gg[@"Status"]] isEqualToString:@"99"]){

            self.conditionBut.hidden=YES;
            self.aaaBut.hidden=YES;
            self.chooseDriverLabel.text=gg[@"DriverID_Name"];  //司机名字
//            self.aaaBut.text=@"订单已经签收";
//            self.aaaBut.layer.cornerRadius=50;
//            self.aaaBut.layer.cornerRadius=50;
//            [self.aaaBut setTextColor:[UIColor grayColor]];
            self.chooseDriverBut.userInteractionEnabled=NO;
            
            self.sureNameLabel.hidden=NO;
            self.sureImageV.hidden=NO;
 
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        [MBProgressHUD showError:@"网络异常！"];

        return ;
        
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
 
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   }


- (IBAction)didClickCost:(id)sender {
    NSLog(@"点击了费用单");
    [self performSegueWithIdentifier:@"cbscsCost" sender:nil];
    
}

- (IBAction)didClickSign:(id)sender {
    [self performSegueWithIdentifier:@"cbscsSign" sender:nil];
    
}
- (IBAction)didClickLogisticsTrace:(id)sender {
    
    [self performSegueWithIdentifier:@"logisticsTrace" sender:nil];
}

- (IBAction)didClickChooseDriver:(id)sender {
    NSLog(@"%@",NSHomeDirectory());
    [self performSegueWithIdentifier:@"chooseDriver" sender:nil];
    
    
}
- (IBAction)didClickConditionBut:(id)sender {
    NSMutableDictionary *bb=_dict[@"ResultObject"];
    NSMutableDictionary *gg=[bb objectForKey:@"OrderMain"];
    
    if([[NSString stringWithFormat:@"%@", gg[@"Status"]] isEqualToString:@"7"]){
        
        alert = [[UIAlertView alloc] initWithTitle:@"消息提示" message:@"是否确定提交？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert addButtonWithTitle:@"确定"];
        [alert show];
        
    }
    if([[NSString stringWithFormat:@"%@", gg[@"Status"]] isEqualToString:@"31"]){
        
        alert = [[UIAlertView alloc] initWithTitle:@"消息提示" message:@"是否确定提交？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert addButtonWithTitle:@"确定"];
        [alert show];

    }
    if([[NSString stringWithFormat:@"%@", gg[@"Status"]] isEqualToString:@"32"]){
        alert = [[UIAlertView alloc] initWithTitle:@"消息提示" message:@"是否确定提交？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert addButtonWithTitle:@"确定"];
        [alert show];

    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:{
            [alertView dismissWithClickedButtonIndex:1 animated:YES];
            [self.locationManger startUpdatingLocation];

            break;
        }
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{

    NSLog(@"新纬度:%f",newLocation.coordinate.latitude);
    NSLog(@"新经度:%f",newLocation.coordinate.longitude);
    [self.locationManger stopUpdatingLocation];
    
    NSMutableDictionary *bb=_dict[@"ResultObject"];
    NSMutableDictionary *gg=[bb objectForKey:@"OrderMain"];
    
    
    [self.geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *firstPlaceMark=[placemarks firstObject];
        NSLog(@"%@", firstPlaceMark.name);
        _addressName=firstPlaceMark.name;
        
        
        NSString *urlStr =[NSString stringWithFormat:@"%@/API/HDL_Order.ashx",urlt] ;
        NSString *str = [NSString stringWithFormat:@"action=saveorderflow&q0=%@&q1=%@&q2=%@&q3=%@&q4=%@&q5=%@",self.receiveOrderq,gg[@"Next_Status"],self.receiveMyString,[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude],[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude],_addressName];
        AFHTTPRequestOperation *op=  [self POSTurlString:urlStr parameters:str];
 [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSMutableDictionary *json=responseObject;
     if ([json[@"ReturnMsg"] isEqualToString:@"Success"]) {
                         // 延迟2秒执行：
                         double delayInSeconds = 1.0;
                         dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                         dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
         
                             [MBProgressHUD showSuccess:@"提交成功！"];
                         });
                         [self request];
                     }

 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     [MBProgressHUD showError:@"网络异常！"];

     return ;
 }];
        
        [[NSOperationQueue mainQueue] addOperation:op];

}];
    
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
}

@end
