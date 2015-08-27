//
//  personview.m
//  送哪儿
//
//  Created by 南江 on 15/5/12.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import "personview.h"
#import "editview.h"
#import "ChineseString.h"


@interface personview ()<UIWebViewDelegate>
@property (nonatomic,strong)NSMutableArray *tgs;
@property (nonatomic,strong)NSMutableArray *tgsname;
@property (nonatomic,strong)NSDictionary *siji;
@property (nonatomic,strong)NSDictionary *diaodu;
@property (nonatomic,copy)NSString *idtt;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UILabel *tis;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *jiahao;

@end

@implementation personview
@synthesize indexArray;
@synthesize LetterResultArr;


-(void)viewDidAppear:(BOOL)animated{
    [self viewDidLoad];
    [self.tableview reloadData];
    self.tabBarController.tabBar.hidden=YES;
}

- (void)viewDidLoad {
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
    
    self.tableview.rowHeight=50;


  [self totalnarray];
    NSMutableArray *array=[NSMutableArray array];
    for (NSDictionary *str in _tgs) {
        if (![str[@"RealName"] isEqual:[NSNull null]]) {
           NSMutableArray *name=str[@"RealName"];
        [array addObject:name];  
        }
    }
    [self namec:array];
    NSArray *stringsToSort=_tgsname;
   
   self.indexArray = [ChineseString IndexArray:stringsToSort];
   self.LetterResultArr = [ChineseString LetterSortArray:stringsToSort];

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = [indexArray objectAtIndex:section];
    return key;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    CGFloat R  = (CGFloat) 245/255.0;
    CGFloat G = (CGFloat) 245/255.0;
    CGFloat B = (CGFloat) 245/255.0;
    CGFloat alpha = (CGFloat) 1.0;
    
    UIColor *myColorRGB = [ UIColor colorWithRed: R
                                           green: G
                                            blue: B
                                           alpha: alpha
                           ];
    lab.backgroundColor =myColorRGB;
    lab.text = [indexArray objectAtIndex:section];
    lab.textColor = [UIColor grayColor];
    
    return lab;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0;
}


-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return indexArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
   // NSLog(@"title===%@",title);
    return index;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [indexArray count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.LetterResultArr objectAtIndex:section] count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    NSDictionary *dict2=[_tgs objectAtIndex:indexPath.row];
  NSLog(@"%@",dict2);
    static NSString *ID = @"tg";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    //  NSString *pan=[NSString stringWithFormat:@"%@",dict2[@"UserImg"]];
    // if ([pan isEqualToString:@""]) {
    
    //}else{
    
    //    NSString *img=[NSString stringWithFormat:@"%@%@",urlt,dict2[@"UserImg"]];
    // NSURL *imgurl=[NSURL URLWithString:img];
    //  cell.imageView.image=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl]];
    
    
    // }
    cell.imageView.image=[UIImage imageNamed:@"sjtx"];
 
    cell.textLabel.text = [[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    int index=_tgs.count;
    NSString *namec=[[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    for (int i=0; i<index; i++) {
        
        NSString *name=[_tgs objectAtIndex:i][@"RealName"];
        if ([name isEqualToString:namec]) {
            NSString *type=[NSString stringWithFormat:@"%@",[_tgs objectAtIndex:i][@"UserType"]];
            if ([type isEqualToString:@"20"]) {
                  cell.detailTextLabel.text=@"运维人员";
            }else if ([type isEqualToString:@"30"]){
             cell.detailTextLabel.text=@"调度人员";
            }else{
            cell.detailTextLabel.text=@"老板";
            }
            cell.detailTextLabel.backgroundColor=[UIColor grayColor];
            cell.detailTextLabel.textColor=[UIColor whiteColor];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:12.0];
        
            NSString *img=[NSString stringWithFormat:@"%@",[_tgs objectAtIndex:i][@"UserImg"]];
            
            NSString *img2=[NSString stringWithFormat:@"%@%@",urlt,[_tgs objectAtIndex:i][@"UserImg"]];
            if (![img isEqualToString:@"/Images/defaultPhoto.png"]) {
                NSURL *imgurl=[NSURL URLWithString:img2];
                UIImage *icon = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl]];                CGSize itemSize = CGSizeMake(40, 40);
                UIGraphicsBeginImageContextWithOptions(itemSize, NO,0.0);
                CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                [icon drawInRect:imageRect];
                
                cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                
            }else{
                UIImage *icon = [UIImage imageNamed:@"icon_tx"];
                CGSize itemSize = CGSizeMake(40, 40);
                UIGraphicsBeginImageContextWithOptions(itemSize, NO,0.0);
                CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                [icon drawInRect:imageRect];
                
                cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
            }
        
        }
        
    }
    
    
    
    return cell;
}



#pragma mark - Select内容为数组相应索引的值
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //  NSLog(@"---->%@,%d",[[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row],indexPath.row);
    
    [self performSegueWithIdentifier:@"edit" sender:nil];
    
    int index=_tgs.count;
    NSString *namec=[[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    for (int i=0; i<index; i++) {

        NSString *name=[_tgs objectAtIndex:i][@"RealName"];
        if ([name isEqualToString:namec]) {
             NSString *idt=[_tgs objectAtIndex:i][@"ID"];
           
            [self idt:idt];
        }

    }

}


-(NSMutableArray *)network:(NSMutableArray *)dict
{

        _tgs=dict;
        return _tgs;
    
}

-(NSMutableArray *)namec:(NSMutableArray *)dict
{
    
    _tgsname=dict;
   
    return _tgsname;
    
}




- (void)totalnarray{
 
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *myString = [userDefaultes stringForKey:@"myidt"];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_User.ashx?action=getsupuser&q0=%@",urlt,myString];
        
        NSURL *url = [NSURL URLWithString:urlStr];
        NSLog(@"%@",url);
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.0f];
        WebView = [[UIWebView alloc] init];
        [WebView setUserInteractionEnabled:NO];
        [WebView setBackgroundColor:[UIColor clearColor]];
        [WebView setDelegate:self];
        [WebView setOpaque:NO];
          [WebView loadRequest:request];
        [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
        NSString *str = @"type=focus-c";//设置参数
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];

        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (received==nil) {
            return;
        }else{
          NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:nil];
        NSArray *dictarr2=[dict objectForKey:@"ResultObject"];
        NSMutableArray *dictotal=[NSMutableArray array];
        [dictotal addObjectsFromArray:dictarr2];
     
        [self network:dictotal];
        }
        
    
    
    }




#pragma mark - 加载

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



-(NSString *)idt:(NSString *)id1{
    _idtt=id1;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_idtt forKey:@"personid"];
    [userDefaults synchronize];
    return _idtt ;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id vc=segue.destinationViewController;
    if ([vc isKindOfClass:[editview class]]) {
        editview *detai=vc;
       
        [detai setValue:_idtt forKey:@"strTtile"];
    }
}

@end
