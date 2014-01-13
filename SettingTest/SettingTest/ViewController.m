//
//  ViewController.m
//  SettingTest
//
//  Created by SDT-1 on 2014. 1. 13..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;

@end

@implementation ViewController
{
    sqlite3 *db;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    [self openDB];
    [self selectMessages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaults objectForKey:@"name_preference"];
    
    NSLog(@"name %@", name);
    self.nameField.text = name;
    
    [defaults synchronize];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(void)openDB
{
    NSString *dbPath = [[NSBundle mainBundle]pathForResource:@"db" ofType:@"sqlite"];
    
    int ret = sqlite3_open([dbPath UTF8String], &db);
    NSAssert1(SQLITE_OK == ret, @"Error on opening Database %s", sqlite3_errmsg(db));
    
    NSLog(@"success");
    
}

-(void)selectMessages
{
    NSString *queryStr = @"SELECT * from message";
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    
    while(sqlite3_step(stmt) == SQLITE_ROW)
    {
        char *sender = (char *)sqlite3_column_text(stmt, 0);
        NSString *senderString = [NSString stringWithCString:sender encoding:NSUTF8StringEncoding];
        NSLog(@"sender : %@", senderString);
    }
    
}

@end
