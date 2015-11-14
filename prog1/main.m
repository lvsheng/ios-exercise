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

        SEL selSetX = NSSelectorFromString(@"setX:");
        SEL selSetY = NSSelectorFromString(@"setY:");
        [p performSelector:selSetX withObject:@1];
        [p performSelector:selSetY withObject:@1];
        [p print];

        SEL selSetXAndY = NSSelectorFromString(@"setX:andY:");
        [p performSelector:selSetXAndY withObject:@2 withObject:@3];
        [p print];

        IMP impSetXAndY = [p methodForSelector:selSetXAndY];
        void(*funcSetSAndY)(id, SEL, NSNumber *, NSNumber *) = (void*) impSetXAndY;
        funcSetSAndY(p, selSetXAndY, @100, @100);
        [p print];
    }
    return 0;
}
