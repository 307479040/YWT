//
//  order2ViewController.h
//  送哪儿
//
//  Created by apple on 15/5/1.
//  Copyright (c) 2015年 Tony. All rights reserved.
//
#import "EGORefreshTableHeaderView.h"
#import <UIKit/UIKit.h>

@interface order2ViewController : UIViewController <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource>{

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
