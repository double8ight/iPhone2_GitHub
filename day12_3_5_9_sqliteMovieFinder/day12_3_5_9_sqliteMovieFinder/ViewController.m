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


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation ViewController{
    NSMutableArray *data;
    sqlite3 *db;
}



- (void)openDB{
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *dbFilePath = [docPath stringByAppendingPathComponent:@"db.sqlite"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL existFile = [fm fileExistsAtPath:dbFilePath];
    if(existFile == NO){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"db.sqlite"];
        NSError *error;
        BOOL success = [fm copyItemAtPath:defaultDBPath toPath:dbFilePath error:&error];
        
        if(!success)
            NSAssert1(0,@"Failed to create write able database file with message '%@'",[error localizedDescription]);
    }
    
    int ret = sqlite3_open([dbFilePath UTF8String], &db);
    NSAssert1(SQLITE_OK == ret, @"Errot %s",sqlite3_errmsg(db));
    NSLog(@"SUCCESS");
    
    
    const char *createSQL = "CREATE TABLE IF NOT EXISTS MOVE (TITLE TEXT)";
    char *errorMSg;
    ret = sqlite3_exec(db, createSQL, NULL, NULL, &errorMSg);
    if (SQLITE_OK != ret){
        [fm removeItemAtPath:dbFilePath error:nil];
        NSAssert1(SQLITE_OK == ret, @"Error on creating table : %s", errorMSg);
        NSLog(@"creating table with ret : %d",ret);
    }
}

- (void)addData:(NSString *)input{
    NSLog(@"adding data : %@",input);
    
    // sqlite3_exec 로 실행하기
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO movie (name) VALUES ('%@')", input];
    NSLog(@"sql : %@",sql);
    
    char * errMsg;
    int ret = sqlite3_exec(db, [sql UTF8String], NULL, nil, &errMsg);
    
    if(SQLITE_OK != ret){
        NSLog(@"Error on Insert New Data : %s",errMsg);
    }
    
    
    // 이후 화면 갱신을 위해서 select를 호출
    [self resolveData];
}
// 데이터 베이스 닫기
-(void) closeDB{
    sqlite3_close(db);
}


// 데이터베이스에서 정보를 가져온다.
- (void)resolveData{
    // 기존 데이터 삭제
    [data removeAllObjects];
    
    // 데이터 베이스에서 사용할 쿼리 준비
    NSString *queryStr = @"SELECT rowid,name FROM movie";
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK == ret, @"ERROR (%d) on resolving data : %s",ret,sqlite3_errmsg(db));
    
    // 모든 행의 정보를 얻어온다.
    while(SQLITE_ROW == sqlite3_step(stmt)){
        int rowID = sqlite3_column_int(stmt, 0);
        char *title = (char *)sqlite3_column_text(stmt,1);
        
        // movie 객체 생성, 데이터 세팅
        movie *one = [[movie alloc] init];
        one.rowID = rowID;
        one.title = [NSString stringWithCString:title encoding:NSUTF8StringEncoding];
        
        [data addObject:one];
    }
    
    sqlite3_finalize(stmt);
    
    // 테이블 갱신
    [self.table reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField.text length]> 1){
        [self addData:textField.text];
        [textField resignFirstResponder];
        textField.text = @"";
    }
    return YES;
}


// 데이터 삭제
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if( UITableViewCellEditingStyleDelete == editingStyle){
        movie *one = [data objectAtIndex:indexPath.row];
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM movie WHERE rowid = %d",one.rowID];
        
        
        char * errMsg;
        int ret = sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errMsg);
        
        if(SQLITE_OK != ret){
            NSLog(@"Error (%d) on deleting data : %s",ret,errMsg);
        }
        [self resolveData];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [data count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ID" forIndexPath:indexPath];
    
    // Movie 데이터에서 타이틀 정보를 셀에 표시
    movie *one = [data objectAtIndex:indexPath.row];
    cell.textLabel.text = one.title;
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    data = [NSMutableArray array];
    [self openDB];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self resolveData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
