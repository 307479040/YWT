//
//  hjnANNINOTION.h
//  mapkit 地图的基本使用
//
//  Created by nan on 15-4-12.
//  Copyright (c) 2015年 hjn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface hjnANNINOTION : NSObject <MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *icon;

@end
