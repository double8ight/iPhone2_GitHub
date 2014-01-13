//
//  CartDelegate.h
//  day10_1_2_3_CatalogApp
//
//  Created by SDT-1 on 2014. 1. 9..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ProductCellDelegate <NSObject>

// 제품을 카트에 추가
-(void)addItem:(id)sender;

// 제품 코드를 이용해서 수량 증가/감소
-(void)incQuantity:(NSString *)productCode;
-(void)decQuantity:(NSString *)productCode;


@end


@protocol CartCellDelegate <NSObject>

// 제품 코드를 이용해서 수량 증가/감소
-(void)incQuantity:(NSString *)productCode;
-(void)decQuantity:(NSString *)productCode;


@end
