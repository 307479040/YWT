//
//  personview.h
//  送哪儿
//
//  Created by 南江 on 15/5/12.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface personview : UIViewController
{
    UIWebView *WebView;
    UIActivityIndicatorView *activityIndicator;

}
@property(nonatomic,retain)NSMutableArray *indexArray;
//设置每个section下的cell内容
@property(nonatomic,retain)NSMutableArray *LetterResultArr;
@end
