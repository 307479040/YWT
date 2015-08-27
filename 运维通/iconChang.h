//
//  iconChang.h
//  送哪儿
//
//  Created by 南江 on 15/5/25.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iconChang : UIViewController


@property (weak, nonatomic) IBOutlet UIImageView *imageView;

//@interface ViewController : UIViewController;

- (IBAction)selectImg_Click:(id)sender;

- (IBAction)btnupload_Click:(id)sender;

@property(nonatomic,weak)NSString *strTtile;


@end
