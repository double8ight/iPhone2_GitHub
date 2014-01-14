//
//  ViewController.m
//  day12_3_5_9_sqliteMovieFinder
//
//  Created by SDT-1 on 2014. 1. 13..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"
#import "actorViewController.h"
#import "movie.h"
#import <sqlite3.h>


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation ViewController{
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
    
    
    const char *createSQL = "CREATE TABLE IF NOT EXISTS MOVIE (TITLE TEXT, ACTOR TEXT)";
    char *errorMSg;
    ret = sqlite3_exec(db, createSQL, NULL, NULL, &errorMSg);
    if (SQLITE_OK != ret){
        [fm removeItemAtPath:dbFilePath error:nil];
        NSAssert1(SQLITE_OK == ret, @"Error on creating table : %s", errorMSg);
        NSLog(@"creating table with ret : %d",ret);
    }
    
    const char *createSQL2 = "CREATE TABLE IF NOT EXISTS ACTOR (MOVIE_ID INT, ACTOR TEXT)";
    char *errorMSg2;
    ret = sqlite3_exec(db, createSQL2, NULL, NULL, &errorMSg2);
    if (SQLITE_OK != ret){
        [fm removeItemAtPath:dbFilePath error:nil];
        NSAssert1(SQLITE_OK == ret, @"Error on creating table : %s", errorMSg2);
        NSLog(@"creating table with ret : %d",ret);
    }
}

- (void)addData:(NSString *)input{
    NSLog(@"adding data : %@",input);
    
    // sqlite3_exec 로 실행하기
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO movie (title) VALUES ('%@')", input];
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
    [self.data removeAllObjects];
    
    // 데이터 베이스에서 사용할 쿼리 준비
    NSString *queryStr = @"SELECT rowid,title FROM movie";
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
        if(title != nil)
            one.title = [NSString stringWithCString:title encoding:NSUTF8StringEncoding];
        
        [self.data addObject:one];
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
        movie *one = [self.data objectAtIndex:indexPath.row];
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM movie WHERE rowid = %d",one.rowID];
        
        
        char * errMsg;
        int ret = sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errMsg);
        
        if(SQLITE_OK != ret){
            NSLog(@"Error (%d) on deleting data : %s",ret,errMsg);
        }
        [self resolveData];
    }
}

// 데이터 수정 (셀 선택시)
/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"영화제목 변경" message:@"변경하실 영화제목으로 입력 해 주세요" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 2;
    
    //UITextField *textField = [alert textFieldAtIndex:0];
    //movie *one = [self.data objectAtIndex:indexPath.row];
    //textField.text = one.title;
    
    //self.rowid = indexPath.row;
    
    [alert show];
}
*/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TITLE_ID" forIndexPath:indexPath];
    
    // Movie 데이터에서 타이틀 정보를 셀에 표시
    movie *one = [self.data objectAtIndex:indexPath.row];
    cell.textLabel.text = one.title;
    return cell;
}



// Alert 수정
/*
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 2)
    {
        if(alertView.firstOtherButtonIndex == buttonIndex)
        {
            UITextField *textField = [alertView textFieldAtIndex:0]; // alertview에 있는 plaintext를 UITextField로 가져온다.
            
            NSLog(@"adding data : %@", textField.text);
            
            // sqlite3_exec 로 실행하기
            //movie *one = [data objectAtIndex:indexPath.row];
            NSString *sql = [NSString stringWithFormat:@"UPDATE movie SET title='%@' WHERE rowid = %d", textField.text, self.rowid+1];
            NSLog(@"sql : %@",sql);
            
            char * errMsg;
            int ret = sqlite3_exec(db, [sql UTF8String], NULL, nil, &errMsg);
            
            if(SQLITE_OK != ret){
                NSLog(@"Error on Update New Data : %s",errMsg);
            }
            
            // 이후 화면 갱신을 위해서 select를 호출
            [self resolveData];
            
            
            NSLog(@"확인");
            
        }
        else
        {
            NSLog(@"취소");
        }
    }
    else
    {
        // 기타 alert들 처리부분
    }
}*/

/*
-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if(alertView.tag == 2)
    {
        UITextField *textField = [alertView textFieldAtIndex:0];
        return (textField.text.length > 0);
    }
    
    return YES;
}
*/





-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    actorViewController *actorVC = segue.destinationViewController;
    
    // 현재 테이블에 IndexPath 받아오기
    NSIndexPath *indexPath = [self.table indexPathForCell:sender];
    movie *movie = [self.data objectAtIndex:indexPath.row];
    actorVC.movieID = movie.rowID;
    actorVC.db = db;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.data = [NSMutableArray array];
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
