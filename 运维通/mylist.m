//
//  mylist.m
//  运维通
//
//  Created by ritacc on 15/7/26.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "mylist.h"
#import "MBProgressHUD+MJ.h"
#import "mycell.h"
#import "applyorder.h"

@interface mylist ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *tgs;

@end

@implementation mylist



-(void)viewDidAppear:(BOOL)animated{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *usertype = [userDefaultes stringForKey:@"usertype"];
    if ([usertype isEqualToString:@"40"]) {
        self.tabBarController.tabBar.hidden=YES;
    }else{
        
        self.tabBarController.tabBar.hidden=NO;
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self network2];
    [self.tableview reloadData];
    self.tableview.rowHeight=155;
}

-(NSMutableArray *)netwok:(NSMutableArray *)array
{
    
    _tgs=array;
    return _tgs;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return _tgs.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict2=[_tgs objectAtIndex:indexPath.row];
    static NSString *ID = @"mycell";
    mycell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"mycell" owner:nil options:nil] lastObject];
    }
    cell.dh.text=[NSString stringWithFormat:@"%@",dict2[@"OrderNo"]];
    cell.zt.text=[NSString stringWithFormat:@"%@",dict2[@"Status_Name"]];
    cell.bt.text=[NSString stringWithFormat:@"%@",dict2[@"OrderTitle"]];
    cell.dz.text=[NSString stringWithFormat:@"%@",dict2[@"Task_Address"]];
    cell.sq.text=[NSString stringWithFormat:@"%@人申请",dict2[@"ApplyNum"]];
    NSString *xin=[NSString stringWithFormat:@"%@",dict2[@"Stars"]];
    if ([xin isEqualToString:@"0"]) {
     
    }else if([xin isEqualToString:@"1"]) {
        cell.x1.hidden=NO;
    }else if([xin isEqualToString:@"2"]) {
        cell.x1.hidden=NO;
         cell.x2.hidden=NO;
    }else if([xin isEqualToString:@"3"]) {
        cell.x1.hidden=NO;
        cell.x2.hidden=NO;
         cell.x3.hidden=NO;
    }else if([xin isEqualToString:@"4"]) {
        cell.x1.hidden=NO;
        cell.x2.hidden=NO;
        cell.x3.hidden=NO;
         cell.x4.hidden=NO;
    }else if([xin isEqualToString:@"5"]) {
        cell.x1.hidden=NO;
        cell.x2.hidden=NO;
        cell.x3.hidden=NO;
        cell.x4.hidden=NO;
         cell.x5.hidden=NO;
    }
    
    
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *dt3=dict2[@"CreateDateTime"];;
    dt3=[dt3 stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
    dt3=[dt3 stringByReplacingOccurrencesOfString:@")/" withString:@""];
    // NSLog(@"%@",dt3);
    NSString * timeStampString3 =dt3;
    NSTimeInterval _interval3=[timeStampString3 doubleValue] / 1000;
    NSDate *date3 = [NSDate dateWithTimeIntervalSince1970:_interval3];
    NSDateFormatter *objDateformat3 = [[NSDateFormatter alloc] init];
    [objDateformat3 setDateFormat:@"MM-dd"];
    cell.sj.text=[objDateformat3 stringFromDate: date3];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *rowdata=[self.tgs objectAtIndex:[indexPath row]];
    
     [self performSegueWithIdentifier:@"xiangxi" sender:nil];
    
    
}

-(void)network2{
    int indes=0;
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
    
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_OrderPlatform.ashx?action=getlistforall&q0=%d",urlt,indes];
    
    NSURL *url = [NSURL URLWithString:urlStr2];
    
    NSLog(@"%@",url);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.0f];
    
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str = @"type=focus-c";//设置参数
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(received!=nil){
        
        NSMutableDictionary *dict=[NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:nil];
        
        NSMutableArray *dictarr=[[dict objectForKey:@"ResultObject"] mutableCopy];
        
        
        [self netwok:dictarr];
        [self.tableview reloadData];
        
    }else
    {
        [MBProgressHUD showError:@"网络请求出错"];
        return ;
    }
    
    
    
    
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id vc=segue.destinationViewController;
    if ([vc isKindOfClass:[applyorder class]]) {
        applyorder *detai=vc;
        NSIndexPath *path=[self.tableview indexPathForSelectedRow];
        NSDictionary *rowdata=[self.tgs objectAtIndex:path.row];
        
        NSString *orderq=rowdata[@"Order_ID"];
        [detai setValue:orderq forKey:@"strTtile"];
        
    }
   
}



@end
