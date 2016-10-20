//
//  LikeEmitterLayer.m
//  LIVELikeEmitter
//
//  Created by wubaozeng on 2016/10/20.
//  Copyright © 2016年 wubaozeng. All rights reserved.
//

#import "LikeEmitterLayer.h"

static NSString *const kAnimationValueKey = @"kAnimationValueKey";

@implementation LikeEmitterLayer
{
    CGPoint     launchingPoint;
    
    NSMutableArray  *heartArray;
    
    CGRect firstRect;
    
    CGRect secendRect;
    
    CGRect thirdRect;
}

-(instancetype)initWithFrame:(CGRect)frame withLauchPoint:(CGPoint)point
{
    self = [super init];
    
    if(self)
    {
        self.frame = frame;
        
        launchingPoint = point;
        
        heartArray = [NSMutableArray new];
        
        //三组供取随机坐标的区域
        firstRect = CGRectMake(launchingPoint.x - 20, launchingPoint.y, 40, 50);
        
        secendRect = CGRectMake(launchingPoint.x - 40, launchingPoint.y - 50, 80, 80);
        
        thirdRect = CGRectMake(launchingPoint.x - 60, launchingPoint.y - 130, 120, 100);
        
    }
    
    return self;
}

-(void)lauchWithCount:(NSInteger)count
{
    
    void (^animationStart)(CALayer *heart,float i,NSInteger count) = ^(CALayer *heart,float i,NSInteger count)
    {
        //取三组随机点，用于生成贝塞尔曲线
        CGPoint firstPoint = getRandomPointFromRect(firstRect);
        
        CGPoint secondPoint = getRandomPointFromRect(secendRect);

        CGPoint thirdPoint = getRandomPointFromRect(thirdRect);
        
        //关键帧动画
        CAKeyframeAnimation *keyframeAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
        
        //绘制贝塞尔曲线
        CGMutablePathRef path=CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, launchingPoint.x, launchingPoint.y);//移动到起始点
        CGPathAddCurveToPoint(path, NULL, firstPoint.x, firstPoint.y, secondPoint.x, secondPoint.y, thirdPoint.x, thirdPoint.y);
        
        keyframeAnimation.path=path;
        CGPathRelease(path);
        
        keyframeAnimation.duration=2;
        keyframeAnimation.beginTime=CACurrentMediaTime()+(i / count);
        [keyframeAnimation setValue:heart forKey:kAnimationValueKey];
        keyframeAnimation.delegate = self;
        keyframeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [heart addAnimation:keyframeAnimation forKey:@"KCKeyframeAnimation_Position"];
        
        //透明度
        CABasicAnimation    *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.duration = 2;
        opacityAnimation.fromValue = @(1);
        opacityAnimation.toValue = @(0);
        
        opacityAnimation.beginTime=CACurrentMediaTime()+(i / count);
        
        [heart addAnimation:opacityAnimation forKey:@"opacityAnimatioin"];
        
        //scale
        CABasicAnimation    *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.duration = 0.2;
        scaleAnimation.fromValue = @(0);
        scaleAnimation.toValue  = @(1);
        scaleAnimation.beginTime = CACurrentMediaTime() + (i / count);
        
        [heart addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    };
    
    
    
    for(float i = 0;i<count;i++)
    {
        CALayer *heart;
        
        if(heartArray.count != 0)
        {
            heart = heartArray[0];
            
            [heartArray removeObjectAtIndex:0];
        }
        else
        {
            heart = [CALayer layer];
            
            heart.position = launchingPoint;
            
            heart.contentsGravity = @"resizeAspect";
        }
        
        heart.bounds = CGRectMake(0, 0, 30, 28);
        
        heart.opacity = 0;
        
        [self addSublayer:heart];
        
        UIImage *theImage = [self creatRandomHeartForTemp];
 
        heart.contents = (__bridge id _Nullable)(theImage.CGImage);
        
        animationStart(heart,i,count);
        
    }
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    
    CALayer *heart = [anim valueForKey:kAnimationValueKey];
    
    heart.opacity = 0;
    
    [heart removeFromSuperlayer];
    //回收
    [heartArray addObject:heart];
    
    [CATransaction commit];
}

-(UIImage *)creatRandomHeartForTemp
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"ic_living_like%zd",getRandomNumber(1, 9)]];
}

@end
