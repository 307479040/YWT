//
//  yworderlist.h
//  运维通
//
//  Created by abc on 15/8/2.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//
#import "EGORefreshTableHeaderView.h"
#import <UIKit/UIKit.h>

@interface yworderlist : UIViewController<EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    //  Reloading var should really be your tableviews datasource
    //  Putting it here for demo purposes
    BOOL _reloading;
    int indexa;
    UIWebView *WebView;
    UIActivityIndicatorView *activityIndicator;
    
}
-(void)genz;
- (IBAction)indexchang:(UISegmentedControl *)sender;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
-(int *)num:(int *)num2;

@end
