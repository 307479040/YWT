//
//  orderdetail.m
//  运维通
//
//  Created by ritacc on 15/7/20.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "orderdetail.h"
#import "AFNetworkTool.h"
#import"MBProgressHUD+MJ.h"
#import<CoreLocation/CoreLocation.h>
#import"drViewController.h"
#import"beginorder.h"
#import"finishion.h"
#import "pinjia.h"

@interface orderdetail ()<CLLocationManagerDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UILabel *danhao;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *style;

@property (weak, nonatomic) IBOutlet UILabel *khjc;
@property (weak, nonatomic) IBOutlet UILabel *lxr;
@property (weak, nonatomic) IBOutlet UILabel *dz;

@property (weak, nonatomic) IBOutlet UILabel *bt;

@property (weak, nonatomic) IBOutlet UILabel *ywlx;

@property (weak, nonatomic) IBOutlet UILabel *sc;

@property (weak, nonatomic) IBOutlet UILabel *bei;
@property (weak, nonatomic) IBOutlet UILabel *lxrdh;
@property (nonatomic,strong)NSString *idtt;
@property (weak, nonatomic) IBOutlet UILabel *dri;
@property (nonatomic, strong) NSDictionary *tgs;
@property (weak, nonatomic) IBOutlet UIButton *postbtn;
@property (weak, nonatomic) IBOutlet UITextView *rw;

@property (weak, nonatomic) IBOutlet UIButton *siji;
@property (nonatomic,strong)NSString *drtel;
@property (nonatomic,strong)NSString *cotel;
@property (weak, nonatomic) IBOutlet UIButton *drtelbtn;


@end

@implementation orderdetail
@synthesize strTtile;

-(void)viewDidAppear:(BOOL)animated{
    
    self.scrollview.contentSize=CGSizeMake(320, 800);
    [self requestaaa];
    [self.view setNeedsDisplay];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
     self.tabBarController.tabBar.hidden=YES;


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
   NSLog(@"%@",  urlStr);
NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict2=responseObject;
        NSDictionary *dict=dict2[@"ResultObject"];
        [self array:dict];
        
        NSString *status=[NSString stringWithFormat:@"%@",dict[@"Status"]];
        if ([status isEqualToString:@"0"]) {
            self.postbtn.hidden=YES;
             self.siji.hidden=NO;
            
        }else if ([status isEqualToString:@"20"]) {
             self.siji.hidden=YES;
            self.postbtn.hidden=NO;
            self.drtelbtn.hidden=NO;
        }else if ([status isEqualToString:@"21"]) {
         self.drtelbtn.hidden=NO;
  self.postbtn.hidden=NO;
            self.siji.hidden=YES;
        }else if ([status isEqualToString:@"30"]) {
           self.drtelbtn.hidden=NO;
            [self.postbtn setTitle:@"完成维运" forState:UIControlStateNormal];
              self.postbtn.hidden=NO;
        }else if ([status isEqualToString:@"90"]) {
           self.drtelbtn.hidden=NO;
            [self.postbtn setTitle:@"维运评价" forState:UIControlStateNormal];
            self.postbtn.hidden=NO;
        }else if ([status isEqualToString:@"99"]) {
          self.drtelbtn.hidden=NO;
           
        }
        
        
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
        if (![dict[@"OrderUsers"] isEqual:[NSNull null]]) {
            NSArray *dict3=dict[@"OrderUsers"];
            if (dict3.count>0) {
                 NSDictionary *dic=[dict3 objectAtIndex:0];
            if (![dic[@"RealName"] isEqual:[NSNull null]]) {
                NSString *dr=[NSString stringWithFormat:@"%@  %@",dic[@"RealName"],dic[@"Mobile"]];
                self.dri.text=dr;
               _drtel=[NSString stringWithFormat:@"%@",dic[@"Mobile"]];
            }

            }
                       
        }

        
        [self idt:dict[@"Order_ID"]];
 NSString *fright=[NSString stringWithFormat:@"%@",dict[@"FlowRight"]];
        if ([fright isEqualToString:@"0"]) {
            self.postbtn.hidden=YES;
        }
        
self.style.text=dict[@"Status_Name"];
        self.khjc.text=dict[@"CustomerShort"];
        self.lxr.text=dict[@"ContactMan"];
        self.lxrdh.text=dict[@"ContactMobile"];
        
         _cotel=[NSString stringWithFormat:@"%@",dict[@"ContactMobile"]];
        
        self.dz.text=dict[@"Task_Address"];
        self.bt.text=dict[@"OrderTitle"];
        NSString *st=dict[@"OrderType"];
        if ([st isEqualToString:@"NetworkEquipment"]) {
            self.ywlx.text=@"网络设备";
        }else if([st isEqualToString:@"BusinessOperations"]){
            self.ywlx.text=@"业务运维";;
        }else if([st isEqualToString:@"OperatingSystem"]){
            self.ywlx.text=@"操作系统";;
        }else if([st isEqualToString:@"ServerEquipment"]){
            self.ywlx.text=@"服务器设备";;
        }
        self.rw.text=dict[@"OrderTask"];
        self.sc.text=[NSString stringWithFormat:@"%@",dict[@"TaskTimeLen"]];
        self.bei.text=dict[@"Remark"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD showError:@"网络异常！"];
        
        return ;
        
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
    
}

