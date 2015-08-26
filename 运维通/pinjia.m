//
//  pinjia.m
//  运维通
//
//  Created by ritacc on 15/7/25.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "pinjia.h"
#import "MBProgressHUD+MJ.h"


@interface pinjia ()
@property (weak, nonatomic) IBOutlet UILabel *danhao;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *style;

@property (weak, nonatomic) IBOutlet UILabel *dri;

@property (weak, nonatomic) IBOutlet UILabel *bt;
@property (nonatomic,strong)NSString *idtt;

@property (weak, nonatomic) IBOutlet UITextView *py;

@property (weak, nonatomic) IBOutlet UIButton *x1;
@property (weak, nonatomic) IBOutlet UIButton *x2;

@property (weak, nonatomic) IBOutlet UIButton *x3;
@property (weak, nonatomic) IBOutlet UIButton *x4;
@property (weak, nonatomic) IBOutlet UIButton *x5;
@property (nonatomic,strong)NSString *xin;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;


@end

@implementation pinjia
@synthesize strTtile;
@synthesize _locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    _locationManager= [[CLLocationManager alloc] init];
    
    _locationManager.delegate = self;
    
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    _locationManager.distanceFilter = 100;
    
    [_locationManager startUpdatingLocation];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        _locationManager.pausesLocationUpdatesAutomatically = NO;
    }
    [self requestaaa];
    
    [self tapOnce];
    [self tapBackground];
    
     self.scrollview.contentSize=CGSizeMake(320, 600);
}

-(void)requestaaa
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
    
    NSString *mystring2=[NSString stringWithFormat:@"%@",strTtile];
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_Order.ashx?action=getitem&q0=%@&q1=%@",urlt,mystring2,myString];
    AFHTTPRequestOperation *op=[self GETurlString:urlStr];
    NSLog(@"%@",urlStr);
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"%@,%d",   [NSThread mainThread],[NSThread isMainThread]);
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict2=responseObject;
        NSDictionary *dict=dict2[@"ResultObject"];
        NSLog(@"#####%@",dict);
        self.danhao.text=dict[@"OrderNo"];
        NSString *dt3=dict[@"CreateDateTime"];
        dt3=[dt3 stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
        dt3=[dt3 stringByReplacingOccurrencesOfString:@")/" withString:@""];
        // NSLog(@"%@",dt3);
        NSString * timeStampString3 =dt3;
        NSTimeInterval _interval3=[timeStampString3 doubleValue] / 1000;
        NSDate *date3 = [NSDate dateWithTimeIntervalSince1970:_interval3];
        NSDateFormatter *objDateformat3 = [[NSDateFormatter alloc] init];
        [objDateformat3 setDateFormat:@"yyyy-MM-dd"];
        self.time.text=[objDateformat3 stringFromDate: date3];
        
        [self idt:dict[@"Order_ID"]];
        
        self.style.text=dict[@"Status_Name"];
        self.bt.text=dict[@"OrderTitle"];
        if (![dict[@"OrderUsers"] isEqual:[NSNull null]]) {
            NSArray *dict3=dict[@"OrderUsers"];
            NSDictionary *dic=[dict3 objectAtIndex:0];
            if (![dic[@"RealName"] isEqual:[NSNull null]]) {
                NSString *dr=[NSString stringWithFormat:@"%@  %@",dic[@"RealName"],dic[@"Mobile"]];
                self.dri.text=dr;
                
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD showError:@"网络异常！"];
        
        return ;
        
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
    
}



- (IBAction)post:(id)sender {
    NSString *lat=[NSString stringWithFormat:@"%f",_locationManager.location.coordinate.latitude];
    NSString *longti=[NSString stringWithFormat:@"%f",_locationManager.location.coordinate.longitude];

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
    
    [self postJSON:@"0" :_idtt :@"完成" :_xin :self.py.text :myString];
    
}

-(NSString *)idt:(NSString *)id1{
    _idtt=id1;
    return _idtt ;
}

- (void)postJSON:(NSString *)Assess_Type:(NSString *)Order_ID:(NSString *)YW_Result:(NSString *)Score:(NSString *)AssessContent:(NSString *)Create_User
{
    //YWT_Order.ashx?action=orderassess&q0=
    
    NSString *urlstr=[NSString stringWithFormat:@"%@/API/YWT_Order.ashx",urlt];

    NSString *dest=[NSString stringWithFormat:@"{\"Assess_Type\":\"%@\",\"Order_ID\":\"%@\",\"YW_Result\":\"%@\",\"Score\":\"%@\",\"AssessContent\":\"%@\",\"Creator\":\"%@\"}",Assess_Type,Order_ID,YW_Result,Score,AssessContent,Create_User];
    
    NSString *str = [NSString stringWithFormat:@"action=orderassess&q0=%@",dest];
    
    
    NSLog(@"%@?%@",urlstr,str);

    
    AFHTTPRequestOperation *op=[self POSTurlString:urlstr parameters:str];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        NSDictionary *dict=responseObject;
        
        NSString *sta=[NSString stringWithFormat:@"%@",dict[@"Status"]];
        
        
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            if ([sta isEqualToString:@"1"]){
                
                [MBProgressHUD showSuccess:@"评价成功！"];
                
                [[self navigationController] popViewControllerAnimated:YES];
                
                
                
            }else{
                
                [MBProgressHUD showError:sta];
                
                return ;
                
            }
            
            
            
        }];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD showError:@"网络请求出错"];
        
        return ;
        
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
    
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [self requestaaa];
//    id vc=segue.destinationViewController;
//    if ([vc isKindOfClass:[finishion class]]) {
//        finishion *detai=vc;
//        NSString *mystring2=[NSString stringWithFormat:@"%@",_idtt];
//        [detai setValue:mystring2 forKey:@"strTtile"];
//        
//    }
}

