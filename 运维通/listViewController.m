//
//  listViewController.m
//  送哪儿
//
//  Created by 南江 on 15/5/21.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import "listViewController.h"
#import "listCell.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"


@interface listViewController () <UITableViewDataSource,UITableViewDelegate>
{
    int parameterNumber;
    UIButton *_selectBut;
    UILabel *_scrollLabel;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *tgs;
- (IBAction)didClickAllAction:(id)sender;

- (IBAction)didClickInProgressAction:(id)sender;
- (IBAction)didClickCompletedAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *allBut;

@end

@implementation listViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self didClickAllAction:self.allBut];
    
    self.tableview.rowHeight=90;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _scrollLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 117, self.view.frame.size.width/3.0, 2)];
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
    static NSString *ID = @"tg";
    listCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"listCell" owner:nil options:nil] lastObject];
    }
    cell.liststyle.text=dict2[@"ItemName"];
    cell.listno.text=dict2[@"Remark"];
    cell.money.text=[NSString stringWithFormat:@"￥%@",dict2[@"Money"]];
    NSString *dt3=dict2[@"CreateDateTime"];
    dt3=[dt3 stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
    dt3=[dt3 stringByReplacingOccurrencesOfString:@")/" withString:@""];
    NSString * timeStampString3 =dt3;
    NSTimeInterval _interval3=[timeStampString3 doubleValue] / 1000;
    NSDate *date3 = [NSDate dateWithTimeIntervalSince1970:_interval3];
    NSDateFormatter *objDateformat3 = [[NSDateFormatter alloc] init];
    [objDateformat3 setDateFormat:@"yyyy-MM-dd"];
    cell.listdate.text=[objDateformat3 stringFromDate: date3];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"zd" sender:nil];
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id vc=segue.destinationViewController;
//    if ([vc isKindOfClass:[detalcw class]]) {
//        detalcw *detai=vc;
//        NSIndexPath *path=[self.tableview indexPathForSelectedRow];
//        NSDictionary *rowdata=[self.tgs objectAtIndex:path.row];
//        NSString *orderq=rowdata[@"ID"];
//        [detai setValue:orderq forKey:@"strTtile"];
//    }
}

-(void)netWorkRequest:(int)parameter
{
    NSInteger indes=0;
    if (parameter==0) {
        indes=-1;
        NSLog(@"%d",indes);
    }else if(parameter==1){
        indes=0;
        NSLog(@"%d",indes);
    }else if (parameter==2)
    {
        indes=99;
        NSLog(@"%d",indes);
        
    }
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *myString = [userDefaultes stringForKey:@"myidt"];
        NSString *urlStr = [NSString stringWithFormat:@"%@/API/HDL_SNRUserQuota.ashx?action=getlist&q0=0&q1=%@&q2=%d",urlt,myString,indes];
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
        
    }];
    self.tableview.header.autoChangeAlpha = YES;
    
    [self.tableview.header beginRefreshing];
    
}



- (IBAction)didClickAllAction:(UIButton *)sender {
    
    [self publicMethod:sender];
    parameterNumber=0;
    [UIView animateWithDuration:0.5 animations:^{
        
        _scrollLabel.frame=CGRectMake(0, 117, self.view.frame.size.width/3.0, 2);
        
    }];
    [self netWorkRequest:parameterNumber];
    
}

- (IBAction)didClickInProgressAction:(UIButton *)sender {
    [self publicMethod:sender];
    
    parameterNumber=1;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _scrollLabel.frame=CGRectMake(self.view.frame.size.width/3.0, 117,self.view.frame.size.width/3.0, 2);
        
    }];
    
    [self netWorkRequest:parameterNumber];
    
}

- (IBAction)didClickCompletedAction:(UIButton *)sender {
    [self publicMethod:sender];
    parameterNumber=2;
    [UIView animateWithDuration:0.5 animations:^{
        
        _scrollLabel.frame=CGRectMake(2*self.view.frame.size.width/3.0, 117, self.view.frame.size.width/3.0, 2);
        
    }];
    [self netWorkRequest:parameterNumber];
}
-(void)publicMethod:(id)sender{
    [_selectBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:ZJColor(18, 138, 255) forState:UIControlStateNormal];
    
    _selectBut=sender;
}

@end
