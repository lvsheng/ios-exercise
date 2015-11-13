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
        int to;
        int sum;
 
        NSLog(@"please input:");
        scanf("%d", &to);
        NSLog(@"you just input: %d", to);
        
        for (int i = 0; i < to; ++i) {
            sum += i;
        }
        
        NSLog(@"sum: %d", sum);
    }
    return 0;
}