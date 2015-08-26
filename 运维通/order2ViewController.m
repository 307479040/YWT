//
//  order2ViewController.m
//  送哪儿
//
//  Created by apple on 15/5/1.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import "order2ViewController.h"
#import "hjnTG.h"
#import "orderModel.h"
#import "orderdetail.h"
//#import "ordermapViewController.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkTool.h"

//#import"CbscsController.h"

@interface order2ViewController () <UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    NSInteger rowNumber;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tgs;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,strong)NSString *idtt;
@property (nonatomic,assign)NSInteger *idtt2;
@property (nonatomic,assign)int *idtt3;
@property NSInteger *idenxx;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addbtn;


@property (weak, nonatomic) IBOutlet UIButton *fanhui;
@property (weak, nonatomic) IBOutlet UIButton *addbtn1;





@property (weak, nonatomic) IBOutlet UIView *bottomview;


@end

@implementation order2ViewController
@synthesize title;

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden=NO;
    
    self.tabBarController.tabBar.hidden=NO;
    [self indexchang:self.segmentControl];
    [self.tableView reloadData];
[AFNetworkTool netWorkStatus];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat R  = (CGFloat) 0/255.0;
    CGFloat G = (CGFloat) 146/255.0;
    CGFloat B = (CGFloat) 234/255.0;
    CGFloat alpha = (CGFloat) 1.0;
    
    UIColor *myColorRGB = [ UIColor colorWithRed: R
                                           green: G
                                            blue: B
                                           alpha: alpha
                           ];
    
    
    
    self.navigationController.navigationBar.barTintColor=myColorRGB;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *pass= [userDefaultes stringForKey:@"passkey"];
    if ([pass isEqualToString:@"pass"]) {
        self.navigationItem.hidesBackButton =YES;
        self.fanhui.hidden=YES;
        
    }else if([pass isEqualToString:@"sjpass"]){
        self.bottomview.hidden=YES;
        self.navigationItem.hidesBackButton =YES;
    }
    [self.tableView reloadData];
    self.tableView.rowHeight=155;
    [self indexchang:self.segmentControl];
    self.tableView.delegate=self;
    
    if (_refreshHeaderView == nil) {
        
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        view.delegate = self;
        [self.tableView addSubview:view];
        _refreshHeaderView = view;
        
    }

    NSString *usertype= [userDefaultes stringForKey:@"usertype"];
    if ([usertype isEqualToString:@"20"]) {
        self.addbtn1.hidden=YES;
    }else if([usertype isEqualToString:@"40"]){
     self.addbtn1.hidden=YES;
    }
    
    indexa=0;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
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
    hjnTG *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"hjnTG" owner:nil options:nil] lastObject];
    }
    cell.danhao.text=dict2[@"OrderNo"];
   cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.biaoti.text=dict2[@"OrderTitle"];
     cell.lxr.text=dict2[@"ContactMan"];
    cell.tel.text=dict2[@"ContactMobile"];
    cell.status.text=dict2[@"Status_Name"];
    
    NSString *dt3=dict2[@"CreateDateTime"];;
    dt3=[dt3 stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
    dt3=[dt3 stringByReplacingOccurrencesOfString:@")/" withString:@""];
    // NSLog(@"%@",dt3);
    NSString * timeStampString3 =dt3;
    NSTimeInterval _interval3=[timeStampString3 doubleValue] / 1000;
    NSDate *date3 = [NSDate dateWithTimeIntervalSince1970:_interval3];
    NSDateFormatter *objDateformat3 = [[NSDateFormatter alloc] init];
    [objDateformat3 setDateFormat:@"MM-dd"];
     cell.time.text=[objDateformat3 stringFromDate: date3];
    cell.addr.text=dict2[@"Task_Address"];
    
    [cell.btn addTarget:self action:@selector(genz2:) forControlEvents:UIControlEventTouchUpInside];
    cell.btn.tag =indexPath.row;
    [cell.contentView addSubview:cell.btn];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *rowdata=[self.tgs objectAtIndex:[indexPath row]];

        [self performSegueWithIdentifier:@"xiangxi" sender:nil];

    
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {

            NSDictionary *rowdata=[self.tgs objectAtIndex:indexPath.row];
            //  NSLog(@"%@",rowdata);
            NSString *orderq=rowdata[@"ID"];
            
            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
            NSString *myString = [userDefaultes stringForKey:@"myidt"];
            // NSString *tr=@"B6D13BE7-990C-4DA6-A757-088ED994D9EA";
            
            
            
            
            NSString *urlStr = [NSString stringWithFormat:@"%@/API/HDL_Order.ashx?action=getaorderall&q0=%@&q1=%@",urlt,orderq,myString];
            
            NSURL *url = [NSURL URLWithString:urlStr];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.0f];
            [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
            NSString *str = @"type=focus-c";//设置参数
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:data];
            
            
            NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if(received!=nil){
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:nil];
            
            NSDictionary *dictarr2=[dict objectForKey:@"ResultObject"];
            NSDictionary *dictarr=[dictarr2 objectForKey:@"OrderMain"];
            NSString *text1=dictarr[@"ID"];
            //  NSLog(@"%@",text1);
            NSString *text2=dictarr[@"Creator"];
            NSString *text3=@"114";
            NSString *text4=@"24";
            NSString *text5=@"车公庙";
            NSString *sta=[NSString stringWithFormat:@"%@",dictarr[@"Status"]];
            
            
            if ([sta isEqualToString:@"99"]) {
                [MBProgressHUD showError:@"已经签收不能删除！"];
                
                return;
            }else{
                [_tgs removeObjectAtIndex:indexPath.row];  //删除数组里的数据
                
                [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                [self tijiao2:text1 :text2 :text3 :text4 :text5];
                [self.tableView reloadData];
                [MBProgressHUD showSuccess:@"您删除的订单已存入回收站！"];
            }
            
        }else
        {
            [MBProgressHUD showError:@"网络请求出错"];
            return ;
        }

   

    }
}



