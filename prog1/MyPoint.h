//
// Created by lvsheng on 15/11/14.
// Copyright (c) 2015 lvsheng. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyPoint : NSObject
{
    NSNumber *mX;
    NSNumber *mY;
}

-(NSNumber *) x;
-(NSNumber *) y;
-(void) setX: (NSNumber *)x;
//-(void) setX: (int)x; //will caught error
-(void) setY: (NSNumber *)y;
-(void) setX: (NSNumber *)x andY: (NSNumber *)y;
-(void) print;
@end