//
//  main.m
//  prog1
//
//  Created by lvsheng on 15/11/7.
//  Copyright © 2015年 lvsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        long double total = 0;
        for (int i = 0; i < 11; ++i) {
            total += (double)i / 3;
        }
        // insert code here...
        NSLog(@"Hello, you! %10Lf® %s %p", total, "hello", "hi");
    }
    return 0;
}
