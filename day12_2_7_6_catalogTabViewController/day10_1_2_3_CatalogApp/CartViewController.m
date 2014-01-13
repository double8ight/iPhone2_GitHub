//
//  CartViewController.m
//  day11_2_7_6_catalogTabViewController
//
//  Created by SDT-1 on 2014. 1. 13..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "CartViewController.h"
#import "Cart.h"
#import "CartCell.h"
#import "CartDelegate.h"


@interface CartViewController ()<UITableViewDataSource, UITableViewDelegate, CartCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong) Cart *cart;

@end

@implementation CartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // 초기화
        self.cart = [Cart defaultCart];
    }
    return self;
}
 */


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.cart = [Cart defaultCart];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    // 탭 전환되면 테이블이 리로드되도록함.
    [super viewWillAppear:animated];
    [self.table reloadData];
    NSLog(@"%@", self.cart.items);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 카트 내 상품 수량 증가(델리게이트 메소드)
-(void)incQuantity:(NSString *)productCode
{
    [self.cart incQuantity:productCode];
    [self.table reloadData];
}

// 카트내 상품 수량 감소(델리게이트 메소드)
-(void)decQuantity:(NSString *)productCode
{
    [self.cart decQuantity:productCode];
    [self.table reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[Cart defaultCart]numberOfItems];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CART_CELL"];
    
    // 수량 추가/감소를 처리할 델리게이트
    cell.delegate = self;
    
    // 셀 컨텐츠
    // CartItem *item = self.cart.items[indexPath.row];
    CartItem *item = [[Cart defaultCart] cartItemAtIndex:indexPath.row];
    
    [cell setCartItem:item];
    return cell;
}

/*

-(void)forceReloadTable
{
    [self.table reloadData];
}*/


@end
