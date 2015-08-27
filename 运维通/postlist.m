//
//  postlist.m
//  运维通
//
//  Created by ritacc on 15/7/26.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "postlist.h"
#import "postcell.h"
#import "MBProgressHUD+MJ.h"
#import "plistdetail.h"

@interface postlist ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *tgs;


@end

@implementation postlist

-(void)viewDidAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden=YES;
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
    static NSString *ID = @"post";
    postcell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"postcell" owner:nil options:nil] lastObject];
    }
    cell.dh.text=[NSString stringWithFormat:@"%@",dict2[@"OrderNo"]];
    cell.zt.text=[NSString stringWithFormat:@"%@",dict2[@"Status_Name"]];
    cell.bt.text=[NSString stringWithFormat:@"%@",dict2[@"OrderTitle"]];
    cell.fy.text=[NSString stringWithFormat:@"%@",dict2[@"Freight"]];
    cell.rs.text=[NSString stringWithFormat:@"%@",dict2[@"PersonNum"]];
    cell.dz.text=[NSString stringWithFormat:@"%@",dict2[@"Task_Address"]];
    cell.sq.text=[NSString stringWithFormat:@"%@人申请",dict2[@"ApplyNum"]];
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
    
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_OrderPlatform.ashx?action=getlistforsupplier&q0=%d&q1=%@",urlt,indes,myString];
    
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
    if ([vc isKindOfClass:[plistdetail class]]) {
        plistdetail *detai=vc;
        NSIndexPath *path=[self.tableview indexPathForSelectedRow];
        NSDictionary *rowdata=[self.tgs objectAtIndex:path.row];
        
        NSString *orderq=rowdata[@"Order_ID"];
        [detai setValue:orderq forKey:@"strTtile"];
        
    }
    
}

@end
