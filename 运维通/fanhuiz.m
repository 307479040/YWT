//
//  fanhuiz.m
//  送哪儿
//
//  Created by 南江 on 15/6/17.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import "fanhuiz.h"

@interface fanhuiz ()

@end

@implementation fanhuiz

- (void)viewDidLoad {
    [super viewDidLoad];
   [self performSegueWithIdentifier:@"fanhui2" sender:nil];
    self.tabBarController.tabBar.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
