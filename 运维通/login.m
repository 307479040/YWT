//
//  login.m
//  运维通
//
//  Created by nan on 15-7-12.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "login.h"
#import "MBProgressHUD+MJ.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface login ()<UIApplicationDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *useName;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (nonatomic, strong) CLLocationManager *_locationManager;
@end

@implementation login

- (void)viewDidLoad
{
    [super viewDidLoad];
   // self.navigationController.navigationBarHidden=YES;
    self.navigationItem.hidesBackButton=YES;
    self.navigationController.navigationBarHidden=YES;
    
    if (![CLLocationManager locationServicesEnabled])
    { NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
        
    }
    
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [self._locationManager requestWhenInUseAuthorization]; }
    else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        
       self._locationManager.delegate=self;
        
       self._locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        
        CLLocationDistance distance=10.0;
        
        self._locationManager.distanceFilter=distance;
        
        [self._locationManager startUpdatingLocation];
    }
    UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dl_ren.png"]];
    self.useName.leftView=image;
    self.useName.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *image2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dl_suo.png"]];
    self.pwd.leftView=image2;
    self.pwd.leftViewMode = UITextFieldViewModeAlways;
    [self tapBackground];
    [self tapOnce];

}

- (IBAction)login:(id)sender {
    [self getLogon];
}
- (void)getLogon
{
    
    @try
    {
        NSString *urlStr = [NSString stringWithFormat:@"%@/api/YWT_User.ashx?action=login&q0=%@&q1=%@&q2=w&q3=w&q4=w",urlt,self.useName.text, self.pwd.text];
        
        NSURL *url = [NSURL URLWithString:urlStr];
        
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if (!data == nil) {
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    NSString *str=[NSString stringWithFormat:@"%@",dict[@"ReturnMsg"]];
                    NSLog(@"＋＋＋%@",dict[@"ResultObject"]);
                    
                    if ([str isEqualToString:@"Success"]) {
                        NSString *idt=[NSString stringWithFormat:@"%@",dict[@"ResultObject"][@"ID"]];
                        NSString *idt2=[NSString stringWithFormat:@"%@",dict[@"ResultObject"][@"SupplierID"]];
                         NSString *RealName=[NSString stringWithFormat:@"%@",dict[@"ResultObject"][@"RealName"]];
                        NSString *Company=[NSString stringWithFormat:@"%@",dict[@"ResultObject"][@"Company"]];
                         NSString *usertype=[NSString stringWithFormat:@"%@",dict[@"ResultObject"][@"UserType"]];
                         NSString *UserImg=[NSString stringWithFormat:@"%@",dict[@"ResultObject"][@"UserImg"]];
                         NSString *Mobile=[NSString stringWithFormat:@"%@",dict[@"ResultObject"][@"Mobile"]];
                          NSString *Certify=[NSString stringWithFormat:@"%@",dict[@"ResultObject"][@"Certify"]];
                        
                        
                        if ([usertype isEqualToString:@"10"]&[idt2 isEqualToString:@""]) {
                      [MBProgressHUD showSuccess:@"请完善账号！"];
                     [self performSegueWithIdentifier:@"wan" sender:nil];
                        }else{
                         NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        [userDefaults setObject:idt forKey:@"myidt"];
                        [userDefaults setObject:idt2 forKey:@"myidt2"];
                        [userDefaults setObject:self.useName.text forKey:@"iphone"];
                            [userDefaults setObject:RealName forKey:@"RealName"];
                            [userDefaults setObject:Company forKey:@"Company"];
                            [userDefaults setObject:usertype forKey:@"usertype"];
                            [userDefaults setObject:UserImg forKey:@"UserImg"];
                            [userDefaults setObject:Certify forKey:@"Certify"];
                            
                        [userDefaults synchronize];
                       
                        if ([idt2 isEqualToString:@""]&[usertype isEqualToString:@"0"]) {
                            [self performSegueWithIdentifier:@"wan" sender:nil];
                            [MBProgressHUD showSuccess:@"请完善账号设置！"];
                        }else{
                          
                            [MBProgressHUD showSuccess:@"登录成功！"];
                            if ([usertype isEqualToString:@"10"]) {
                            
                                 [self performSegueWithIdentifier:@"login" sender:nil];
                            }else if ([usertype isEqualToString:@"30"]) {
                                
                                [self performSegueWithIdentifier:@"login" sender:nil];
                            }else if ([usertype isEqualToString:@"20"]) {
                                
                                  [self performSegueWithIdentifier:@"sj" sender:nil];
                            }else if ([usertype isEqualToString:@"40"]) {
                                
                                [self performSegueWithIdentifier:@"3yw" sender:nil];
                            }

                            
                         
                        }
                        }
                                               
                    }else{
                        
                        [MBProgressHUD showError:@"账号或密码错误！"];
                        return ;}
                    
                }];
            }
        }];
    }@catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        
    }
    
}



-(void)tapBackground
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce)];//定义一个手势
    [tap setNumberOfTouchesRequired:1];//触击次数这里设为1
    [self.view addGestureRecognizer:tap];//添加手势到View中
}


-(void)tapOnce
{
    [self.useName resignFirstResponder];
    [self.pwd resignFirstResponder];
    
    
}
@end
