//
//  movie.h
//  day12_3_5_9_sqliteMovieFinder
//
//  Created by SDT-1 on 2014. 1. 13..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface movie : NSObject
@property (copy, nonatomic) NSString *title;
@property int rowID;
@property (copy, nonatomic) NSString *actor;
@end
