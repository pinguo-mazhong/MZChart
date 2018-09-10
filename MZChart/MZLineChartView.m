//
//  MZLineChartView.m
//  MZChart
//
//  Created by 马忠 on 2018/9/4.
//  Copyright © 2018年 马忠. All rights reserved.
//

#import "MZLineChartView.h"
#import "UIView+MZAdd.h"
#import "UIColor+MZAdd.h"

static CGFloat const kContentLeftMargin = 20;
static CGFloat const kContentRightMargin = 20;

@interface MZLineChartView ()
@property (nonatomic) UIView *leftAxisView;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) NSMutableArray *linePointArray;
@property (nonatomic) NSMutableArray *lineLayerArray;
@end

@implementation MZLineChartView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.bgColor = [UIColor whiteColor];
        self.gridLineColor = [UIColor mz_colorWithHexString:@"#E6E6E6"];
        self.axisLabelColor = [UIColor mz_colorWithHexString:@"#808080"];
        self.lineColor = [UIColor mz_colorWithHexString:@"#22AC38"];
        self.maxY = 1000;
        self.minY = 0;
        self.axisLabelFontSize = 12;
        self.yLabelCount = 5;
        self.insets = UIEdgeInsetsMake(20, 30, 30, 10);
        self.showHorizonGridLine = YES;
        self.showVerticalGridLine = YES;
        self.curveLine = YES;
        self.linePointArray = [NSMutableArray array];
        self.lineLayerArray = [NSMutableArray array];
        [self addSubview:self.scrollView];
        [self addSubview:self.leftAxisView];
    }
    return self;
}

- (void)drawChart {
    self.backgroundColor = self.bgColor;
    [self drawLeftAxis];
    [self drawRightContent];
}

- (void)drawLeftAxis {
    for (CALayer *layer in self.leftAxisView.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    CGFloat step = (self.maxY - self.minY)/self.yLabelCount;
    CGFloat gap = self.yGap;
    CGFloat y = self.mzHeight - self.insets.bottom;
    CGFloat labelWidth = self.insets.left;
    CGFloat labelHeight = 15;
    y -= labelHeight/2;
    for (NSInteger i = 0; i < self.yLabelCount; i++) {
        CATextLayer *textLayer = [CATextLayer new];
        textLayer.fontSize = self.axisLabelFontSize;
        textLayer.alignmentMode = kCAAlignmentRight;
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        textLayer.foregroundColor = self.axisLabelColor.CGColor;
//        textLayer.backgroundColor = [UIColor greenColor].CGColor;
        textLayer.string = [NSString stringWithFormat:@"%.0f", step * i];
        textLayer.frame = CGRectMake(0, y, labelWidth, labelHeight);
        [self.leftAxisView.layer addSublayer:textLayer];
        y -= gap;
    }
}

- (void)drawRightContent {
    for (CALayer *layer in self.scrollView.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    [self drawXLabels];
    [self drawGrid];
    [self drawDataLines];
}

- (void)drawGrid {
    CGFloat xGap = self.xGap;
    CGFloat yGap = self.yGap;
    CGFloat x = kContentLeftMargin;
    CGFloat y = self.mzHeight - self.insets.bottom;
    self.scrollView.contentSize = CGSizeMake(xGap * (self.xLabelStrs.count - 1) + kContentLeftMargin + kContentRightMargin, self.scrollView.mzHeight);
    //horizontal grid line
    if (self.showHorizonGridLine) {
        for (NSInteger i = 0; i < self.yLabelCount; i++) {
            CAShapeLayer *lineLayer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(x, y)];
            [path addLineToPoint:CGPointMake(x + xGap * (self.xLabelStrs.count - 1), y)];
            y -= yGap;
            lineLayer.path = path.CGPath;
            lineLayer.strokeColor = self.gridLineColor.CGColor;
            lineLayer.lineWidth = 0.5;
            [self.scrollView.layer addSublayer:lineLayer];
        }
    }

    //vertical grid line
    if (self.showVerticalGridLine) {
        x = kContentLeftMargin;
        y = self.mzHeight - self.insets.bottom;
        for (NSInteger i = 0; i < self.xLabelStrs.count; i++) {
            CAShapeLayer *lineLayer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(x, y)];
            [path addLineToPoint:CGPointMake(x, self.insets.top)];
            x += xGap;
            lineLayer.path = path.CGPath;
            lineLayer.strokeColor = self.gridLineColor.CGColor;
            lineLayer.lineWidth = 0.5;
            [self.scrollView.layer addSublayer:lineLayer];
        }
    }
}

