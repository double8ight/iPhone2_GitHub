//
//  Catalog.m
//  day10_1_2_3_CatalogApp
//
//  Created by SDT-1 on 2014. 1. 9..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "Catalog.h"
#import "Product.h"

@implementation Catalog
{
    NSArray *data;
}

// Singleton 메소드
static Catalog *_instance = nil;
+(id)defaultCatalog
{
    if(_instance == nil)
    {
        _instance = [[Catalog alloc]init];
        
    }
    
    return _instance;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        data = @[[Product product:@"BaseBall" code:@"0" price:@"100" image:@"baseball.jpg"],
                 [Product product:@"BasketBall" code:@"1" price:@"200" image:@"basketball.jpg"],
                 [Product product:@"FootBall" code:@"2" price:@"250" image:@"football.jpg"],
                 [Product product:@"RugbyBall" code:@"3" price:@"300" image:@"rugbyball.jpg"],
                 [Product product:@"Wilson" code:@"4" price:@"999" image:@"wilson.jpg"]];
    }
    
    return self;
}

// 예제를 간단하게 하기 위해서, 배열의 인덱스로 제품 구분

-(id)productAt:(int)index
{
    return [data objectAtIndex:index];
}

// 제품의 개수
-(int)numberOfProducts
{
    return [data count];
}




@end