- (void)tijiao2:(NSString *)t1:(NSString *)t2:(NSString *)t3:(NSString *)t4:(NSString *)t5{
    
        NSString *urlStr =[NSString stringWithFormat:@"%@/API/HDL_Order.ashx",urlt] ;
        
        NSURL *url = [NSURL URLWithString:urlStr];
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:2.0f];
        
        request.HTTPMethod = @"POST";
        
        
        NSString *str = [NSString stringWithFormat:@"action=saveorderflow&q0=%@&q1=100&q2=%@&q3=%@&q4=%@&q5=%@",t1,t2,t3,t4,t5];
        
        
        request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if(data!=nil)
            {
                NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

            }else{
                [MBProgressHUD showError:@"网络请求出错"];
                return ;
            }
            
        }];

    
}



-(void)genz2:(UIButton *)sender{
    [self idt3:sender.tag];
    [self performSegueWithIdentifier:@"gz" sender:nil];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
 id vc=segue.destinationViewController;
    if ([vc isKindOfClass:[orderdetail class]]) {
       orderdetail *detai=vc;
        NSIndexPath *path=[self.tableView indexPathForSelectedRow];
        NSDictionary *rowdata=[self.tgs objectAtIndex:path.row];
   
        NSString *orderq=rowdata[@"Order_ID"];
        [detai setValue:orderq forKey:@"strTtile"];
      
    }
//    if ([vc isKindOfClass:[ordermapViewController class]]) {
//        ordermapViewController *detai2=vc;
//        
//        NSDictionary *rowdata=[self.tgs objectAtIndex:_idtt3];
//        // NSLog(@"+++++%@",rowdata);
//        NSString *orderq=rowdata[@"ID"];
//        //  NSLog(@"+++%@",orderq);
//        [detai2 setValue:orderq forKey:@"strTtile"];
//    }
//    
//    if ([vc isKindOfClass:[CbscsController class]]) {
//        
//        
//        NSDictionary *rowdata=[self.tgs objectAtIndex:rowNumber];
//        NSString *orderq=rowdata[@"ID"];
//        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//        NSString *myString = [userDefaultes stringForKey:@"myidt"];
//        CbscsController *cbscsVC=vc;
//        cbscsVC.receiveOrderq=orderq;
//        cbscsVC.receiveMyString=myString;
//        NSString *aa=rowdata[@"wlsend_SysCode"];
//        cbscsVC.receiveCbscs=aa;
//    }
}

