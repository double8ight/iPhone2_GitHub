//
//  model.h
//  day10_1_1_1_MVCtest
//
//  Created by SDT-1 on 2014. 1. 9..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface model : NSObject

@property NSMutableArray *data;

-(void)addProduct:(id)product;
-(void)removeProductAt:(int)index;

-(id)productAt:(int)productId;
-(int)numberOfProducts;

+(model *)sharedModel;

@end
