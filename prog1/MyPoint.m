//
// Created by lvsheng on 15/11/14.
// Copyright (c) 2015 lvsheng. All rights reserved.
//

#import "MyPoint.h"


@implementation MyPoint

-(NSNumber *) x {
    return mX;
}
-(NSNumber *) y {
    return mY;
}
-(void) setX:(NSNumber *)x {
    mX = x;
}
//-(void) setX:(int)x { //will caught error
//    mX = @4;
//}
-(void) setY:(NSNumber *)y {
    mY = y;
}
-(void) setX:(NSNumber *)x andY:(NSNumber *)y {
    mX = x;
    mY = y;
}
-(void) print {
    NSLog(@"x: %@, y: %@", mX, mY);
}
-(void) test {
}
-(long) test1: (long)x {
    return 1 + x;
}
@end
