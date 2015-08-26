//
//  editview.m
//  送哪儿
//
//  Created by 南江 on 15/5/12.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import "editview.h"
#import "MBProgressHUD+MJ.h"

@interface editview ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *foods;
@property (weak, nonatomic) IBOutlet UITextField *sty;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *realname;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UITextField *cpwd;
@property (weak, nonatomic) IBOutlet UIButton *stybtn;
@property (weak, nonatomic) IBOutlet UISwitch *swith;
@property (weak, nonatomic) IBOutlet UITextField *sex;
@property (weak, nonatomic) IBOutlet UITextField *bdate;
@property (weak, nonatomic) IBOutlet UITextField *eamil;
@property (weak, nonatomic) IBOutlet UITextField *xueli;
@property (nonatomic,copy)NSString *uuid;
@property (nonatomic,copy)NSString *zhi;
@property (nonatomic,copy)NSString *ac;
@property (weak, nonatomic) IBOutlet UIButton *xiugai;

@end

@implementation editview
@synthesize strTtile;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (int component = 0; component < self.foods.count; component++) {
        [self pickerView:nil didSelectRow:0 inComponent:component];
    }
    
    [self network];

    [self tapOnce];
    [self tapBackground];
    
}

- (IBAction)regbtn {
    
    if ([self.username.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入登陆名！"];
        return;
    }else if([self.realname.text isEqualToString:@""]){
        [MBProgressHUD showError:@"请输入真实姓名！"];
        return;
    }else if([self.phone.text isEqualToString:@""]){
        [MBProgressHUD showError:@"请输入真实的手机号！"];
        return;
    }else{
        
  [self postJSON:self.phone.text:self.realname.text];
        [MBProgressHUD showSuccess:@"修改成功"];
[[self navigationController] popViewControllerAnimated:YES];
    }
    
    
    
}


-(void)network{
 
 
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
       NSString *myString = [userDefaultes stringForKey:@"personid"];
         NSString *myString2 = [userDefaultes stringForKey:@"myidt"];      //  NSString *mystring2=[NSString stringWithFormat:@"%@",strTtile];
    // NSString *tr=@"B6D13BE7-990C-4DA6-A757-088ED994D9EA";
        //NSLog(@"%@",myString)
        NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_User.ashx?action=getasupuser&q0=%@&q1=%@",urlt,myString,myString2];
        
        NSURL *url = [NSURL URLWithString:urlStr];
     
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.0f];
        [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
        NSString *str = @"type=focus-c";//设置参数
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
  
        
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (received==nil) {
            return;
        }else{
         NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *dictarr2=[dict objectForKey:@"ResultObject"];
       NSDictionary *dictarr=[dictarr2 objectForKey:@"User"];

 
     NSString *stye=[NSString stringWithFormat:@"%@",dictarr[@"UserType"]];
if ([stye isEqualToString:@"20"]) {
    self.sty.text=@"运维人员";
}else if ([stye isEqualToString:@"30"]){
  self.sty.text=@"调度人员";
 }
        if ([stye isEqualToString:@"10"]) {
            self.xiugai.hidden=YES;
        }
        self.username.text=dictarr[@"UserName"];
        self.sex.text=dictarr[@"UserName"];    self.realname.text=dictarr[@"RealName"];
        self.phone.text=dictarr[@"Mobile"];
        NSString *hg=[NSString stringWithFormat:@"%@",dictarr[@"Active"]];
       
        if ([hg isEqualToString:@"1"]) {
            [self.swith setOn:YES];
        }else{
            [self.swith setOn:NO];
        }

        }
               
      
    
    
}


- (void)postJSON:(NSString *)text1 :(NSString *)text2
{

        NSString *strurl=[NSString stringWithFormat:@"%@/API/YWT_User.ashx",urlt];
    NSURL *url = [NSURL URLWithString:strurl];
   
        // 2. Request
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:2.0f];
        
        request.HTTPMethod = @"POST";
        
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *myString = [userDefaultes stringForKey:@"myidt2"];
        NSString *mystring2 = [userDefaultes stringForKey:@"personid"];
    // NSString *mystring2=[NSString stringWithFormat:@"%@",strTtile];
       // [self getUniqueStrByUUID];
       // NSLog(@"%@",_uuid);
        [self quzhi];
        [self act];
        NSString *dstr=[NSString stringWithFormat:@"{\"ID\":\"%@\",\"Mobile\":%@, \"UserType\":\"%@\",\"SupplierID\":\"%@\", \"RealName\":\"%@\", \"Active\":%@}",mystring2,text1,_zhi,myString,text2,_ac];
        NSLog(@"---%@",dstr);
        // ? 数据体
        NSString *str = [NSString stringWithFormat:@"action=edit&q0=%@",dstr];
        // 将字符串转换成数据
        NSLog(@"%@",str);
        request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data==nil) {
                return ;
            }else{
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",result);
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSString *errstr2=[NSString stringWithFormat:@"%@",dict[@"Status"]];
                
                if ([errstr2 isEqualToString:@"0"]){
                    NSString *str=[NSString stringWithFormat:@"%@",dict[@"ReturnMsg"]];
                    [MBProgressHUD showError:str];
                    return ;
                    
                    
                }else{
                    [MBProgressHUD showSuccess:@"修改成功"];
                    [[self navigationController] popViewControllerAnimated:YES];
                    
                    
                }
                
            }];
            
            }
            
        }];
   
    
}
-(NSString *)quzhi{
    
    if ([self.sty.text isEqualToString:@"运维人员"]) {
        _zhi=@"20";
        
    }
    if ([self.sty.text isEqualToString:@"调度人员"]) {
        _zhi=@"30";
        
    }
    return _zhi;
}



-(NSString *)act{

    if ([self.swith isOn]) {
        NSString *kc=@1;
        _ac=kc;
    }else{
        
        NSString *kc=@0;
        _ac=kc;
    }
    
    return _ac;
}

- (NSString *)getUniqueStrByUUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    
    //get the string representation of the UUID
    
    NSString    *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    
    CFRelease(uuidObj);
    _uuid=uuidString;
    return _uuid;
    
}



- (NSArray *)foods
{
    if (_foods == nil) {
        
        _foods = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"name" ofType:@"plist"]];
    }
    return _foods;
}

#pragma mark - 数据源方法

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.foods.count;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *subfoods = self.foods[component];
    return subfoods.count;
}

#pragma mark - 代理方法

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.foods[component][row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.sty.text = self.foods[component][row];
    }
}

- (IBAction)selcetsty:(id)sender {
    self.pickerView.hidden=NO;
    self.stybtn.hidden=NO;
    
}
- (IBAction)querensty:(id)sender {
    self.pickerView.hidden=YES;
    self.stybtn.hidden=YES;
}

-(void)tapBackground
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce)];//定义一个手势
    [tap setNumberOfTouchesRequired:1];//触击次数这里设为1
    [self.view addGestureRecognizer:tap];//添加手势到View中
}


-(void)tapOnce
{
    [self.username resignFirstResponder];
    [self.phone resignFirstResponder];
    [self.realname resignFirstResponder];
}
-(void)viewDidDisappear:(BOOL)animated{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *g2=@"";
    [userDefaults setObject:g2 forKey:@"personid"];


    
}


@end
