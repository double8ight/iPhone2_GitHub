//
//  CartCell.h
//  day10_1_2_3_CatalogApp
//
//  Created by SDT-1 on 2014. 1. 9..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CartDelegate.h"
#import "CartItem.h"

@interface CartCell : UITableViewCell

@property (weak, nonatomic) id<CartDelegate> delegate;
@property (copy, nonatomic) NSString *productCode;

-(void)setCartItem:(CartItem *)item;



@end
