//
//  ordermodel.h
//  送哪儿
//
//  Created by apple on 15/4/29.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ordermodel : NSObject
@property(nonatomic,copy)NSString *PickDateTime;
@property(nonatomic,copy)NSString *OrderNo;
@property(nonatomic,copy)NSString *TO_RealName;
@property(nonatomic,copy)NSString *DriverID_Name;
@property(nonatomic,copy)NSString *cyname;
@property(nonatomic,copy)NSString *CreateDateTime;
@property(nonatomic,copy)NSString *Freight;
@property(nonatomic,copy)NSString *PaymentType;
@property(nonatomic,copy)NSString *Designate_TYPE_Name;
@property(nonatomic,copy)NSString *Driver_UserImg;
@property(nonatomic,copy)NSString *Designate_TYPE;
@property(nonatomic,copy)NSString *DeliveryDateTime;
@property(nonatomic,copy)NSString *Status_Name;



+ (instancetype)tgWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
