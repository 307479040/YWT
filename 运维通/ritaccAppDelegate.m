//
//  ritaccAppDelegate.m
//  运维通
//
//  Created by nan on 15-7-12.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "ritaccAppDelegate.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ritaccViewController.h"
#import "MBProgressHUD+MJ.h"
#import "ZCNoneiFLYTEK.h"

@implementation ritaccAppDelegate
{
    int noNetworknumber;
    int secondNetworknumber;
}
@synthesize wurl;
@synthesize _locationManager;
@synthesize _updateTimer61;
@synthesize _updateTimer62;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    if ([CLLocationManager locationServicesEnabled]) {
        
        
        _locationManager= [[CLLocationManager alloc] init];
        
        _locationManager.delegate = self;
        
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest; //控制定位精度,越高耗电量越大。
        
        _locationManager.distanceFilter = 100; //控制定位服务更新频率。单位是“米”
        
        [_locationManager startUpdatingLocation];
        
        //在ios 8.0下要授权
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            
            [_locationManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
        [_locationManager requestAlwaysAuthorization];
        
        _locationManager.pausesLocationUpdatesAutomatically = NO;
    }
    
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                         settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                         categories:nil]];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    self._updateTimer61 = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(update) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self._updateTimer61 forMode:NSRunLoopCommonModes];
    
    
    self._updateTimer62 = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(loca) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self._updateTimer62 forMode:NSRunLoopCommonModes];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    ritaccViewController *view1 = [[ritaccViewController alloc] init];
    
    if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
        [view1._locationManager stopUpdatingLocation];
        [view1._locationManager startMonitoringSignificantLocationChanges]; ;
    }
    else
    { NSLog(@"Significant location change monitoring is not available."); }
    
    [application beginBackgroundTaskWithExpirationHandler:nil];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    ritaccViewController *view1 = [[ritaccViewController alloc] init];
    
    if ([CLLocationManager significantLocationChangeMonitoringAvailable])
        
    {
        
        
        [view1._locationManager startMonitoringSignificantLocationChanges];
        
        [view1._locationManager startUpdatingLocation];
        
        
    }
    
    else
        
    {
        
        NSLog(@"Significant location change monitoring is not available.");
        
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification

{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"运维通-新消息"
                          
                                                    message:notification.alertBody
                          
                                                   delegate:nil
                          
                                          cancelButtonTitle:@"确定"
                          
                                          otherButtonTitles:nil];
    
    [alert show];
    
    //这里，你就可以通过notification的useinfo，干一些你想做的事情了
    
    application.applicationIconBadgeNumber -= 1;
    
}


-(void)loca{
    self._locationManager = [[CLLocationManager alloc] init];
    self._locationManager.delegate = self;
    self._locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self._locationManager.distanceFilter = 1000.0f;
    NSString *lati=[NSString stringWithFormat:@"%.20f",self._locationManager.location.coordinate.latitude];
    NSString *longti=[NSString stringWithFormat:@"%.20f",self._locationManager.location.coordinate.longitude];
    
    [self postJSON:lati:longti];
    
}

- (void)postJSON:(NSString *)text1 :(NSString *)text2
{
    @try
    {
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *myString = [userDefaultes stringForKey:@"myidt"];
        
        if (myString==NULL) {
            // NSLog(@"%@",myString);
            return;
        }else{
            
            NSString *strurl=[NSString stringWithFormat:@"%@/API/HL.ashx",urlt];
            NSURL *url = [NSURL URLWithString:strurl];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:2.0f];
            request.HTTPMethod = @"POST";
            
            NSString *str = [NSString stringWithFormat:@"action=sl&q0=%@&q1=%@&q2=%@",myString,text2,text1];
            //NSLog(@"--%@",str);
            request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
            
            [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                
                if (!data== nil) {
                    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"%@",result);
                }else{
                    return ;
                }
                
            }];
        }
        
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    
    
}

-(void)update{
    
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_MSG.ashx?action=get&q0=%@",urlt,myString];
    NSURL *url = [NSURL URLWithString:urlStr];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str = @"type=focus-c";//设置参数
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data==nil) {
            if(secondNetworknumber==0)
            {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [MBProgressHUD showError:@"网络请求出错"];
                    
                    
                }];
            }
            secondNetworknumber++;
            
            
        }else{
            NSArray *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary *dict2=[dict objectAtIndex:0];
            
            if (!dict2.count==NULL) {
                // NSString *df=[NSString stringWithFormat:@"%@",dict2[@"MsgType"]];
                NSString *Content=[NSString stringWithFormat:@"%@",dict2[@"Content"]];
                NSString *Title=[NSString stringWithFormat:@"%@",dict2[@"Title"]];
                
                NSString *strword=[NSString stringWithFormat:@"实时:%@，%@！",Title,Content];
                
                [self scheduleNotification:Title:Content];
                ZCNoneiFLYTEK*manager=[ZCNoneiFLYTEK shareManager];
                [manager playVoice:strword];
                NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            }else{
                
                return ;
                
                
                
            }
            
            
            
            
        }
        
    }];
    
    
    
}
// 进行推送的方法
- (void)scheduleNotification:(NSString *)title:(NSString *)content{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //设置5秒之后
    NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:5];
    if (notification != nil) {
        // 设置推送时间（5秒后）
        notification.fireDate = pushDate;
        // 设置时区（此为默认时区）
        notification.timeZone = [NSTimeZone defaultTimeZone];
        // 设置重复间隔（默认0，不重复推送）
        notification.repeatInterval =0;
        // 推送声音（系统默认）
        notification.soundName = UILocalNotificationDefaultSoundName;
        // 推送内容
        notification.alertBody = content;
        //显示在icon上的数字
        // notification.applicationIconBadgeNumber = 1;
        //设置userinfo 方便在之后需要撤销的时候使用
        NSDictionary *info = [NSDictionary dictionaryWithObject:@"name"forKey:@"key"];
        notification.userInfo = info;
        //添加推送到UIApplication
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:notification];
    }
}


@end