-(NSInteger *)num{
    
    
    return _idenxx;
}


-(NSString *)idt:(NSString *)id1{
    _idtt=id1;
    return _idtt ;
}


-(int *)idt3:(int *)id1{
    _idtt3=id1;
    return _idtt3;
    
}


- (IBAction)indexchang:(UISegmentedControl *)sender {

        
        NSInteger colum=sender.selectedSegmentIndex;
        NSInteger indes=colum-1;
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *myString = [userDefaultes stringForKey:@"myidt"];
        
        // NSString *tr=@"B6D13BE7-990C-4DA6-A757-088ED994D9EA";
        // NSLog(@"%@",myString);
        NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_Order.ashx?action=getlist&q0=0&q1=%@&q2=%ld",urlt,myString,(long)indes];
        NSURL *url = [NSURL URLWithString:urlStr2];

    NSLog(@"%@",url);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.0f];
        WebView = [[UIWebView alloc] init];
        [WebView setUserInteractionEnabled:NO];
        [WebView setBackgroundColor:[UIColor clearColor]];
        [WebView setDelegate:self];
        [WebView setOpaque:NO];//使网页透明
        [WebView loadRequest:request];
        [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
        NSString *str = @"type=focus-c";//设置参数
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];

        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(received!=nil){
        
        NSMutableDictionary *dict=[NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:nil];
        
        NSMutableArray *dictarr=[[dict objectForKey:@"ResultObject"] mutableCopy];
        
        
        [self netwok:dictarr];
        [self.tableView reloadData];

    }else
    {
        [MBProgressHUD showError:@"网络请求出错"];
        return ;
    }

    
 
    
}

//开始加载数据
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [view setTag:103];
    [view setBackgroundColor:[UIColor clearColor]];
    [view setAlpha:0.8];
    [self.view addSubview:view];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [activityIndicator setCenter:view.center];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [view addSubview:activityIndicator];
    [self.view addSubview:WebView];
    [activityIndicator startAnimating];
}

//数据加载完
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [activityIndicator stopAnimating];
    UIView *view = (UIView *)[self.view viewWithTag:103];
    [view removeFromSuperview];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activityIndicator stopAnimating];
    UIView *view = (UIView *)[self.view viewWithTag:103];
    [view removeFromSuperview];
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    _reloading = YES;
    
}

- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
    
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    [self ren];
    [self repeatnetwork];
    [self.tableView reloadData];
    return [NSDate date]; // should return date data source was last changed
}

-(NSMutableArray *)repeatnetwork{

        
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *myString = [userDefaultes stringForKey:@"myidt"];
        
        // NSString *tr=@"B6D13BE7-990C-4DA6-A757-088ED994D9EA";
    
        NSString *urlStr2 = [NSString stringWithFormat:@"%@/API/YWT_Order.ashx?action=getlist&q0=%d&q1=%@&q2=-1",urlt,indexa,myString];
        NSURL *url = [NSURL URLWithString:urlStr2];
        
        [AFNetworkTool JSONDataWithUrl:[NSString stringWithFormat:@"%@",url] success:^(id json) {
            NSMutableDictionary *dict=json;
            
            NSArray *dictarr=[dict objectForKey:@"ResultObject"];
            
            [_tgs addObjectsFromArray:dictarr];
            
         
         
            // 提示:NSURLConnection异步方法回调,是在子线程
            // 得到回调之后,通常更新UI,是在主线程
            //        NSLog(@"%@", [NSThread currentThread]);
        } fail:^{
            [MBProgressHUD showError:@"网络请求出错"];

            NSLog(@"请求失败");
            return ;
        }];
        return _tgs;
        [self.tableView reloadData];
        

    
    
}


-(int)ren{
    indexa=indexa+1;
    return indexa;
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    _refreshHeaderView=nil;
}

- (void)dealloc {
    
    _refreshHeaderView = nil;
    
}


@end
