//
//  drViewController.h
//  送哪儿
//
//  Created by apple on 15/5/3.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface drViewController : UIViewController<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *_locationManager;
@property(nonatomic,weak)NSString *strTtile;
@property(nonatomic,strong)NSString *receiveID;
@property(nonatomic,strong)NSString *receiveCbscs;

@end
