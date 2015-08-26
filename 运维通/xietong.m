//
//  xietong.m
//  运维通
//
//  Created by abc on 15/8/8.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "xietong.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import"hjnANNINOTION.h"


@interface xietong ()<UIAlertViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate>
@property (nonatomic, strong) NSArray *tgs;
@property(nonatomic,assign)int num;

@end

@implementation xietong
@synthesize _updateTimer2;
@synthesize _mapview;
@synthesize _locationManager;



-(void)viewDidAppear:(BOOL)animated{

    self.tabBarController.tabBar.hidden=YES;
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
    
    
    
    
    self._mapview.userTrackingMode=MKUserTrackingModeFollowWithHeading;
    self._mapview.delegate = self;
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        
        _locationManager= [[CLLocationManager alloc] init];
        
        _locationManager.delegate = self;
        
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        _locationManager.distanceFilter = 100;
        
        [_locationManager startUpdatingLocation];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            
            //     [_locationManager requestWhenInUseAuthorization];
            
            _locationManager.pausesLocationUpdatesAutomatically = NO;
    }
    [self indexchang];

    
    self._updateTimer2 = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(copynet) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self._updateTimer2 forMode:NSRunLoopCommonModes];
    
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    userLocation.title=@"当前位置";
    //userLocation.subtitle=@"";
    
    CLLocationCoordinate2D center=userLocation.location.coordinate;
    //  [self postJSON:lati:longti];
    
    
}





-(NSArray *)netwok:(NSArray *)tgsa
{
    
    _tgs=tgsa;
    return _tgs;
    
    
}

-(void)ann{
    if (_tgs.count==nil) {
        return;
    }else{
        int index=_tgs.count;
        for (int i=0; i<index; i++) {
            hjnANNINOTION *annon=[[hjnANNINOTION alloc]init];
            float x=[[_tgs objectAtIndex:i][@"latitude"] floatValue];
            CLLocationDegrees latitude=x;
            
            float y=[[_tgs objectAtIndex:i][@"longitude"] floatValue];
            CLLocationDegrees longtitude=y;
            [self lati:x];
            [self longtia:y];
            if (lati==x &longtia==y) {
                return;
            }else{
                
                [_mapview removeAnnotations:self._mapview.annotations];
                annon.coordinate= CLLocationCoordinate2DMake(latitude, longtitude);
                NSString *zt=[NSString stringWithFormat:@"运维单号:%@",[_tgs objectAtIndex:i][@"OrderNo"]];
                NSString *name=[NSString stringWithFormat:@"%@ %@",[_tgs objectAtIndex:i][@"RealName"],[_tgs objectAtIndex:i][@"Mobile"]];
                annon.title=name;
                annon.subtitle=zt;
                annon.icon=@"people.png";
                [self._mapview addAnnotation:annon];
            }
            
        }
    }
    
}


-(void)annew{
    [_mapview removeAnnotations:self._mapview.annotations];
    if (_tgs.count==nil) {
        return;
    }else{
        int index=_tgs.count;
        for (int i=0; i<index; i++) {
            hjnANNINOTION *annon=[[hjnANNINOTION alloc]init];
            float x=[[_tgs objectAtIndex:i][@"latitude"] floatValue];
            CLLocationDegrees latitude=x;
            float y=[[_tgs objectAtIndex:i][@"longitude"] floatValue];
            CLLocationDegrees longtitude=y;
            annon.coordinate= CLLocationCoordinate2DMake(latitude, longtitude);
            NSString *zt=[NSString stringWithFormat:@"运维单号：%@",[_tgs objectAtIndex:i][@"CarStatus_Name"],[_tgs objectAtIndex:i][@"OrderNo"]];
            NSString *name=[NSString stringWithFormat:@"%@  %@",[_tgs objectAtIndex:i][@"RealName"],[_tgs objectAtIndex:i][@"Mobile"]];
            annon.title=name;
            annon.subtitle=zt;
            annon.icon=@"people.png";
            [self._mapview addAnnotation:annon];
        }
    }
    
}


-(float)lati:(float)la{
    lati=la;
    return lati;
}
-(float)longtia:(float)la{
    longtia=la;
    return longtia;
}

- (void)indexchang {
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/HL.ashx?action=getsubxy&q0=%@",urlt,myString];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.0f];
    [request setHTTPMethod:@"POST"];
    NSString *str = @"type=focus-c";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"%@",connectionError);
        if (data == nil) {
            
            return ;
            
        }else{
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSArray *dictarr2=[[dict objectForKey:@"ResultObject"] copy];
            [self netwok:dictarr2];
            [self annew];
            
        }
        
    }];
    
    
    
}
-(void)copynet{
    
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/HL.ashx?action=getsubxy&q0=%@",urlt,myString];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.0f];
    [request setHTTPMethod:@"POST"];
    NSString *str = @"type=focus-c";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data != nil) {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSArray *dictarr2=[[dict objectForKey:@"ResultObject"] copy];
            [self netwok:dictarr2];
            [self ann];
        }else{
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                
                return ;
                
            }];
            
        }
    }];
    
    
    
    
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (![annotation isKindOfClass:[hjnANNINOTION class]]) return nil;
    
    static NSString *ID = @"tuangou";
    
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
        
        annoView.canShowCallout = YES;
        
        annoView.calloutOffset = CGPointMake(0, -10);
        
        // annoView.rightCalloutAccessoryView =[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        
        annoView.leftCalloutAccessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"people"]];
    }
    
    annoView.annotation = annotation;
    
    hjnANNINOTION *tuangouAnno = annotation;
    annoView.image = [UIImage imageNamed:tuangouAnno.icon];
    
    return annoView;
}









@end
