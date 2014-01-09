//
//  model.m
//  day10_1_1_1_MVCtest
//
//  Created by SDT-1 on 2014. 1. 9..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "model.h"

@implementation model

@synthesize data;
//싱글톤 방식
static model *instance;

+(model *)sharedModel
{
    if(instance == nil)
    {
        instance = [[model alloc]init];
        
    }
    return instance;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        data = [[NSMutableArray alloc]initWithObjects:@"iPhone", @"iPod", @"MacBook Air", @"MacBook Pro", @"MacBook Pro Retina", @"iMac", @"MacPro", nil];
    }
    return self;
    
}

//제품 정보 얻기
// 편의상 index를 제품을 구분하는 시겹랒로 사용
-(id)productAt:(int)productId
{
    return [data objectAtIndex:productId];
    
}

-(int)numberOfProducts
{
    return [data count];
}

-(void)addProduct:(id)product
{
    [data addObject:product];
    
}

-(void)removeProductAt:(int)index
{
    [data removeObjectAtIndex:index];
    
}



@end