-(NSDictionary *)array:(NSDictionary *)array
{
    
    _tgs=array;
    return _tgs;
    
    
}

-(NSString *)idt:(NSString *)id1{
    _idtt=id1;
    
    return _idtt ;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [self requestaaa];
    id vc=segue.destinationViewController;
    if ([vc isKindOfClass:[drViewController class]]) {
        drViewController *detai=vc;
        NSString *mystring2=[NSString stringWithFormat:@"%@",_idtt];
        [detai setValue:mystring2 forKey:@"strTtile"];
        
    }
    if ([vc isKindOfClass:[beginorder class]]) {
        beginorder *detai=vc;
        NSString *mystring2=[NSString stringWithFormat:@"%@",_idtt];
        [detai setValue:mystring2 forKey:@"strTtile"];
        
    }
    if ([vc isKindOfClass:[finishion class]]) {
        finishion *detai=vc;
        NSString *mystring2=[NSString stringWithFormat:@"%@",_idtt];
        [detai setValue:mystring2 forKey:@"strTtile"];
        
    }
    if ([vc isKindOfClass:[pinjia class]]) {
        pinjia *detai=vc;
        NSString *mystring2=[NSString stringWithFormat:@"%@",_idtt];
        [detai setValue:mystring2 forKey:@"strTtile"];
        
    }}

- (IBAction)postbtn:(id)sender {
    NSDictionary *dict=_tgs;
    NSString *status=[NSString stringWithFormat:@"%@",dict[@"Status"]];

    if ([status isEqualToString:@"21"]) {
       [self performSegueWithIdentifier:@"begin" sender:nil];
    }
    if ([status isEqualToString:@"20"]) {
        [self performSegueWithIdentifier:@"begin" sender:nil];
    }
    if ([status isEqualToString:@"29"]) {
        [self performSegueWithIdentifier:@"begin" sender:nil];
    }
    if ([status isEqualToString:@"30"]) {
        [self performSegueWithIdentifier:@"fi" sender:nil];
    }
 if ([status isEqualToString:@"90"]) {
      [self performSegueWithIdentifier:@"pj" sender:nil];
    }
}

- (IBAction)didFirstdialAction:(id)sender {
    [self tel:_cotel];
}
- (IBAction)drtel:(id)sender {
     [self tel:_drtel];
}

-(void)tel:(NSString *)numb{
    NSString *number =numb;// 此处读入电话号码
    NSLog(@"---%@",number);
    NSString *num = [[NSString alloc]initWithFormat:@"telprompt://%@",number]; //而这个方法则打电话前先弹框 是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号

}

@end
