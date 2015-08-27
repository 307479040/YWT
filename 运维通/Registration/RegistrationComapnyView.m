//
//  RegistrationComapnyView.m
//  YWTIOS
//
//  Created by ritacc on 15/8/13.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "RegistrationComapnyView.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "UIViewController+Extension.h"
#import "SBJson.h"
#import "RegistrationComapnyCell.h"

#define urlt @"http://ritacc.net"

@interface RegistrationComapnyView ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segDay;
@property (weak, nonatomic) IBOutlet UITextField *txtUserID;
- (IBAction)btnSearchClick:(id)sender;

@property (nonatomic, strong) NSMutableArray *tgs;

@end

@implementation RegistrationComapnyView

-(void)viewDidAppear:(BOOL)animated{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    self.txtUserID.text = [userDefaultes stringForKey:@"personname"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;

    
    [self LoadDataList];
    [self.tableview reloadData];
    self.tableview.rowHeight=75;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 

/*********开始打卡数据************/
-(NSMutableArray *)netwok:(NSMutableArray *)array
{
    _tgs=array;
    return _tgs;
}

-(void)LoadDataList{
    int indes=-1;
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *Create_User = [userDefaultes stringForKey:@"myidt"];
    /*
    YWT_Registration.ashx?action=getcompanylist&q0=&q1=&q2=&q3=	查询员工打卡记录
    q0	操作人ID
    q1	指定运维人员ID
    q2	查询类型： day 当日 7day 7天内 pmonth 上月 cmonth 本月 3month
    q3	最小ID，第一次-1
     */
    NSInteger indexseg= self.segDay.selectedSegmentIndex;
    NSString *searchtype=@"day";
    if (indexseg==1) {
        searchtype=@"day";
    }
    else if(indexseg==2) {
        searchtype=@"7day";
    }
    else if(indexseg==3) {
        searchtype=@"cmonth";
    }
    else if(indexseg==4) {
        searchtype=@"pmonth";
    }
    else if(indexseg==5) {
        searchtype=@"3month";
    }
    
    NSString *searchUserID=[userDefaultes stringForKey:@"personID"];


    NSLog(@"%d",indexseg);
    NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_Registration.ashx?action=getcompanylist&q0=%@&q1=%@&q2=%@&q3=%d"
                         ,urlt,Create_User,searchUserID,searchtype,indes];
    
    NSLog(@"－－－－%@",urlStr2);
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tgs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict2=[_tgs objectAtIndex:indexPath.row];
    static NSString *ID = @"CregisCell";
    RegistrationComapnyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"RegistrationComapnyCell" owner:nil options:nil] lastObject];
    }
    cell.lblUserName.text=[NSString stringWithFormat:@"%@",dict2[@"RealName"]];
    cell.lblAddr.text=[NSString stringWithFormat:@"%@",dict2[@"Position"]];
    cell.lblTime.text=[self DateFormartMDHM:dict2[@"Create_Date"]];
    
    if ([[NSString stringWithFormat:@"%@",dict2[@"UserImg"]] isEqualToString:@"/Images/defaultPhoto.png"]) {
    }else{
        NSString *img=[NSString stringWithFormat:@"%@%@",urlt,dict2[@"UserImg"]];
        NSURL *imgurl=[NSURL URLWithString:img];
        UIImage *imgUserimg=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl]];
        [cell.UserImg setImage:imgUserimg];
        
    }
    return cell;
}
- (IBAction)btnSearchClick:(id)sender {
    [self LoadDataList];
    [self.tableview reloadData];
}
@end
