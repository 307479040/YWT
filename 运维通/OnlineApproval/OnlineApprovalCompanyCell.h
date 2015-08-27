//
//  OnlineApprovalCompanyCell.h
//  YWTIOS
//
//  Created by ritacc on 15/8/15.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnlineApprovalCompanyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblApplyNo;
@property (weak, nonatomic) IBOutlet UILabel *lblUser;

@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblStatusName;
@property (weak, nonatomic) IBOutlet UIImageView *UserImg;
@end
