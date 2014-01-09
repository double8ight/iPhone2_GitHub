//
//  Cart.m
//  day10_1_2_3_CatalogApp
//
//  Created by SDT-1 on 2014. 1. 9..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "Cart.h"

@implementation Cart

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.items = [[NSMutableArray alloc]init];
    }
    
    return self;
}

// 카트에 제품 추가
-(void)addProduct:(Product *)item;
{
    CartItem *cartItem = [self cartItemWith:item.code];
    if (cartItem == nil) {
        cartItem = [[CartItem alloc]init];
        cartItem.product = item;
        cartItem.quantity = 1;
        [self.items addObject:cartItem];
        
    }
    else
    {
        [self incQuantity:item.code];
    }
    
}


// 카트의 수량을 늘린다.
-(void)incQuantity:(NSString *)productCode
{
    CartItem *item = [self cartItemWith:productCode];
    item.quantity++;
}

// 카트의 수량을 줄인다.
-(void)decQuantity:(NSString *)productCode
{
    CartItem *item = [self cartItemWith:productCode];
    item.quantity--;
    
    // 제품 수량이 0이면 삭제
    if(item.quantity == 0)
        [self.items removeObject:item];
}

// 상품 코드로 카트 내 상품 찾기
-(CartItem *)cartItemWith:(NSString *)productCode
{
    for(CartItem *item in self.items)
    {
        if([item.product isEqualProduct:productCode])
        {
            return item;
        }
    }
    
    return nil;
        
}





@end
