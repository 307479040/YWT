//
//  ritaccAppDelegate.h
//  运维通
//
//  Created by nan on 15-7-12.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ritaccAppDelegate : UIResponder <UIApplicationDelegate,UIApplicationDelegate,CLLocationManagerDelegate>
{
    CLLocationDistance storedLatitudeDelta;
    CLLocationDistance storedLongitudeDelta;
    UIBackgroundTaskIdentifier backgroundTask;
    NSTimeInterval backgroundUpdateInterval;

}

@property (nonatomic, strong) CLLocationManager *_locationManager;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,copy) NSString *wurl;
@property (nonatomic, strong) NSTimer *_updateTimer;
@property (nonatomic, strong) NSTimer *_updateTimer2;


@end
