//
// Created by lvsheng on 15/11/14.
// Copyright (c) 2015 lvsheng. All rights reserved.
//

#import "MethodRouter.h"


@implementation MethodRouter {

}
+(void)invokeMethod:(int)methodId of:(id)obj {
    SEL sel;
    switch (methodId) {
        //TODO: 当methodId相同时，根据参数名、参数进一步去重。oc中有没有instance of之类或能不能从参数名与参数类型拿到带参数名的sel？
        case 0:
            sel = @selector(test0);
            break;
        case 1:
            sel = @selector(test1);
            break;
        case 2:
            sel = @selector(test2);
            break;
        default:
            [NSException raise:@"unrecognized methodId" format:@"methodId %d is not recognized", methodId];
            break;
    }

    if ([obj respondsToSelector:sel]) {
        IMP imp = [obj methodForSelector:sel];

        //TODO: 根据原函数原型在这里作相应转换
        void(*func)(id, SEL) = (void*) imp;
        func(obj, sel);
    }
}
@end