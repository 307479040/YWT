//
//  pinjia.h
//  运维通
//
//  Created by ritacc on 15/7/25.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface pinjia : UIViewController<CLLocationManagerDelegate>

@property(nonatomic,weak)NSString *strTtile;
@property (nonatomic, strong) CLLocationManager *_locationManager;

@end
