//
//  addperson.m
//  送哪儿
//
//  Created by 南江 on 15/5/12.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import "addperson.h"
#import "MBProgressHUD+MJ.h"


@interface addperson () <UIPickerViewDataSource, UIPickerViewDelegate>
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

- (IBAction)regbtn;

@end

@implementation addperson
- (void)viewDidLoad
{
    [super viewDidLoad];
 
    for (int component = 0; component < self.foods.count; component++) {
        [self pickerView:nil didSelectRow:0 inComponent:component];
    }
    
    
    [self tapOnce];
    [self tapBackground];
    
}

- (IBAction)regbtn {
     [self quzhi];

    
        [self postJSON:_zhi:self.phone.text :self.realname.text ];
    

    
    
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
    
    if (self.swith.on) {
        _ac=@"1";
        
    }else{
    
    _ac=@"0";
    }
    
    return _ac;
}

- (void)postJSON:(NSString *)text1 :(NSString *)text2:(NSString *)text3 {
    
    // 1. URL
    NSString *ur=[NSString stringWithFormat:@"%@/API/YWT_User.ashx",urlt];
    NSURL *url = [NSURL URLWithString:ur];
    @try
    {
        // 2. Request
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:2.0f];
        
        request.HTTPMethod = @"POST";
        
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *myString = [userDefaultes stringForKey:@"myidt2"];
 NSString *myString2 = [userDefaultes stringForKey:@"myidt"];
        [self getUniqueStrByUUID];
       // NSLog(@"%@",_uuid);
       
        _ac=@1;

        NSString *dtr=[NSString stringWithFormat:@"{\"User\":{\"UserType\":\"%@\",\"Mobile\":\"%@\",\"RealName\":\"%@\",\"SupplierID\":\"%@\",\"PassWord\":\"%@\",\"Active\":\"1\"}}",text1,text2,text3,myString,self.pwd.text];
        
        NSString *str = [NSString stringWithFormat:@"action=addsupuser&q0=%@",dtr];

       NSLog(@"%@?%@",ur,str);
        request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];

        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",result);
            if (!data==nil) {
                 NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSString *errstr2=[NSString stringWithFormat:@"%@",dict[@"Status"]];
              
                if ([errstr2 isEqualToString:@"0"]){
                      NSString *str=[NSString stringWithFormat:@"%@",dict[@"ReturnMsg"]];
                    
                    [MBProgressHUD showError:str];
                    
                    
                    
                    return ;
                
                
                }else{
                    [MBProgressHUD showSuccess:@"注册成功"];
                    [[self navigationController] popViewControllerAnimated:YES];

                
                }
               
            }];

            }else{
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [MBProgressHUD showError:@"网络异常请检查！"];
                return ;
                }];
            }
                       
            
        }];
    }@catch (NSException * e) {
        
    }
    
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
    [self.pwd resignFirstResponder];
    [self.cpwd resignFirstResponder];
[self.realname resignFirstResponder];
    [self.eamil resignFirstResponder];
    [self.xueli resignFirstResponder];
}

@end
