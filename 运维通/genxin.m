//
//  genxin.m
//  运维通
//
//  Created by abc on 15/8/15.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "genxin.h"

@interface genxin ()
@property (weak, nonatomic) IBOutlet UILabel *ban;

@end

@implementation genxin

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    self.ban.text=appVersion;
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
