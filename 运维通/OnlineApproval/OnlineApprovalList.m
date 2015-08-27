//
//  OnlineApprovalList.m
//  YWTIOS
//
//  Created by ritacc on 15/8/14.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "OnlineApprovalList.h"
#import "OnlineApprovalUserCell.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "UIViewController+Extension.h"
#import "OnlineApprovalAdd.h"
#import "OnlineApprovalView.h"



@interface OnlineApprovalList ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *tgs;
@end

@implementation OnlineApprovalList


-(void)viewDidAppear:(BOOL)animated{
    [self network2];
    [self.tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self network2];
    [self.tableview reloadData];
    self.tableview.rowHeight=120;
    NSLog(@"加载数据。。。。");
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tgs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict2=[_tgs objectAtIndex:indexPath.row];
    static NSString *ID = @"CellTableViewCell";
    OnlineApprovalUserCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"OnlineApprovalUserCell" owner:nil options:nil] lastObject];
    }
    //NSLog(@"%@",dict2[@"Prodeuct_Model"]);    
    cell.lblApplyNo.text=[NSString stringWithFormat:@"编号：%@",dict2[@"ApplyNo"]];
    cell.lblTime.text= [self DateFormartMDHM:dict2[@"ApplyDate"]];
    cell.lblType.text= [NSString stringWithFormat:@"%@",dict2[@"ApplyType"]];
    cell.lblContent.text= [NSString stringWithFormat:@"%@",dict2[@"ApplyContent"]];
    
     cell.lblContent.numberOfLines = 0;
    cell.lblContent.lineBreakMode = NSLineBreakByWordWrapping;
    
    cell.lblStatusName.text= [NSString stringWithFormat:@"%@",dict2[@"ApprovalStatusName"]];
    
    return cell;
}

-(void)network2{
    int indes=0;
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *Create_User = [userDefaultes stringForKey:@"myidt"];
    
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_OnlineApproval.ashx?action=getlist&q0=%@&q1=%d",urlt,Create_User,indes];
    NSLog(@"%@",urlStr2);
    AFHTTPRequestOperation *op=[self GETurlString:urlStr2];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict2=responseObject;
        NSMutableArray *dictarr=dict2[@"ResultObject"];
        
        NSLog(@"%@",dictarr);
        
        [self netwok:dictarr];
        [self.tableview reloadData];
        NSLog(@"加载数据完成。");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD showError:@"网络异常！"];
        return ;
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}

-(NSMutableArray *)netwok:(NSMutableArray *)array
{
    _tgs=array;
    return _tgs;
}

/***数据跳转****/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"view" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id vc=segue.destinationViewController;
    if ([vc isKindOfClass:[OnlineApprovalView class]]) {
        OnlineApprovalView *detai=vc;
        NSIndexPath *path=[self.tableView indexPathForSelectedRow];
        NSDictionary *rowdata=[self.tgs objectAtIndex:path.row];
        
        NSString *orderq=  [NSString stringWithFormat:@"%@",rowdata[@"OnlineApproval_ID"]];
        [detai setValue:orderq forKey:@"strTtile"];
    }
}



@end