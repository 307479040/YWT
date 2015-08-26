//
//  beginorder.h
//  运维通
//
//  Created by ritacc on 15/7/22.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface beginorder : UIViewController<CLLocationManagerDelegate>

@property(nonatomic,weak)NSString *strTtile;
@property (nonatomic, strong) CLLocationManager *_locationManager;
@end
