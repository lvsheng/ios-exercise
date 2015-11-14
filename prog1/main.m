//
//  main.m
//  prog1
//
//  Created by lvsheng on 15/11/7.
//  Copyright © 2015年 lvsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "./MyPoint.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        MyPoint *p = [MyPoint new];
        [p setX:@3];
        [p setY:@4];
        [p print];

        [p setX:@5 andY:@5];
        [p print];
    }
    return 0;
}
