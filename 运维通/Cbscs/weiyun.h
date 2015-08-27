//
//  Cbscs.h
//  送哪儿
//
//  Created by pan on 15/7/7.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cbscs : NSObject
@property(nonatomic,strong)NSString *DispatchNo;
@property(nonatomic,strong)NSString *SendType;
@property(nonatomic,strong)NSString *ReceiveID;
@property(nonatomic,strong)NSString *Customer;
@property(nonatomic,strong)NSString *SupplierName;
@property(nonatomic,strong)NSString *DCDAndDriver;
@property(nonatomic,strong)NSString *Address;
@property(nonatomic,strong)NSString *Contact;
@property(nonatomic,strong)NSString *PickDate;
@property(nonatomic,strong)NSString *Tamount;
@property(nonatomic,strong)NSString *Note;
@property(nonatomic,strong)NSString *TAddress;
@property(nonatomic,strong)NSString *DeliveryDate;
@property(nonatomic,strong)NSString *TContact;
//    [_dd addObject:cc[@"DispatchNo"]];
//    [_dd addObject:cc[@"SendType"]];
//
//    [_dd addObject:[[[NSNumberFormatter alloc]init] stringFromNumber:cc[@"ReceiveID"]]];
//    [_dd addObject:cc[@"Customer"]];
//    [_dd addObject:cc[@"SupplierName"]];
//    [_dd addObject:cc[@"DCDAndDriver"]];
//    [_dd addObject:cc[@"Address"]];
//    [_dd addObject:cc[@"Contact"]];
//    [_dd addObject:cc[@"PickDate"]];
//    [_dd addObject:[[[NSNumberFormatter alloc]init] stringFromNumber:cc[@"Tamount"]]];
//    [_dd addObject:cc[@"Note"]];
//    [_dd addObject:cc[@"TAddress"]];
//    [_dd addObject:cc[@"DeliveryDate"]];
//    [_dd addObject:cc[@"TContact"]];
@end
