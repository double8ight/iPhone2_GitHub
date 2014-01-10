//
//  ViewController.m
//  day11_ModalTest
//
//  Created by SDT-1 on 2014. 1. 10..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nameChanged:) name:@"UsernameChanged" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)nameChanged:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    self.username.text = info[@"username"];
}

@end
