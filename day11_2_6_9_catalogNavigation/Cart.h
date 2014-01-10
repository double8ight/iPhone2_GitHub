//
//  Cart.h
//  day10_1_2_3_CatalogApp
//
//  Created by SDT-1 on 2014. 1. 9..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
#import "CartItem.h"

@interface Cart : NSObject
@property NSMutableArray *items;

// 카트에 제품 추가
-(void)addProduct:(Product *)item;

// 카트 내 상품 수량 증가/감소
-(void)incQuantity:(NSString *)productCode;
-(void)decQuantity:(NSString *)productCode;

@end
