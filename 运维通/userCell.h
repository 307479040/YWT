//
//  userCell.h
//  运维通
//
//  Created by abc on 15/7/27.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface userCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *lxr;
@property (weak, nonatomic) IBOutlet UILabel *xin;

@property (weak, nonatomic) IBOutlet UILabel *pf;

@property (weak, nonatomic) IBOutlet UILabel *wcds;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UIButton *btn;


@end
