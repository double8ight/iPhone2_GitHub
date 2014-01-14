//
//  actorViewController.h
//  day12_3_5_9_sqliteMovieFinderAndUpdate
//
//  Created by SDT-1 on 2014. 1. 14..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface actorViewController : UIViewController<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property NSMutableArray *actor;
@property NSInteger movieID;
@property sqlite3 *db;

@end
