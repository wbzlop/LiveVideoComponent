//
//  LikeEmitterLayer.h
//  LIVELikeEmitter
//
//  Created by wubaozeng on 2016/10/20.
//  Copyright © 2016年 wubaozeng. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

UIKIT_STATIC_INLINE int getRandomNumber(int from,int to)
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

UIKIT_STATIC_INLINE CGPoint getRandomPointFromRect(CGRect rect)
{
    return CGPointMake(getRandomNumber(rect.origin.x, rect.origin.x + rect.size.width),
                       getRandomNumber(rect.origin.y - rect.size.height, rect.origin.y));
}

@interface LikeEmitterLayer : CALayer

-(instancetype)initWithFrame:(CGRect)frame withLauchPoint:(CGPoint)point;

-(void)lauchWithCount:(NSInteger )count;

@end
