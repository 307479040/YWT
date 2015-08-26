//
//  gerenzliao.m
//  运维通
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "gerenzliao.h"
#import "MBProgressHUD+MJ.h"

@interface gerenzliao ()
@property (weak, nonatomic) IBOutlet UILabel *sty;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *tel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *time;
@property (weak, nonatomic) IBOutlet UITextField *sex;
@property (weak, nonatomic) IBOutlet UITextField *sheng;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *qu;
@property (weak, nonatomic) IBOutlet UITextField *detail;
@property (weak, nonatomic) IBOutlet UITextField *xueli;
@property (weak, nonatomic) IBOutlet UITextField *xuexiao;
@property (weak, nonatomic) IBOutlet UITextField *zhuanye;
@property (weak, nonatomic) IBOutlet UITextField *btime;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextView *jineng;
@property (weak, nonatomic) IBOutlet UITextView *zc;

@end

@implementation gerenzliao

- (void)viewDidLoad {
    [super viewDidLoad];
    [self network];
    self.scrollView.contentSize=CGSizeMake(320,700);

}



-(void)network{
    
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_User.ashx?action=getasupuser&q0=%@&q1=%@",urlt,myString,myString];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"%@",url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.0f];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str = @"type=focus-c";//设置参数
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    if (data==nil) {
        return;
    }else{
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *dictarr2=[dict objectForKey:@"ResultObject"];
        NSLog(@"---%@",dict);
        NSDictionary *dictarr=[dictarr2 objectForKey:@"User"];
         NSDictionary *dictarr3=[dictarr2 objectForKey:@"UserInfo"];
        NSString *sty=[NSString stringWithFormat:@"%@",dictarr[@"UserType"]];
        if ([sty isEqualToString:@"10"]) {
            self.sty.text=@"维运商";
        }else if([sty isEqualToString:@"20"]){
            self.sty.text=@"维运人员";
        }else if([sty isEqualToString:@"40"]){
            self.sty.text=@"调度";}
        self.tel.text=dictarr[@"UserName"];
        self.name.text=dictarr[@"RealName"];
         self.email.text=dictarr[@"Email"];
        self.city.text=dictarr3[@"Location_Province"];
        self.city.text=dictarr3[@"Location_City"];
        self.qu.text=dictarr3[@"Location_County"];
        self.detail.text=dictarr3[@"User_Address"];
        self.xueli.text=dictarr3[@"HighestEducation"];
        self.xuexiao.text=dictarr3[@"Finish_School"];
        self.zhuanye.text=dictarr3[@"SpecialtyName"];
        
        self.jineng.text=dictarr3[@"SkillDescription"];
        self.zhuanye.text=dictarr3[@"Specialty"];
        
        
        
        NSString *dt3=dictarr3[@"Birthday"];
        
        dt3=[dt3 stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
        dt3=[dt3 stringByReplacingOccurrencesOfString:@")/" withString:@""];
        NSLog(@"%@",dt3);
        NSString * timeStampString3 =dt3;
        NSTimeInterval _interval3=[timeStampString3 doubleValue] / 1000;
        NSDate *date3 = [NSDate dateWithTimeIntervalSince1970:_interval3];
        NSDateFormatter *objDateformat3 = [[NSDateFormatter alloc] init];
        [objDateformat3 setDateFormat:@"yyyy-MM-dd HH:mm"];
        self.time.text=[objDateformat3 stringFromDate: date3];
        
       
        
        NSString *dt4=dictarr3[@"GraduationData"];
        
        dt4=[dt4 stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
        dt4=[dt4 stringByReplacingOccurrencesOfString:@")/" withString:@""];
        NSLog(@"%@",dt4);
        NSString * timeStampString4 =dt4;
        NSTimeInterval _interval4=[timeStampString4 doubleValue] / 1000;
        NSDate *date4 = [NSDate dateWithTimeIntervalSince1970:_interval4];
        NSDateFormatter *objDateformat4 = [[NSDateFormatter alloc] init];
        [objDateformat4 setDateFormat:@"yyyy-MM-dd HH:mm"];
         self.btime.text=[objDateformat4 stringFromDate: date4];
        
    }
}

- (void)postJSON:(NSString *)text1 :(NSString *)text2:(NSString *)text3:(NSString *)text4:(NSString *)text5:(NSString *)text6 :(NSString *)text7:(NSString *)text8:(NSString *)text9:(NSString *)text10:(NSString *)text11 :(NSString *)text12:(NSString *)text13{
    
    NSString *strurl=[NSString stringWithFormat:@"%@/API/YWT_User.ashx",urlt];
    NSURL *url = [NSURL URLWithString:strurl];
        // 2. Request
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:2.0f];
        
        request.HTTPMethod = @"POST";
        
        
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *myString = [userDefaultes stringForKey:@"myidt"];
        
        NSString *dstr=[NSString stringWithFormat:@"{\"YWTUser_ID\":\"%@\",\"Create_User\":\"%@\",\"User_Sex\":\"%@\",\"Location_Province\":\"%@\",\"Location_City\":\"%@\",\"Location_County\":\"%@\", \"User_Address\":\"%@\", \"Birthday\":\"%@\", \"Email\":\"%@\", \"HighestEducation\":\"%@\", \"Finish_School\":\"%@\", \"SpecialtyName\":\"%@\", \"GraduationData\":\"%@\", \"SkillDescription\":\"%@\", \"Specialty\":\"%@\"}",myString,myString,text1,text2,text3,text4,text5,text6,text7,text8,text9,text10,text11,text12,text13];
        
        // ? 数据体
        NSString *str = [NSString stringWithFormat:@"action=editselfinfo&q0=%@",dstr];
        // 将字符串转换成数据
    
        request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
        // 把字典转换成二进制数据流, 序列化
          NSLog(@"%@?%@",strurl,str);
        
        // 3. Connection
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         
            if (!data==nil) {
           
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            
        }else{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [MBProgressHUD showError:@"网络异常请检查！"];
                return ;
            }];
        }
            
            
            
        }];
  
    
}

