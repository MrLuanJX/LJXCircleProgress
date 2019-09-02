//
//  LJXCircleProgressView.m
//  LJXCircleGradienProgress
//
//  Created by 栾金鑫 on 2019/8/31.
//  Copyright © 2019年 栾金鑫. All rights reserved.
//

#import "LJXCircleProgressView.h"

@interface LJXCircleProgressView()

@property (nonatomic , copy) notifyBlock notify;

@property (nonatomic , strong) CAShapeLayer * shapeLayer;

@property (nonatomic , assign) CGRect rect;

@property (nonatomic , strong) NSTimer * timer;

@property (nonatomic , strong) CAShapeLayer * shapeL;

@property (nonatomic , strong) UIView * pointView;

@property (nonatomic , strong) UILabel * percentTitle;

@property (nonatomic , assign) int increase;

@end

@implementation LJXCircleProgressView

+ (instancetype) showCircleProgressWithFrame:(CGRect)frame notify:(void (^) (NSInteger currentP))notify {
    
    return [[LJXCircleProgressView alloc] initWithFrame:frame notify:notify];
}

- (instancetype)initWithFrame:(CGRect)frame notify:(void (^) (NSInteger currentP))notify {
    if (self = [super initWithFrame:frame]) {
        
        self.insideBackgroundColor = [UIColor whiteColor];
        
        self.fillColor = [UIColor blueColor];
        
        self.strokeColor = [UIColor lightGrayColor];
        
        self.lineWidth = 5.0f;
        
        self.percent = 0.5;
        
        self.rect = frame;
        
        self.notify = notify;
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    self.increase = 0;

    self.rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    [self circleAnimation];
    
    [self addLabel];
        
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(numShow) userInfo:nil repeats:YES];
    
    if (self.percent > 0) {
        [self startAnimation];
    }
    
    self.percentTitle.textColor = self.fillColor;
}

- (void) circleAnimation {
    
    self.shapeLayer = [CAShapeLayer layer];
    
    self.shapeLayer.frame = self.rect;
    // 设置填充色
    self.shapeLayer.fillColor = self.insideBackgroundColor.CGColor;
    // 设置线宽
    self.shapeLayer.lineWidth = self.lineWidth;
    // 线的颜色
    self.shapeLayer.strokeColor = self.strokeColor.CGColor;
    
    /* 创建底层圆形贝塞尔曲线 */
    UIBezierPath * circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.rect.size.width/2, self.rect.size.height/2) radius:self.rect.size.height/2 startAngle:M_PI_2 endAngle:2.5*M_PI clockwise:YES];
    // 让贝塞尔与CAShapeLayer关联
    self.shapeLayer.path = circlePath.CGPath;
    // 添加并显示
    [self.layer addSublayer:self.shapeLayer];
    
    /* 创建上层贝塞尔 */
    UIBezierPath * circlePathFront = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.rect.size.width/2, self.rect.size.height/2) radius:self.rect.size.height/2 startAngle:M_PI_2 endAngle:2*M_PI*self.percent + M_PI_2 clockwise:YES];
    self.shapeL = [CAShapeLayer layer];
    self.shapeL.frame = self.rect;
    self.shapeL.fillColor = [UIColor clearColor].CGColor;
    self.shapeL.strokeColor = self.fillColor.CGColor;
    self.shapeL.path = circlePathFront.CGPath;
    self.shapeL.lineWidth = self.lineWidth;
    [self.layer addSublayer:self.shapeL];
    
    self.pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.lineWidth*2, self.lineWidth*2)];
    self.pointView.backgroundColor = self.fillColor;
    self.pointView.center = CGPointMake(self.rect.size.width/2, self.rect.size.height);
    self.pointView.layer.cornerRadius = self.lineWidth;
    self.pointView.layer.masksToBounds = YES;
    
    [self addSubview: self.pointView];
}

- (void) startAnimation {
    CABasicAnimation * basicAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basicAnimation.duration = 4*self.percent;
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    basicAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    basicAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    basicAnimation.autoreverses = NO;
    
    CAKeyframeAnimation * frameAntimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    frameAntimation.path = self.shapeL.path;
    frameAntimation.fillMode = kCAFillModeForwards;
    frameAntimation.calculationMode = kCAAnimationPaced;
    frameAntimation.removedOnCompletion = NO;
    frameAntimation.duration = 4*self.percent;
    
    [self.shapeL addAnimation:basicAnimation forKey:@"strokeEndAnimation"];
    [self.pointView.layer addAnimation:frameAntimation forKey:nil];
}

- (void) addLabel {
     self.percentTitle = [[UILabel alloc] initWithFrame:CGRectMake((self.rect.size.width - self.rect.size.width/1.5)/2, self.rect.size.height/4, self.rect.size.width/1.5, self.rect.size.height/4)];
   
    self.percentTitle.text = @"0.00";
    self.percentTitle.font = [UIFont boldSystemFontOfSize:40];
    self.percentTitle.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.percentTitle];
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.percentTitle.frame), CGRectGetMaxY(self.percentTitle.frame), CGRectGetWidth(self.percentTitle.frame), CGRectGetHeight(self.percentTitle.frame))];
    title.text = @"当前进度";
    title.font = [UIFont systemFontOfSize:18];
    title.textColor = [UIColor lightGrayColor];
    title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:title];
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor  = fillColor;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
}

- (void)setInsideBackgroundColor:(UIColor *)insideBackgroundColor {
    _insideBackgroundColor = insideBackgroundColor;
}

- (void)setPercent:(CGFloat)percent {
    _percent = percent;
}

- (void) numShow {
    if (self.percent <= 0) {
        self.percentTitle.text = @"0%";
        [self.timer timeInterval];
        self.timer = nil;
        return;
    }
    
    if (self.percent <= 0.01) {
        self.percentTitle.text = @"1%";
        [self.timer timeInterval];
        self.timer = nil;
        return;
    }
    
    if (self.increase >= 100*self.percent) {
        [self.timer invalidate];
        return;
    }
    
    ++self.increase;
    self.percentTitle.text = [NSString stringWithFormat:@"%d %%",self.increase];
}

@end