- (void)drawXLabels {
    CGFloat xGap = self.xGap;
    CGFloat labelWidth = 30;
    CGFloat labelHeight = 20;
    CGFloat x = kContentLeftMargin - labelWidth/2;
    CGFloat y = self.mzHeight - self.insets.bottom + 5;
    for (NSInteger i = 0; i < self.xLabelStrs.count; i++) {
        CATextLayer *textLayer = [CATextLayer new];
        textLayer.fontSize = self.axisLabelFontSize;
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        textLayer.foregroundColor = self.axisLabelColor.CGColor;
//        textLayer.backgroundColor = [UIColor greenColor].CGColor;
        textLayer.string = [NSString stringWithFormat:@"%@", self.xLabelStrs[i]];
        textLayer.frame = CGRectMake(x, y, labelWidth, labelHeight);
        [self.scrollView.layer addSublayer:textLayer];
        x += xGap;
    }
}

- (void)drawDataLines {
    [self.linePointArray removeAllObjects];
    [self.lineLayerArray enumerateObjectsUsingBlock:^(CALayer * _Nonnull layer, NSUInteger idx, BOOL * _Nonnull stop) {
        [layer removeFromSuperlayer];
    }];
    [self.lineLayerArray removeAllObjects];

    for (NSArray *lineData in self.dataSet) {
        NSMutableArray *pointArray = [NSMutableArray array];
        CGFloat x = kContentLeftMargin;
        CGFloat baseY = self.mzHeight - self.insets.bottom;
        CGFloat totalHeight = self.mzHeight - self.insets.top - self.insets.bottom;
        CGFloat totalValue = self.maxY - self.minY;
        for (NSInteger i = 0; i < lineData.count; i++) {
            double yValue = [lineData[i] doubleValue];
            CGFloat y = baseY - ((yValue - self.minY)/totalValue * totalHeight);
            CGPoint point = CGPointMake(x, y);
            [pointArray addObject:[NSValue valueWithCGPoint:point]];
            x += self.xGap;
        }
        [self.linePointArray addObject:pointArray];
    }

    for (NSArray *pointArray in self.linePointArray) {
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        lineLayer.lineWidth = 2;
        lineLayer.strokeColor = self.lineColor.CGColor;
        lineLayer.fillColor = [UIColor clearColor].CGColor;
        UIBezierPath *path = [UIBezierPath bezierPath];
        for (NSInteger i = 0; i < pointArray.count; i++) {
            NSValue *pointValue = pointArray[i];
            CGPoint point = [pointValue CGPointValue];
            if (i == 0) {
                [path moveToPoint:point];
                continue;
            }
            if (self.curveLine) {
                if (i == pointArray.count - 1) {
                    break;
                }
                NSValue *point2Value = pointArray[i+1];
                CGPoint point2 = [point2Value CGPointValue];
                CGPoint midPoint = [self midPointBetweenPoint1:point point2:point2];
                CGPoint control1 = [self controlPointBetweenPoint1:midPoint point2:point];
                CGPoint control2 = [self controlPointBetweenPoint1:midPoint point2:point2];
                [path addQuadCurveToPoint:midPoint controlPoint:control1];
                [path addQuadCurveToPoint:point2 controlPoint:control2];
            } else {
                [path addLineToPoint:point];
            }
        }
        lineLayer.path = path.CGPath;
        [lineLayer addAnimation:self.pathAnimation forKey:@"strokeEndAnimation"];
        [self.scrollView.layer addSublayer:lineLayer];
        [self.lineLayerArray addObject:lineLayer];
    }
}

- (UIView *)leftAxisView {
    if (!_leftAxisView) {
        _leftAxisView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.insets.left, self.mzHeight)];
        _leftAxisView.backgroundColor = self.bgColor;
    }
    return _leftAxisView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.insets.left, 0, self.mzWidth - self.insets.left, self.mzHeight)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.clipsToBounds = NO;
        _scrollView.backgroundColor = self.bgColor;
    }
    return _scrollView;
}

- (CGFloat)xGap {
    CGFloat gap;
    if (self.xLabelStrs.count <= 8) {
        gap = (self.mzWidth - self.insets.left - self.insets.right - kContentLeftMargin - kContentRightMargin)/(self.xLabelStrs.count - 1);
    } else {
        gap = 40;
    }
    return gap;
}

- (CGFloat)yGap {
    CGFloat gap = (self.mzHeight - self.insets.top - self.insets.bottom)/(self.yLabelCount - 1);
    return gap;
}

- (CGPoint)midPointBetweenPoint1:(CGPoint)point1 point2:(CGPoint)point2 {
    return CGPointMake((point1.x + point2.x)/2, (point1.y + point2.y)/2);
}

- (CGPoint)controlPointBetweenPoint1:(CGPoint)point1 point2:(CGPoint)point2 {
    CGPoint controlPoint = [self midPointBetweenPoint1:point1 point2:point2];
    CGFloat diffY = abs((int)(point2.y - controlPoint.y));
    if (point1.y < point2.y)
        controlPoint.y += diffY;
    else if (point1.y > point2.y)
        controlPoint.y -= diffY;
    return controlPoint;
}

- (CABasicAnimation *)pathAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 2.5;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = @0.0f;
    animation.toValue = @1.0f;
    return animation;
}
@end
