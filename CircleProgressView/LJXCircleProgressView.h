//
//  LJXCircleProgressView.h
//  LJXCircleGradienProgress
//
//  Created by 栾金鑫 on 2019/8/31.
//  Copyright © 2019年 栾金鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^notifyBlock) (NSInteger currentP);

@interface LJXCircleProgressView : UIView

@property (nonatomic , strong) UIColor * insideBackgroundColor;

@property (nonatomic , strong) UIColor * fillColor;

@property (nonatomic , strong) UIColor * strokeColor;

@property (nonatomic , assign) CGFloat lineWidth;

@property (nonatomic , assign) CGFloat percent;

+ (instancetype) showCircleProgressWithFrame:(CGRect)frame notify:(void (^) (NSInteger currentP))notify;

@end

NS_ASSUME_NONNULL_END
