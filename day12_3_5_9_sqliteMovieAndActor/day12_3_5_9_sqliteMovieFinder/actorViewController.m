//
//  actorViewController.m
//  day12_3_5_9_sqliteMovieFinderAndUpdate
//
//  Created by SDT-1 on 2014. 1. 14..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "actorViewController.h"
#import "ViewController.h"
#import "movie.h"


@interface actorViewController ()
@property (weak, nonatomic) IBOutlet UITableView *table;
- (IBAction)addActor:(id)sender;

@end

@implementation actorViewController
{

}

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
    self.actor = [NSMutableArray array];
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

- (void)addData:(NSString *)input{
    NSLog(@"adding data : %@",input);
    
    // sqlite3_exec 로 실행하기
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO actor (ACTOR, MOVIE_ID) VALUES('%@', %d)", input, self.movieID];
    NSLog(@"sql : %@",sql);
    
    char * errMsg;
    int ret = sqlite3_exec(self.db, [sql UTF8String], NULL, nil, &errMsg);
    
    if(SQLITE_OK != ret){
        NSLog(@"Error on Insert New Data : %s",errMsg);
    }
    
    
    // 이후 화면 갱신을 위해서 select를 호출
    [self resolveData];
}


// 데이터베이스에서 정보를 가져온다.
- (void)resolveData{
    // 기존 데이터 삭제
    [self.actor removeAllObjects];
    
    // 데이터 베이스에서 사용할 쿼리 준비
    NSString *queryStr = [NSString stringWithFormat:@"SELECT movie_id,actor FROM actor WHERE movie_id=%d", self.movieID];
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(self.db, [queryStr UTF8String], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK == ret, @"ERROR (%d) on resolving data : %s",ret,sqlite3_errmsg(self.db));
    
    // 모든 행의 정보를 얻어온다.
    while(SQLITE_ROW == sqlite3_step(stmt)){
        int rowID = sqlite3_column_int(stmt, 0);
        char *actor = (char *)sqlite3_column_text(stmt,1);
        
        // movie 객체 생성, 데이터 세팅
        movie *one = [[movie alloc] init];
        one.rowID = rowID;
        if(actor != nil)
            one.actor = [NSString stringWithCString:actor encoding:NSUTF8StringEncoding];
        
        [self.actor addObject:one];
    }
    
    sqlite3_finalize(stmt);
    
    // 테이블 갱신
    [self.table reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.actor count];
}

// 데이터 삭제
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if( UITableViewCellEditingStyleDelete == editingStyle){
        movie *one = [self.actor objectAtIndex:indexPath.row];
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM actor WHERE rowid = %d",one.rowID];
        
        
        char * errMsg;
        int ret = sqlite3_exec(self.db, [sql UTF8String], NULL, NULL, &errMsg);
        
        if(SQLITE_OK != ret){
            NSLog(@"Error (%d) on deleting data : %s",ret,errMsg);
        }
        [self resolveData];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ACTOR_ID" forIndexPath:indexPath];
    
    // Movie 데이터에서 타이틀 정보를 셀에 표시
    movie *one = [self.actor objectAtIndex:indexPath.row];
    cell.textLabel.text = one.actor;
    return cell;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 2)
    {
        if(alertView.firstOtherButtonIndex == buttonIndex)
        {
            UITextField *textField = [alertView textFieldAtIndex:0]; // alertview에 있는 plaintext를 UITextField로 가져온다.
            
            NSLog(@"adding data : %@", textField.text);
            [self addData:textField.text];
            
            
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
}


-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if(alertView.tag == 2)
    {
        UITextField *textField = [alertView textFieldAtIndex:0];
        return (textField.text.length > 0);
    }
    
    return YES;
}


- (IBAction)addActor:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"영화제목 변경" message:@"변경하실 영화제목으로 입력 해 주세요" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 2;
    
    //UITextField *textField = [alert textFieldAtIndex:0];
    //movie *one = [self.data objectAtIndex:indexPath.row];
    //textField.text = one.title;
    
    //self.rowid = indexPath.row;
    
    [alert show];
}
@end
