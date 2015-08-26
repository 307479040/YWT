//
//  drViewController.m
//  送哪儿
//
//  Created by apple on 15/5/3.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import "drViewController.h"
#import "orderdetail.h"
#import "MBProgressHUD+MJ.h"

@interface drViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSArray *tgs;
@property (nonatomic,strong)NSString *idtt;
@property (nonatomic,strong)NSString *idtt2;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation drViewController
@synthesize strTtile;
@synthesize _locationManager;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self._locationManager = [[CLLocationManager alloc] init];
    self._locationManager.delegate = self;
    self._locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self._locationManager.distanceFilter = 1000.0f;
    
    [self network];
_idtt2=[NSString stringWithFormat:@"%@",strTtile];
    NSLog(@"---%@",_idtt2);
    [self idt2:_idtt2];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // 获取经纬度
    //  NSLog(@"纬度:%f",newLocation.coordinate.latitude);
    //  NSLog(@"经度:%f",newLocation.coordinate.longitude);
    
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)network{

        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *myString = [userDefaultes stringForKey:@"myidt"];
        NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_User.ashx?action=getsupuser&q0=%@",urlt,myString];
        NSURL *url = [NSURL URLWithString:urlStr];
        
        NSLog(@"%@",url);
        //第二步，创建请求
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.0f];

        //第三步，连接服务器
        
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (received!=nil) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:nil];
         NSArray *dictarr=[dict objectForKey:@"ResultObject"];
         _tgs=dictarr;
    } else{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [MBProgressHUD showError:@"网络请求出错"];
        return ;
        }];
    }



        return _tgs;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return _tgs.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSDictionary *dict2=[_tgs objectAtIndex:indexPath.row];
    static NSString *ID = @"tg";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.imageView.image=[UIImage imageNamed:@"sjtx"];
    cell.textLabel.text=dict2[@"RealName"];
    cell.detailTextLabel.text=dict2[@"Mobile"];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    NSDictionary *dicr=[_tgs objectAtIndex:indexPath.row];
    NSString *idr=dicr[@"ID"];
    
    [self idt:idr];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"消息提示" message:@"是否提交选中人员？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
    // optional - add more buttons:
    [alert addButtonWithTitle:@"确定"];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
        return;
        
    }else if(buttonIndex == 1){
        NSString *lati=[NSString stringWithFormat:@"%f",self._locationManager.location.coordinate.latitude];
        NSString *longtitu=[NSString stringWithFormat:@"%f",self._locationManager.location.coordinate.longitude];
        
        [self postJSON];
        
        
        
    }}
-(NSString *)idt:(NSString *)id1{
    _idtt=id1;
    return _idtt ;
}
-(NSString *)idt2:(NSString *)id2{
    _idtt2=id2;
    return _idtt2 ;
}
- (void)postJSON{
    [super viewDidLoad];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
    //NSLog(@"%@",myString);

        NSString *urlstr=[NSString stringWithFormat:@"%@/API/YWT_Order.ashx",urlt];
        
        NSURL *urlsd=[NSURL URLWithString:urlstr];
        // 2. Request
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlsd cachePolicy:0 timeoutInterval:2.0f];
        
        request.HTTPMethod = @"POST";
        
        //  NSString *did=@"019735FD-3157-42D4-BF18-4724AC16B8A9";
        //NSDictionary *dict = @{@"x":text1,@"y":text2};
        //NSArray *array= @[dict];
        //NSLog(@"%@",array);
       NSString *dstr=[NSString stringWithFormat:@"[{\"UserID\":\"%@\"}]",_idtt];
        // ? 数据体
        NSString *str = [NSString stringWithFormat:@"action=designateuser&q0=%@&q1=%@&q2=%@",dstr,_idtt2,myString];
        NSLog(@"%@?%@",urlstr,str);
        // 将字符串转换成数据
        //NSLog(@"%@",str);
        request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
        // 把字典转换成二进制数据流, 序列化
        
        // 3. Connection
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if(data!=nil)
            {
                
                NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    NSString *errstr2=[NSString stringWithFormat:@"%@",dict[@"Status"]];
                    
                    if ([errstr2 isEqualToString:@"0"]){
                        NSString *str=[NSString stringWithFormat:@"%@",dict[@"ReturnMsg"]];
                        
                        [MBProgressHUD showError:str];
                        
                        
                        
                        return ;
                        
                        
                    }else{
                        if([self.receiveCbscs isEqualToString:@"CBSCS"]){
                            [MBProgressHUD showSuccess:@"选择司机成功！"];
                            
                        }else{
                            [MBProgressHUD showSuccess:@"选择司机成功！"];
                            
                        }
                        [[self navigationController] popViewControllerAnimated:YES];
                        
                    }
                    
                }];
            }else{
                [MBProgressHUD showError:@"网络请求出错"];
                return ;
            }


        }];

}

@end
