//
// Created by lvsheng on 15/11/14.
// Copyright (c) 2015 lvsheng. All rights reserved.
//

#import "MethodRouterTest.h"
#import "../react/MethodRouter.h"

@interface A: NSObject
@property char name;

-(void)test0;
-(void)test1;
-(void)test2;
@end

@interface B: NSObject
@property char name;

-(void)test0;
-(void)test1;
-(void)test2;
@end

@interface C: A
-(void)test0;
-(void)test1;
-(void)test2;
@end

@implementation MethodRouterTest {
}

+(void) test {
    NSLog(@"\n\n--------------MethodRouterTest.test--------------");

    //TODO: place to map
    A *a = [A new];
    a.name = 'a';
    B *b = [B new];
    b.name = 'b';
    C *c = [C new];
    c.name = 'c';
    A *d = [C new];
    d.name = 'd';

    NSLog(@"\n\n--------------");
    [MethodRouter invokeMethod:0 of:a];
    [MethodRouter invokeMethod:1 of:a];
    [MethodRouter invokeMethod:2 of:a];

    NSLog(@"\n\n--------------");
    [MethodRouter invokeMethod:0 of:b];
    [MethodRouter invokeMethod:1 of:b];
    [MethodRouter invokeMethod:2 of:b];

    NSLog(@"\n\n--------------");
    [MethodRouter invokeMethod:0 of:c];
    [MethodRouter invokeMethod:1 of:c];
    [MethodRouter invokeMethod:2 of:c];

    NSLog(@"\n\n--------------");
    [MethodRouter invokeMethod:0 of:d];
    [MethodRouter invokeMethod:1 of:d];
    [MethodRouter invokeMethod:2 of:d];
}
@end


@implementation A
-(void)test0 {
    NSLog(@"test0 in A, name: %c", self.name);
}
-(void)test1 {
    NSLog(@"test1 in A, name: %c", self.name);
}
-(void)test2 {
    NSLog(@"test2 in A, name: %c", self.name);
}
@end

@implementation B
-(void)test0 {
    NSLog(@"test0 in B, name: %c", self.name);
}
-(void)test1 {
    NSLog(@"test1 in B, name: %c", self.name);
}
-(void)test2 {
    NSLog(@"test2 in B, name: %c", self.name);
}
@end

@implementation C
-(void)test0 {
    NSLog(@"test0 in C, name: %c", self.name);
    NSLog(@"call super in C:");
    [super test0];
}
-(void)test1 {
    NSLog(@"test1 in C, name: %c", self.name);
    NSLog(@"call super in C:");
    [super test1];
}
-(void)test2 {
    NSLog(@"test2 in C, name: %c", self.name);
    NSLog(@"call super in C:");
    [super test2];
}
@end
