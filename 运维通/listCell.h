//
//  listCell.h
//  送哪儿
//
//  Created by 南江 on 15/5/21.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface listCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *liststyle;
@property (weak, nonatomic) IBOutlet UILabel *listno;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *listdate;

@end
