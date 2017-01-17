//
//  CircleView.m
//  ZJNCACircleDemo
//
//  Created by 朱佳男 on 2017/1/16.
//  Copyright © 2017年 ShangYuKeJi. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView

+(Class)layerClass{
    return [CircleLayer class];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.circleLayer = [CircleLayer layer];
        self.circleLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.circleLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:self.circleLayer];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
