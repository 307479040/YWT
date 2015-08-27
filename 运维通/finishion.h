//
//  finishion.h
//  运维通
//
//  Created by ritacc on 15/7/23.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface finishion : UIViewController<CLLocationManagerDelegate>

@property(nonatomic,weak)NSString *strTtile;
@property (nonatomic, strong) CLLocationManager *_locationManager;

@end
