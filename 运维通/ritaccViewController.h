//
//  ritaccViewController.h
//  运维通
//
//  Created by nan on 15-7-12.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ritaccViewController : UIViewController<CLLocationManagerDelegate>

{
    CLLocationDistance storedLatitudeDelta;
    CLLocationDistance storedLongitudeDelta;
    UIBackgroundTaskIdentifier backgroundTask;
    NSTimeInterval backgroundUpdateInterval;
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    float lati;
    float longtia;
}
@property (nonatomic, strong) CLLocationManager *_locationManager;
@property (nonatomic, strong) NSMutableArray *_saveLocations;
@property (nonatomic, strong) NSTimer *_updateTimer;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) NSTimer *_updateTimer2;
@property (nonatomic,strong) IBOutlet MKMapView *_mapview;

@end
