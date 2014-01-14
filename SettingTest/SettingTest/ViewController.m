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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(defaultsChanged:) name:NSUserDefaultsDidChangeNotification object:nil];
    
    [self openDB];
    [self selectMessages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)defaultsChanged:(NSNotification *)notification {
    NSLog(@"CHANGE");
    [self refreshName];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshName];
}

- (void)refreshName {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaults objectForKey:@"name_preference"];
    
    NSLog(@"name %@", name);
    self.nameField.text = name;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *name = textField.text;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:name forKey:@"name_preference"];
    [defaults synchronize];
    
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