- (IBAction)tijiao:(id)sender {
    if ([self.sty.text isEqualToString:@"维运商"]) {
       NSString *timeSp=@"1331121231000";
        NSString *timet1= [NSString stringWithFormat:@"\\/Date(%@)\\/",timeSp];
        NSString *timet2= [NSString stringWithFormat:@"\\/Date(%@)\\/",timeSp];
        NSString *te=@"10";
        [self postJSON:self.sex.text:self.sheng.text:self.city.text:self.qu.text:self.detail.text:timet1:self.email.text:self.xueli.text:self.xuexiao.text:self.zhuanye.text:timet2:self.jineng.text:self.zc.text];
        [MBProgressHUD showSuccess:@"修改成功"];
        [[self navigationController] popViewControllerAnimated:YES];
        
    }else if ([self.sty.text isEqualToString:@"维运人员"]) {
       NSString *timeSp=@"1331121231000";
        NSString *timet1= [NSString stringWithFormat:@"\\/Date(%@)\\/",timeSp];
        NSString *timet2= [NSString stringWithFormat:@"\\/Date(%@)\\/",timeSp];
        NSString *te=@"20";
          [self postJSON:self.sex.text:self.sheng.text:self.city.text:self.qu.text:self.detail.text:timet1:self.email.text:self.xueli.text:self.xuexiao.text:self.zhuanye.text:timet2:self.jineng.text:self.zc.text];
        [MBProgressHUD showSuccess:@"修改成功"];
        [[self navigationController] popViewControllerAnimated:YES];
        
    }else{
        NSString *timeSp=@"1331121231000";
        NSString *timet1= [NSString stringWithFormat:@"\\/Date(%@)\\/",timeSp];
        NSString *timet2= [NSString stringWithFormat:@"\\/Date(%@)\\/",timeSp];
        NSString *te=@"30";
            [self postJSON:self.sex.text:self.sheng.text:self.city.text:self.qu.text:self.detail.text:timet1:self.email.text:self.xueli.text:self.xuexiao.text:self.zhuanye.text:timet2:self.jineng.text:self.zc.text];
        [MBProgressHUD showSuccess:@"修改成功"];
        [[self navigationController] popViewControllerAnimated:YES];
        
    }
    
}


@end
