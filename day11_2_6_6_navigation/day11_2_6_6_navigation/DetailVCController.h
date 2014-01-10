//
//  DetailVCController.h
//  day11_2_6_6_navigation
//
//  Created by SDT-1 on 2014. 1. 10..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailVCController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong) NSString *urlStr;

@end