-(void)tapBackground
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce)];//定义一个手势
    [tap setNumberOfTouchesRequired:1];//触击次数这里设为1
    [self.view addGestureRecognizer:tap];//添加手势到View中
}

-(void)tapOnce
{
    [self.py resignFirstResponder];

}

- (IBAction)x1:(id)sender {
    [self.x1 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
    [self.x2 setImage:[UIImage imageNamed:@"xin1 2"] forState:UIControlStateNormal];
    [self.x3 setImage:[UIImage imageNamed:@"xin1 2"] forState:UIControlStateNormal];
    [self.x4 setImage:[UIImage imageNamed:@"xin1 2"] forState:UIControlStateNormal];
    [self.x5 setImage:[UIImage imageNamed:@"xin1 2"] forState:UIControlStateNormal];
    _xin=@"1";
}

- (IBAction)x2:(id)sender {
        [self.x1 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
        [self.x2 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
    [self.x3 setImage:[UIImage imageNamed:@"xin1 2"] forState:UIControlStateNormal];
    [self.x4 setImage:[UIImage imageNamed:@"xin1 2"] forState:UIControlStateNormal];
    [self.x5 setImage:[UIImage imageNamed:@"xin1 2"] forState:UIControlStateNormal];
     _xin=@"2";
    
}
- (IBAction)x3:(id)sender {
    [self.x1 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
    [self.x2 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
        [self.x3 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
    [self.x4 setImage:[UIImage imageNamed:@"xin1 2"] forState:UIControlStateNormal];
    [self.x5 setImage:[UIImage imageNamed:@"xin1 2"] forState:UIControlStateNormal];
     _xin=@"3";
    
}
- (IBAction)x4:(id)sender {
    [self.x1 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
    [self.x2 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
    [self.x3 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
     [self.x4 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
        [self.x5 setImage:[UIImage imageNamed:@"xin1 2"] forState:UIControlStateNormal];
     _xin=@"4";
    
}
- (IBAction)x5:(id)sender {
    [self.x1 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
    [self.x2 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
    [self.x3 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
    [self.x4 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
        [self.x5 setImage:[UIImage imageNamed:@"xx1"] forState:UIControlStateNormal];
     _xin=@"5";
    
    
}

@end
