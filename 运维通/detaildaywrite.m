//
//  detaildaywrite.m
//  运维通
//
//  Created by abc on 15/8/5.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "detaildaywrite.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD+MJ.h"
#import "pinglunCell.h"

@interface detaildaywrite ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    int pagnum;
}
@property (weak, nonatomic) IBOutlet UILabel *bt;
@property (weak, nonatomic) IBOutlet UITextView *nr;
@property (weak, nonatomic) IBOutlet UILabel *pl;
@property (nonatomic, strong) NSMutableArray *tgs;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@end

@implementation detaildaywrite
@synthesize strTtile;


-(void)viewDidAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden=YES;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self network];
    self.scrollview.contentSize=CGSizeMake(320,1000);
}

-(void)network{
    
    
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
    
    NSString *mystring2=[NSString stringWithFormat:@"%@",strTtile];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_YWLog.ashx?action=getitem&q0=%@&q1=%@",urlt,myString,mystring2];
    
    NSString *str = @"type=focus-c";
    
    NSLog(@"%@",urlStr);
    AFHTTPRequestOperation *op=[self POSTurlString:urlStr parameters:str];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict=responseObject;
        
        NSDictionary *dict1=dict[@"ResultObject"];
        NSMutableArray *pliun=[dict1 objectForKey:@"Replys"];
        pagnum=pliun.count;
        [self netwok:pliun];
        [self.tableview reloadData];
        
        
        self.bt.text=dict1[@"Title"];
        self.nr.text=dict1[@"Content"];
        self.pl.text=[NSString stringWithFormat:@"已有%@评论",dict1[@"ReplyNumber"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        [MBProgressHUD showError:@"网络请求出错"];
        
        return ;
        
    }];
    
    
    
    [[NSOperationQueue mainQueue] addOperation:op];
    
    
    
}

-(NSMutableArray *)netwok:(NSMutableArray *)array
{
    
    _tgs=array;
    return _tgs;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    NSLog(@"===========%d",pagnum);
    return pagnum;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict2=[_tgs objectAtIndex:indexPath.row];
    static NSString *ID = @"tg";
    pinglunCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"pinglunCell" owner:nil options:nil] lastObject];
    }
    cell.user.text=dict2[@"RealName"];
    cell.pl.text=dict2[@"ReplyContent"];
    cell.lc.text=[NSString stringWithFormat:@"%@",dict2[@"ReplyID"]];
    
    NSString *dt3=dict2[@"Create_Date"];
    dt3=[dt3 stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
    dt3=[dt3 stringByReplacingOccurrencesOfString:@")/" withString:@""];
    // NSLog(@"%@",dt3);
    NSString * timeStampString3 =dt3;
    NSTimeInterval _interval3=[timeStampString3 doubleValue] / 1000;
    NSDate *date3 = [NSDate dateWithTimeIntervalSince1970:_interval3];
    NSDateFormatter *objDateformat3 = [[NSDateFormatter alloc] init];
    [objDateformat3 setDateFormat:@"yyyy-MM-dd hh:ss"];
    cell.time.text=[objDateformat3 stringFromDate: date3];
    
    if (![dict2[@"UserImg"] isEqual:[NSNull null]]) {
        NSString *img=[NSString stringWithFormat:@"%@%@",urlt,dict2[@"UserImg"]];
        NSURL *imgurl=[NSURL URLWithString:img];
        cell.img.image=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl]];
    }
    
    NSLog(@"%@",dict2);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}
@end
