//
//  robarorderlist.m
//  运维通
//
//  Created by ritacc on 15/7/25.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "robarorderlist.h"
#import "listCell.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "plistcell.h"
#import "plist.h"

@interface robarorderlist ()<UITableViewDataSource,UITableViewDelegate>
{
    int parameterNumber;
    UIButton *_selectBut;
    UILabel *_scrollLabel;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *tgs;
@property (nonatomic, strong) NSString *igt;
- (IBAction)didClickAllAction:(id)sender;

- (IBAction)didClickInProgressAction:(id)sender;
- (IBAction)didClickCompletedAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *allBut;


@end

@implementation robarorderlist
- (void)viewDidLoad {
    [super viewDidLoad];
    [self netWorkRequest:0];
    self.tableview.rowHeight=155;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _scrollLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 117, self.view.frame.size.width/2.0, 2)];
    _scrollLabel.backgroundColor=ZJColor(18, 138, 255) ;
    [self.view addSubview:_scrollLabel];
    
    indexa=0;

}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return _tgs.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict2=[_tgs objectAtIndex:indexPath.row];
    static NSString *ID = @"plistcell";
    plistcell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"plistcell" owner:nil options:nil] lastObject];
    }

    cell.dh.text=dict2[@"OrderNo"];
    NSString *zt=[NSString stringWithFormat:@"%@",dict2[@"Status_Name"]];
   
        cell.zt.text=zt;

    cell.bt.text=dict2[@"OrderTitle"];
    cell.dz.text=dict2[@"Task_Address"];
    NSString *dt3=dict2[@"CreateDateTime"];
    dt3=[dt3 stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
    dt3=[dt3 stringByReplacingOccurrencesOfString:@")/" withString:@""];
    // NSLog(@"%@",dt3);
    NSString * timeStampString3 =dt3;
    NSTimeInterval _interval3=[timeStampString3 doubleValue] / 1000;
    NSDate *date3 = [NSDate dateWithTimeIntervalSince1970:_interval3];
    NSDateFormatter *objDateformat3 = [[NSDateFormatter alloc] init];
    [objDateformat3 setDateFormat:@"MM-dd"];
    cell.sj.text=[objDateformat3 stringFromDate: date3];
    NSString *xin=[NSString stringWithFormat:@"%@",dict2[@"Stars"]];
    if ([xin isEqualToString:@"5"]) {
        
    }
    if ([xin isEqualToString:@"4"]) {
        cell.x5.hidden=YES;
    }
    if ([xin isEqualToString:@"3"]) {
        cell.x5.hidden=YES;
         cell.x4.hidden=YES;
    }
    if ([xin isEqualToString:@"2"]) {
        cell.x5.hidden=YES;
        cell.x4.hidden=YES;
         cell.x3.hidden=YES;
    }
    if ([xin isEqualToString:@"1"]) {
        cell.x5.hidden=YES;
        cell.x4.hidden=YES;
        cell.x3.hidden=YES;
         cell.x2.hidden=YES;
    }
    if ([xin isEqualToString:@"0"]) {
        cell.x5.hidden=YES;
        cell.x4.hidden=YES;
        cell.x3.hidden=YES;
        cell.x2.hidden=YES;
         cell.x1.hidden=YES;
    }
    if ([_igt isEqualToString:@"0"]) {
        cell.sq.hidden=NO;
    }else{
      cell.sq.hidden=YES;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"zd" sender:nil];
    
}




-(void)netWorkRequest:(int)parameter
{
    NSInteger indes=0;
         _igt=@"0";
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *myString = [userDefaultes stringForKey:@"myidt"];
        NSString *urlStr = [NSString stringWithFormat:@"%@/api/YWT_OrderPlatform.ashx?action=ywusergetlist&q0=%d&q1=%@",urlt,indes,myString];
    NSLog(@"%@",urlStr);
        NSString *str = @"type=focus-c";
        AFHTTPRequestOperation *op=  [self POSTurlString:urlStr parameters:str];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableDictionary *dict=responseObject;
            NSMutableArray *dictarr=[dict objectForKey:@"ResultObject"] ;
            
            _tgs=dictarr;
            [self.tableview reloadData];
            [self.tableview.header endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [MBProgressHUD showError:@"网络异常！"];
            
            return ;
        }];
        
        [[NSOperationQueue mainQueue] addOperation:op];
        
    
}

-(void)netWorkRequest2:(int)parameter
{
    NSInteger indes=0;
    _igt=@"1";
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/YWT_OrderPlatform.ashx?action=applyrecord&q0=%d&q1=%@",urlt,indes,myString];
    NSLog(@"%@",urlStr);
    NSString *str = @"type=focus-c";
    AFHTTPRequestOperation *op=  [self POSTurlString:urlStr parameters:str];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *dict=responseObject;
        NSMutableArray *dictarr=[dict objectForKey:@"ResultObject"] ;
        
        _tgs=dictarr;
        [self.tableview reloadData];
        [self.tableview.header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD showError:@"网络异常！"];
        
        return ;
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
    
    
}




- (IBAction)didClickAllAction:(UIButton *)sender {
    
    [self publicMethod:sender];
    parameterNumber=0;
    [UIView animateWithDuration:0.5 animations:^{
     
        _scrollLabel.frame=CGRectMake(0, 117, self.view.frame.size.width/2.0, 2);
        
    }];
    [self netWorkRequest:parameterNumber];
    
}

- (IBAction)didClickInProgressAction:(UIButton *)sender {
    [self publicMethod:sender];
    
    parameterNumber=0;
 
    [UIView animateWithDuration:0.5 animations:^{
        
        _scrollLabel.frame=CGRectMake(self.view.frame.size.width/2.0, 117,self.view.frame.size.width/2.0, 2);
        
    }];
    
    [self netWorkRequest2:parameterNumber];
    
}

- (IBAction)didClickCompletedAction:(UIButton *)sender {
    [self publicMethod:sender];
    parameterNumber=2;
    [UIView animateWithDuration:0.5 animations:^{
        
        _scrollLabel.frame=CGRectMake(2*self.view.frame.size.width/2.0, 117, self.view.frame.size.width/3.0, 2);
        
    }];
    [self netWorkRequest:parameterNumber];
}
-(void)publicMethod:(id)sender{
    [_selectBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:ZJColor(18, 138, 255) forState:UIControlStateNormal];
    
    _selectBut=sender;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id vc=segue.destinationViewController;
    if ([vc isKindOfClass:[plist class]]) {
        plist *detai=vc;
        NSIndexPath *path=[self.tableview indexPathForSelectedRow];
        NSDictionary *rowdata=[self.tgs objectAtIndex:path.row];
        
        NSString *orderq=rowdata[@"Order_ID"];
        [detai setValue:orderq forKey:@"strTtile"];
        
    }
    
}



@end
