//
//  icon.h
//  运维通
//
//  Created by ritacc on 15/7/17.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface icon : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

//@interface ViewController : UIViewController;

- (IBAction)selectImg_Click:(id)sender;
- (IBAction)btnupload_Click:(id)sender;

@property(nonatomic,weak)NSString *strTtile;

@end
