//
//  TestView.m
//  runtime
//
//  Created by yangxutao on 16/11/10.
//  Copyright © 2016年 yangxutao. All rights reserved.
//

#import "TestView.h"

@implementation TestView



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, 40, 40)];
//    label.text = @"hh";
//    [self addSubview:label];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:self.image];
    [self addSubview:imageView];
}





- (void)layoutSubviews {

    [super layoutSubviews];
    NSLog(@"======layoutSubviews");
}



- (NSArray *)getArray {
    return @[@"33",@"44"];
}



@end
