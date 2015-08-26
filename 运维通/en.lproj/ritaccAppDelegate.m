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

@implementation ritaccAppDelegate
@synthesize wurl;
@synthesize _locationManager;
@synthesize _updateTimer;
@synthesize _updateTimer2;


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
    

    
    
    self._updateTimer2 = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(loca) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self._updateTimer2 forMode:NSRunLoopCommonModes];
  
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

-(void)loca{
    self._locationManager = [[CLLocationManager alloc] init];
    self._locationManager.delegate = self;
    self._locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self._locationManager.distanceFilter = 1000.0f;
    NSString *lati=[NSString stringWithFormat:@"%f",self._locationManager.location.coordinate.latitude];
    NSString *longti=[NSString stringWithFormat:@"%f",self._locationManager.location.coordinate.longitude];
   
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
            NSLog(@"--%@",str);
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



@end
