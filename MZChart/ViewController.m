//
//  ViewController.m
//  MZChart
//
//  Created by 马忠 on 2018/9/4.
//  Copyright © 2018年 马忠. All rights reserved.
//

#import "ViewController.h"

#import "MZChartViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"跳转" forState:UIControlStateNormal];
    [button sizeToFit];
    button.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    [self.view addSubview:button];
    [button addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
}

- (void)jump {
    MZChartViewController *vc = [MZChartViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
