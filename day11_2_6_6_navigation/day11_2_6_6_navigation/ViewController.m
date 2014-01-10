//
//  ViewController.m
//  day11_2_6_6_navigation
//
//  Created by SDT-1 on 2014. 1. 10..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"
#import "DetailVCController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation ViewController
{
    NSArray *data;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 데이터 초기화
    data = @[@"apple.com", @"google.com", @"daum.net", @"naver.com"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [data count];
}

// 프로토 타입 방식으로 테이블 구성. 스토리보드에서 셀의 ID를 지정해서 사용
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ID"];
    cell.textLabel.text = [data objectAtIndex:indexPath.row];
    return cell;
}


// URL을 디테일 뷰 컨트롤러로 전달
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailVCController *detail = segue.destinationViewController;
    
    // sender는 테이블의 셀
    UITableViewCell *selectedCell = (UITableViewCell *)sender;
    
    // 셀을 이용해서 indexPath를 얻어온다.
    NSIndexPath *selectedIndex = [self.table indexPathForCell:selectedCell];
    detail.urlStr = [data objectAtIndex:selectedIndex.row];
}


-(void)viewWillAppear:(BOOL)animated
{
    // 네이게이션 바를 숨긴다.
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    // 네비게이션 바 숨기기를 해제한다.
    self.navigationController.navigationBarHidden = NO;
}


@end
