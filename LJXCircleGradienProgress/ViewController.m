//
//  ViewController.m
//  LJXCircleGradienProgress
//
//  Created by 栾金鑫 on 2019/8/31.
//  Copyright © 2019年 栾金鑫. All rights reserved.
//

#import "ViewController.h"
#import "LJXCircleProgressView.h"

#define LJXScreenW  [UIScreen mainScreen].bounds.size.width
#define LJXScreenH  [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic , strong) LJXCircleProgressView * circleView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.circleView = [LJXCircleProgressView showCircleProgressWithFrame:CGRectMake(100,100 , 200 , 200) notify:^(NSInteger currentP) {
        
    }];
    
//    self.circleView.lineWidth = 2.0f;
//    self.circleView.strokeColor = [UIColor lightGrayColor];
//    self.circleView.fillColor = [UIColor purpleColor];
//    self.circleView.percent = 0.79;
    [self.view addSubview:self.circleView];
}

@end
