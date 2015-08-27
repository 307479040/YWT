//
//  UIViewController+Extension.h
//  送哪儿
//
//  Created by pan on 15/7/13.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"AFNetworking.h"
@interface UIViewController (Extension)
-(AFHTTPRequestOperation *)GETurlString:(NSString *)urlString;
-(AFHTTPRequestOperation *)POSTurlString:(NSString *)urlString  parameters:(NSString *)parameters ;

- (BOOL) isBlankString:(NSString *)string;

-(NSString*) DateFormartString:(NSString*) sourcedate;
-(NSString*) DateFormartMDHM:(NSString*) sourcedate;

@end
