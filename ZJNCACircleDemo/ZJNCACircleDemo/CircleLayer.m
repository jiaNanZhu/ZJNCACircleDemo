//
//  CircleLayer.m
//  ZJNCACircleDemo
//
//  Created by 朱佳男 on 2017/1/16.
//  Copyright © 2017年 ShangYuKeJi. All rights reserved.
//

#import "CircleLayer.h"
#import <UIKit/UIKit.h>

typedef enum MovingPoint {
    POINT_D,
    POINT_B,
} MovingPoint;

#define outsideRectSize 90

@interface CircleLayer()

//外接矩形
@property (nonatomic ,assign)CGRect outsideRect;

//记录上次的progress，方便做差得出滑动方向
@property (nonatomic ,assign)CGFloat lastProgress;

//记录实时滑动方向
@property (nonatomic ,assign)MovingPoint movePoint;

@end

@implementation CircleLayer

-(id)init
{
    self = [super init];
    if (self) {
        self.lastProgress = 0.5;
    }
    return self;
}

-(id)initWithLayer:(CircleLayer *)layer{
    self = [super initWithLayer:layer];
    if (self) {
        self.outsideRect  = layer.outsideRect;
        self.lastProgress = layer.lastProgress;
        self.progress     = layer.progress;
    }
    return self;
}

