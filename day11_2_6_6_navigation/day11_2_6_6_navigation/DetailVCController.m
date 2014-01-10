//
//  DetailVCController.m
//  day11_2_6_6_navigation
//
//  Created by SDT-1 on 2014. 1. 10..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "DetailVCController.h"

@interface DetailVCController ()

@end

@implementation DetailVCController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", self.urlStr]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
