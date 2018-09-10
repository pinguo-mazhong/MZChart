//
//  MZLineChartView.h
//  MZChart
//
//  Created by 马忠 on 2018/9/4.
//  Copyright © 2018年 马忠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZLineChartView : UIView
@property (nonatomic) UIColor *gridLineColor;
@property (nonatomic) UIColor *bgColor;
@property (nonatomic) UIColor *axisLabelColor;
@property (nonatomic) UIColor *lineColor;
@property (nonatomic) CGFloat maxY;
@property (nonatomic) CGFloat minY;
@property (nonatomic) CGFloat axisLabelFontSize;
@property (nonatomic) NSInteger yLabelCount;
@property (nonatomic) UIEdgeInsets insets;
@property (nonatomic) BOOL showHorizonGridLine;
@property (nonatomic) BOOL showVerticalGridLine;
@property (nonatomic) BOOL curveLine;
@property (nonatomic) NSArray *dataSet;
@property (nonatomic) NSArray *xLabelStrs;
@property (nonatomic) NSArray *lineColors;

- (void)drawChart;
@end