-(void)drawInContext:(CGContextRef)ctx
{
    //A-c1,B-c2...的距离，当设置为正方形边长的1/3.6时，画出来的圆弧完美贴合圆形。
    CGFloat offSet = self.outsideRect.size.width/3.6;
    
    //A.B.C.D实际需要移动的距离.系数为滑块偏离0.5的绝对值乘以2.当滑块划到两端时，移动的距离达到最大值：外接矩形宽度的1/5。
    CGFloat movedDistance = (self.outsideRect.size.width/5)*fabs(self.progress-0.5)*2;
    
    //方便下面计算各点坐标，先算出外接矩形的中心点坐标
    CGPoint rectCenter = CGPointMake(self.outsideRect.size.width/2+self.outsideRect.origin.x, self.outsideRect.size.height/2+self.outsideRect.origin.y);
    
    //定义ABCD四个基本点
    CGPoint pointA = CGPointMake(rectCenter.x, self.outsideRect.origin.y+movedDistance);
    CGPoint pointB = CGPointMake(self.movePoint == POINT_D?self.outsideRect.size.width/2+rectCenter.x:self.outsideRect.size.width/2+rectCenter.x+movedDistance*2, rectCenter.y);
    CGPoint pointC = CGPointMake(rectCenter.x, self.outsideRect.size.height/2+rectCenter.y-movedDistance);
    CGPoint pointD = CGPointMake(self.movePoint == POINT_D?self.outsideRect.origin.x-movedDistance*2:self.outsideRect.origin.x, rectCenter.y);
    
    //定义8个辅助点，使得两点生成一条弧线更加接近于1/4圆。
    CGPoint c1 = CGPointMake(pointA.x+offSet, pointA.y);
    CGPoint c2 = CGPointMake(pointB.x, self.movePoint == POINT_D?pointB.y-offSet:pointB.y-offSet+movedDistance);
    
    CGPoint c3 = CGPointMake(pointB.x, self.movePoint == POINT_D?pointB.y+offSet:pointB.y+offSet-movedDistance);
    CGPoint c4 = CGPointMake(pointC.x+offSet, pointC.y);
    
    CGPoint c5 = CGPointMake(pointC.x-offSet, pointC.y);
    CGPoint c6 = CGPointMake(pointD.x, self.movePoint == POINT_D?pointD.y+offSet-movedDistance:pointD.y+offSet);
    
    CGPoint c7 = CGPointMake(pointD.x, self.movePoint == POINT_D?pointD.y-offSet+movedDistance:pointD.y-offSet);
    CGPoint c8 = CGPointMake(pointA.x-offSet, pointA.y);
    
    //外接虚线矩形
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:self.outsideRect];
    CGContextAddPath(ctx, rectPath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(ctx, 1.0);
    CGFloat dash[] = {5.0,5.0};
    CGContextSetLineDash(ctx, 0.0, dash, 2);
    CGContextStrokePath(ctx);
    
    //圆的边界
    UIBezierPath *ovalPath = [UIBezierPath bezierPath];
    [ovalPath moveToPoint:pointA];
    [ovalPath addCurveToPoint:pointB controlPoint1:c1 controlPoint2:c2];
    [ovalPath addCurveToPoint:pointC controlPoint1:c3 controlPoint2:c4];
    [ovalPath addCurveToPoint:pointD controlPoint1:c5 controlPoint2:c6];
    [ovalPath addCurveToPoint:pointA controlPoint1:c7 controlPoint2:c8];
    [ovalPath closePath];
    
    CGContextAddPath(ctx, ovalPath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextSetLineDash(ctx, 0.0, NULL, 0);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    //标记出每个点并连线，方便观察
    CGContextSetStrokeColorWithColor(ctx, [UIColor darkGrayColor].CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
    NSArray *points = @[[NSValue valueWithCGPoint:pointA],[NSValue valueWithCGPoint:pointB],[NSValue valueWithCGPoint:pointC],[NSValue valueWithCGPoint:pointD],[NSValue valueWithCGPoint:c1],[NSValue valueWithCGPoint:c2],[NSValue valueWithCGPoint:c3],[NSValue valueWithCGPoint:c4],[NSValue valueWithCGPoint:c5],[NSValue valueWithCGPoint:c6],[NSValue valueWithCGPoint:c7],[NSValue valueWithCGPoint:c8]];
    [self drawPoint:points withContext:ctx];
//
    //连接辅助线
    UIBezierPath *helperLine = [UIBezierPath bezierPath];
    [helperLine moveToPoint:pointA];
    [helperLine addLineToPoint:c1];
    [helperLine addLineToPoint:c2];
    [helperLine addLineToPoint:pointB];
    [helperLine addLineToPoint:c3];
    [helperLine addLineToPoint:c4];
    [helperLine addLineToPoint:pointC];
    [helperLine addLineToPoint:c5];
    [helperLine addLineToPoint:c6];
    [helperLine addLineToPoint:pointD];
    [helperLine addLineToPoint:c7];
    [helperLine addLineToPoint:c8];
    [helperLine closePath];

//    CGContextSetStrokeColorWithColor(ctx, [UIColor darkGrayColor].CGColor);
    CGContextAddPath(ctx, helperLine.CGPath);
    CGFloat dash2[] = {2.0 ,2.0};
    CGContextSetLineDash(ctx, 0.0, dash2, 2);
    CGContextStrokePath(ctx);
}

//在某个point位置画一个点，方便观察运动情况
-(void)drawPoint:(NSArray *)points withContext:(CGContextRef)ctx{
    for (NSValue *pointValue in points) {
        CGPoint point = [pointValue CGPointValue];
        CGContextFillRect(ctx, CGRectMake(point.x - 2,point.y - 2,4,4));
    }
}

-(void)setProgress:(CGFloat)progress{
    _progress = progress;
    
    //只要外接矩形在左侧，则改变B点；在右边，改变D点
    if (progress <= 0.5) {
        
        self.movePoint = POINT_B;
        NSLog(@"B点动");
        
    }else{
        
        self.movePoint = POINT_D;
        NSLog(@"D点动");
    }
    
    self.lastProgress = progress;
    
    
    CGFloat origin_x = self.position.x - outsideRectSize/2 + (progress - 0.5)*(self.frame.size.width - outsideRectSize);
    CGFloat origin_y = self.position.y - outsideRectSize/2;
    
    self.outsideRect = CGRectMake(origin_x, origin_y, outsideRectSize, outsideRectSize);
    
    [self setNeedsDisplay];
}







@end
