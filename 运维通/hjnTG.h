//
//  hjnTG.h
//  送哪儿
//
//  Created by apple on 15/4/29.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ordermodel;

@interface hjnTG : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *danhao;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *xiadan;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *biaoti;
@property (weak, nonatomic) IBOutlet UILabel *lxr;

@property (weak, nonatomic) IBOutlet UILabel *tel;
@property (weak, nonatomic) IBOutlet UILabel *status;

@property (weak, nonatomic) IBOutlet UILabel *addr;

@end
