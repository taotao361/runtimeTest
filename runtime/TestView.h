//
//  TestView.h
//  runtime
//
//  Created by yangxutao on 16/11/10.
//  Copyright © 2016年 yangxutao. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol protocolTest <NSObject>

- (void)aaa;

@end


@interface TestView : UIView<protocolTest>

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) int age;

- (NSArray *)getArray;

@end
