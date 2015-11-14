//
// Created by lvsheng on 15/11/14.
// Copyright (c) 2015 lvsheng. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MethodRouter : NSObject
+(void)invokeMethod:(int) methodId of:(id) objId; //TODO: 需将参数个数、每个参数的类型信息也加入考虑
@end