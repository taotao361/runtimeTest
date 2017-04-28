//
//  People.m
//  runtime
//
//  Created by yangxutao on 16/8/23.
//  Copyright © 2016年 yangxutao. All rights reserved.
//

#import "People.h"

@implementation People


- (instancetype)init {
    if (self = [super init]) {
        
        
        [self loadSomeThing];
        [self aaa];
    }
    return self;
}





- (void)aaa {
    NSLog(@"People   aaa");
}



- (void)loadSomeThing {
    NSLog(@"People    loadSomeThing");
}

@end
