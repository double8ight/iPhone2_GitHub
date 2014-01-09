//
//  ViewController.m
//  day10_1_1_1_MVCtest
//
//  Created by SDT-1 on 2014. 1. 9..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"
#import "model.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UITextField *productNameField;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 새로운 제품 추가
- (IBAction)addNewProduct:(id)sender {
    // 모델에게 제품 추가하도록
    model *md = [model sharedModel];
    NSString *productName = self.productNameField.text;
    [md addProduct:productName];
    
    
    // 뷰에 반영
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([md numberOfProducts]-1) inSection:0];
    NSArray *newRow = [NSArray arrayWithObject:indexPath];
    [self.table insertRowsAtIndexPaths:newRow withRowAnimation:UITableViewRowAnimationAutomatic];
    
    // 텍스트 필드 정리
    [self.productNameField setText:@""];
    [self.productNameField resignFirstResponder];
                    
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 모델에게 제품 삭제
    [[model sharedModel]removeProductAt:indexPath.row];
    
    // 뷰에 반영
    NSArray *rowForDelete = [NSArray arrayWithObject:indexPath];
    [tableView deleteRowsAtIndexPaths:rowForDelete withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[model sharedModel]numberOfProducts];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Dynamic Prototypes 사용
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ID"];
    
    // 모델에게 제품 정보를 얻어오기
    model *md = [model sharedModel];
    cell.textLabel.text = [md productAt:indexPath.row];
    
    return cell;
}


@end
