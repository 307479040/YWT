//
//  dianping.m
//  运维通
//
//  Created by abc on 15/8/3.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "dianping.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"
#import "MJRefresh.h"
#import "diancell.h"
#import "diandetail.h"

@interface dianping ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *tgs;



@end

@implementation dianping

-(void)viewDidAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden=YES;
    [self network2];
    [self.tableview reloadData];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableview.rowHeight=60;
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
    static NSString *ID = @"tg";
    diancell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"diancell" owner:nil options:nil] lastObject];
    }
    cell.bt.text=dict2[@"Title"];
    if (![dict2[@"ReplyNumber"] isEqual:[NSNull null]]) {
        cell.pl.text=[NSString stringWithFormat:@"评论%@",dict2[@"ReplyNumber"]];
    }
    
    if (![dict2[@"UserImg"] isEqual:[NSNull null]]) {
        NSString *img=[NSString stringWithFormat:@"%@%@",urlt,dict2[@"UserImg"]];
        NSURL *imgurl=[NSURL URLWithString:img];
        cell.img.image=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl]];
    }
    cell.name.text=dict2[@"RealName"];
    NSString *dt3=dict2[@"Create_Date"];
    dt3=[dt3 stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
    dt3=[dt3 stringByReplacingOccurrencesOfString:@")/" withString:@""];
    // NSLog(@"%@",dt3);
    NSString * timeStampString3 =dt3;
    NSTimeInterval _interval3=[timeStampString3 doubleValue] / 1000;
    NSDate *date3 = [NSDate dateWithTimeIntervalSince1970:_interval3];
    NSDateFormatter *objDateformat3 = [[NSDateFormatter alloc] init];
    [objDateformat3 setDateFormat:@"yyyy年MM月dd日 hh:mm"];
    cell.time.text=[objDateformat3 stringFromDate: date3];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *rowdata=[self.tgs objectAtIndex:[indexPath row]];
    
    [self performSegueWithIdentifier:@"xiangxi" sender:nil];
    
    
}

-(void)network2{
    
    NSInteger indes=-1;
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/YWT_YWLog.ashx?action=getcompanylist&q0=%@&q1=%d",urlt,myString,indes];
    
    NSString *str = @"type=focus-c";
    NSLog(@"%@",urlStr);
    AFHTTPRequestOperation *op=  [self POSTurlString:urlStr parameters:str];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *dict=responseObject;
        NSMutableArray *dictarr=[dict objectForKey:@"ResultObject"] ;
        
        [self netwok:dictarr];
        [self.tableview reloadData];
        
        [self.tableview.header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD showError:@"网络异常！"];
        
        return ;
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id vc=segue.destinationViewController;
    if ([vc isKindOfClass:[diandetail class]]) {
        diandetail *detai=vc;
        NSIndexPath *path=[self.tableview indexPathForSelectedRow];
        NSDictionary *rowdata=[self.tgs objectAtIndex:path.row];

        NSString *orderq=rowdata[@"LogID"];
        [detai setValue:orderq forKey:@"strTtile"];


    }
    
}


@end
