//
//  xietongcenter.m
//  运维通
//
//  Created by abc on 15/8/8.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "xietongcenter.h"

@interface xietongcenter ()

@end

@implementation xietongcenter

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat R  = (CGFloat) 0/255.0;
    CGFloat G = (CGFloat) 146/255.0;
    CGFloat B = (CGFloat) 234/255.0;
    CGFloat alpha = (CGFloat) 1.0;
    
    UIColor *myColorRGB = [ UIColor colorWithRed: R
                                           green: G
                                            blue: B
                                           alpha: alpha
                           ];
    
    
    
    self.navigationController.navigationBar.barTintColor=myColorRGB;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

}

-(void)viewDidAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden=NO;
}



@end
