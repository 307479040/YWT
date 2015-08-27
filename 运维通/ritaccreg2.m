//
//  ritaccreg2.m
//  运维通
//
//  Created by nan on 15-7-12.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "ritaccreg2.h"
#import "MBProgressHUD+MJ.h"


@interface ritaccreg2 ()
@property(nonatomic,copy)NSString *IDF;
@property (weak, nonatomic) IBOutlet UITextField *cname;
@property (weak, nonatomic) IBOutlet UITextField *tel;
@property (weak, nonatomic) IBOutlet UITextField *realname;
@property (weak, nonatomic) IBOutlet UITextField *sty;
@property (weak, nonatomic) IBOutlet UIButton *stybtn;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, strong) NSArray *foods;

@end

@implementation ritaccreg2



- (void)viewDidLoad
{
    [super viewDidLoad];
    for (int component = 0; component < self.foods.count; component++) {
        [self pickerView:nil didSelectRow:0 inComponent:component];
    }
    [self tapBackground];
    [self tapOnce];

}
- (void)postJSON1:(NSString *)text1 :(NSString *)text2:(NSString *)text3{
    
    NSString *strurl=[NSString stringWithFormat:@"%@/api/YWT_Supplier.ashx",urlt];
    NSURL *url = [NSURL URLWithString:strurl];
        // 2. Request
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:2.0f];
        
        request.HTTPMethod = @"POST";
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myid = [userDefaultes stringForKey:@"myid"];
    NSString *iphone=[userDefaultes stringForKey:@"iphone"];
        
        NSString *dstr=[NSString stringWithFormat:@"{\"Company\":\"%@\",\"RealName\":\"%@\",\"Mobil\":\"%@\",\"UserType\":\"10\",\"Active\":\"1\"}",text1,text2,iphone];
        
    
        
        NSString *str = [NSString stringWithFormat:@"action=addupdate&q0=%@&q1=%@",dstr,myid];
        // 将字符串转换成数据
        NSLog(@"%@",str);
        request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
        // 把字典转换成二进制数据流, 序列化
        
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data==nil) {
                [MBProgressHUD showError:@"网络异常"];
                
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
                    [MBProgressHUD showSuccess:@"恭喜您，注册成功！"];
                    [self performSegueWithIdentifier:@"fanhui1" sender:nil];
                    
                }
                
            }];
        
            
            }
                       
            
        }];
        
}

- (IBAction)fghZ:(id)sender {
    self.stybtn.hidden=YES;
    self.pickerView.hidden=YES;
    if ([self.sty.text isEqualToString:@"维运商"]) {
        self.cname.hidden=NO;
        self.tel.hidden=NO;
    }else{
        self.cname.hidden=YES;
        self.tel.hidden=YES;
    }
}


- (IBAction)selcetsty:(id)sender {
    self.pickerView.hidden=NO;
    self.stybtn.hidden=NO;
    
}

- (NSArray *)foods
{
    if (_foods == nil) {
        
        _foods = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"style" ofType:@"plist"]];
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



- (void)postJSON2:(NSString *)text1 {
    
    NSString *strurl=[NSString stringWithFormat:@"%@/api/YWT_User.ashx",urlt];
    NSURL *url = [NSURL URLWithString:strurl];
    @try
    {
        // 2. Request
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:2.0f];
        
        request.HTTPMethod = @"POST";
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *myid = [userDefaultes stringForKey:@"myid"];
        NSString *iphone=[userDefaultes stringForKey:@"iphone"];
        
        NSString *dstr=[NSString stringWithFormat:@"{\"ID\":\"%@\",\"RealName\":\"%@\",\"UserType\":\"40\",\"Mobile\":\"%@\",\"Active\":\"1\"}",myid,text1,iphone];
     
        
        NSString *str = [NSString stringWithFormat:@"action=edit&q0=%@",dstr];
        // 将字符串转换成数据
        NSLog(@"%@",str);
        request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
        // 把字典转换成二进制数据流, 序列化
        
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if (!data==nil) {
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
                    [MBProgressHUD showSuccess:@"恭喜您，注册成功！"];
                    [self performSegueWithIdentifier:@"fanhui1" sender:nil];
                    
                }
                
            }];

            }else{
             [MBProgressHUD showError:@"网络请求出错！"];
                return ;
            }
                     
            
            
        }];
    }@catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        UIAlertView * alert = [
                               [UIAlertView alloc]
                               initWithTitle:@"错误"
                               message: [[NSString alloc] initWithFormat:@"网络连接异常"]
                               delegate:self
                               cancelButtonTitle:nil
                               otherButtonTitles:@"OK", nil];
        [alert show];
        
    }
    
}



- (IBAction)TIJIAO:(id)sender {

    if ([self.sty.text isEqualToString:@"维运商"]) {
        if ([self.realname.text isEqualToString:@""]) {
            [MBProgressHUD showError:@"请输入姓名"];
            return;
        }else if ([self.cname.text isEqualToString:@""]) {
            [MBProgressHUD showError:@"请输入公司名称"];
            return;
        }else if ([self.tel.text isEqualToString:@""]) {
            [MBProgressHUD showError:@"请输入联系电话"];
            return;
        }else{
            [self postJSON1:self.cname.text :self.realname.text :self.tel.text];
        }

    }else {
          if ([self.realname.text isEqualToString:@""]) {
            [MBProgressHUD showError:@"请输入姓名"];
            return;
        }else{
        [self postJSON2:self.realname.text];
        }

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
    [self.cname resignFirstResponder];
    [self.realname resignFirstResponder];
    [self.tel resignFirstResponder];
    
}

@end
