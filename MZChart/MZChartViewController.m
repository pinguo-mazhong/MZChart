//
//  MZChartViewController.m
//  MZChart
//
//  Created by 马忠 on 2018/9/6.
//  Copyright © 2018年 马忠. All rights reserved.
//

#import "MZChartViewController.h"
#import "MZLineChartView.h"

@interface MZChartViewController ()

@end

@implementation MZChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    MZLineChartView *chartView = [[MZLineChartView alloc] initWithFrame:CGRectMake(20, 100, CGRectGetWidth(self.view.bounds) - 40, 200)];
    chartView.backgroundColor = [UIColor yellowColor];
    chartView.dataSet = @[
                          @[@200, @354, @20, @7868, @297, @8789, @1254, @200, @354, @20, @7868, @297,],
                          @[@1254, @200, @354, @20, @7868, @297, @200, @354, @20, @7868, @297, @8789, ],
                          ];
    chartView.maxY = 10000;
    chartView.xLabelStrs = @[@"01/01", @"01/02", @"01/03", @"01/04", @"01/05", @"01/06", @"01/07", @"01/08", @"01/09", @"01/10", @"01/11"];
    [self.view addSubview:chartView];
    [chartView drawChart];
}



@end
