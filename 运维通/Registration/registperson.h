//
//  registperson.h
//  运维通
//
//  Created by abc on 15/8/16.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface registperson : UIViewController<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *_locationManager;
@property(nonatomic,weak)NSString *strTtile;
@property(nonatomic,strong)NSString *receiveID;
@property(nonatomic,strong)NSString *receiveCbscs;

@end
