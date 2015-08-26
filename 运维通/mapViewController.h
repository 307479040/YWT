//
//  mapViewController.h
//  送哪儿
//
//  Created by apple on 15/4/28.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface mapViewController : UIViewController <CLLocationManagerDelegate>
{
    CLLocationDistance storedLatitudeDelta;
    CLLocationDistance storedLongitudeDelta;
    UIBackgroundTaskIdentifier backgroundTask;
    NSTimeInterval backgroundUpdateInterval;
    
}

@property (nonatomic, strong) CLLocationManager *_locationManager;
@property (nonatomic, strong) NSMutableArray *_saveLocations;

@end
