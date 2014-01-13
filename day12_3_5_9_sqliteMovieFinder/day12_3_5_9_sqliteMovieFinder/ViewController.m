//
//  ViewController.m
//  day12_3_5_9_sqliteMovieFinder
//
//  Created by SDT-1 on 2014. 1. 13..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"
#import "movie.h"
#import <sqlite3.h>

@interface ViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation ViewController {
    NSMutableArray *data;
    sqlite3 *db;
}

// 데이터베이스 오픈, 없으면 새로 만든다
- (void)openDB {
    // 데이터베이스 파일 경로 구하기
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbFilePath = [docPath stringByAppendingPathComponent:@"db.sqlite"];
    
    // 데이터 베이스 파일 체크
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL existFile = [fm fileExistsAtPath:dbFilePath];
    
    // copy해야하는 이유는.. 복사를 하지않으면 읽기전용으로 불려오기때문에..
    if (existFile == NO) {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"db.sqlite"];
        NSError *error;
        BOOL success = [fm copyItemAtPath:defaultDBPath toPath:dbFilePath error:&error];
        
        if (!success) {
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
    }
    //
    
    // 데이터 베이스 오픈
    int ret = sqlite3_open([dbFilePath UTF8String], &db);
    NSAssert1(SQLITE_OK == ret, @"Error on opening Database : %s", sqlite3_errmsg(db));
    NSLog(@"Success on Opening Database");
    
    // 새롭게 데이터베이스를 만들었으면 테이블을 생성한다
    if (NO == existFile) {
        // 테이블 생성
        const char *createSQL = "CREATE TABLE IF NOT EXISTS MOVIE (TITLE TEXT)";
        char *errorMsg;
        ret = sqlite3_exec(db, createSQL, NULL, NULL, &errorMsg);
        if (ret != SQLITE_OK) {
            [fm removeItemAtPath:dbFilePath error:nil];
            NSAssert1(SQLITE_OK == ret, @"Error on creating : %s", errorMsg);
            NSLog(@"creating table with ret : %d", ret);
        }
    }
}

// 새로운 데이터를 데이터베이스에 저장한다
- (void)addData:(NSString *)input {
    NSLog(@"adding data : %@", input);
    
    // sqlite3_exec 로 실행하기
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO MOVIE (TITLE) VALUES ('%@')", input];
    NSLog(@"sql : %@", sql);
    
    char *errMsg;
    int ret = sqlite3_exec(db, [sql UTF8String], NULL, nil, &errMsg);
    
    if (SQLITE_OK != ret) {
        NSLog(@"Error on Insert New data : %s", errMsg);
    }
    
    // 바인딩 예제
    //
    
    [self resolveData];
}

// 데이터베이스 닫기
- (void)closeDB {
    sqlite3_close(db);
}

// 데이터베이스에서 정보를 가져온다
- (void)resolveData {
    // 기존 데이터 삭제
    [data removeAllObjects];
    
    // 데이터 베이스에서 사용할 쿼리 준비
    NSString *queryStr = @"SELECT rowid, title FROM MOVIE";
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    NSAssert2(SQLITE_OK == ret, @"Error(%d) on resolving data : %s", ret, sqlite3_errmsg(db));
    
    // 모든 행의 정보를 얻어온다
    while (SQLITE_ROW == sqlite3_step(stmt)) {
        int rowID = sqlite3_column_int(stmt, 0);
        char *title = (char *)sqlite3_column_text(stmt, 1);
        
        // Movie 객체 생성, 데이터 세팅
        movie *one = [[movie alloc] init];
        one.rowID = rowID;
        one.title = [NSString stringWithCString:title encoding:NSUTF8StringEncoding];
        [data addObject:one];
    }
    sqlite3_finalize(stmt);
    
    // 테이블 갱신
    [self.table reloadData];
}

//
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text length] > 1) {
        [self addData:textField.text];
        [textField resignFirstResponder];
        textField.text = @"";
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        movie *one = [data objectAtIndex:indexPath.row];
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM MOVIE WHERE rowid=%d",one.rowID];
        
        char *errorMsg;
        int ret = sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errorMsg);
        
        if (SQLITE_OK != ret) {
            NSLog(@"Error(%d) on deleting data : %s", ret, errorMsg);
        }
        [self resolveData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ID" forIndexPath:indexPath];
    
    //
    movie *one = [data objectAtIndex:indexPath.row];
    cell.textLabel.text = one.title;
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    data = [NSMutableArray array];
    [self openDB];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resolveData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end