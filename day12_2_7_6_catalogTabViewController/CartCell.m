//
//  CartCell.m
//  day10_1_2_3_CatalogApp
//
//  Created by SDT-1 on 2014. 1. 9..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "CartCell.h"

@interface CartCell()

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *number;

@end

@implementation CartCell

// 수량 증가 버튼
- (IBAction)plusClicked:(id)sender {
    [self.delegate incQuantity:self.productCode];
}

// 수량 감소 버튼
- (IBAction)minusClicked:(id)sender {
    [self.delegate decQuantity:self.productCode];
}

// 셀에 반영할 내용
-(void)setCartItem:(CartItem *)item
{
    // 제품 구별용 코드
    self.productCode = item.product.code;
    
    // 셀 반영
    self.number.text = [NSString stringWithFormat:@"%d개", item.quantity];
    self.name.text = [NSString stringWithFormat:@"%@",item.product.name];
}

@end
