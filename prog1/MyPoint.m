//
// Created by lvsheng on 15/11/14.
// Copyright (c) 2015 lvsheng. All rights reserved.
//

#import "MyPoint.h"


@implementation MyPoint {

}

-(void) setX:(NSNumber *)x {
    mX = x;
}
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
@end
