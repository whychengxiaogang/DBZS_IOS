//  dbzs_IOS
//
//  Created by jianyi on 16/9/9.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "ZCChartlineView.h"

@interface ZCChartlineView ()

@property NSMutableArray<NSNumber*> *swithX_value;
@property NSMutableArray<NSString *> *swithY_value;
@property NSMutableArray<NSNumber*> *pointX_value;
@property NSMutableArray<NSNumber *> *pointY_value;

@end

@implementation ZCChartlineView{
    CGFloat coordinates_offset_x;
    CGFloat scaleValue;
    CAShapeLayer *xyLayer;
    CAShapeLayer *xyPointLayer;
    NSInteger columnSpace;
    int maxRank;
    CGFloat coordinatesHeight;
    CGFloat coordinatesWidth;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self load];
    }
    return self;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self load];
    }
    return self;
}

-(void)load{
    self.lineWith = 1.5;
    _lintype = ZCChartlineTypeBroken;
    xyLayer = [[CAShapeLayer alloc]init];
    _showAssistLineWidth = 1.2f;
    self.rowCount = 7;
    self.rowSpace = 25.0f;
}

-(void)strokeLine{
    if (!(self.x_title&&self.y_title)) {
        NSLog(@"ERROR:x_title or y_title is null ");
        return;
    }
    [self swicthYValue];
    coordinates_offset_x = [self getLabelWidthWithString:[NSString stringWithFormat:@"%@",[self.swithY_value lastObject]] font:[UIFont systemFontOfSize:10.0f] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + 10;
    coordinatesHeight = self.rowCount*self.rowSpace;
    coordinatesWidth = SH_SCREEN_WIDTH - coordinates_offset_x - columnSpace*2;
    columnSpace = coordinatesWidth/self.xRegionCount;
    scaleValue = (coordinatesHeight - self.rowSpace)/maxRank;
    
    [self strokeCoordinates];
    [self swichCoordinate];
    [self chartLine];
}

-(void)strokeCoordinates{
    for (int i = 0; i < self.rowCount; i ++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = [NSString stringWithFormat:@"%@", [self.swithY_value objectAtIndex:i]];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = FMColorWithRGB0X(0x999999);
        [label sizeToFit];
        label.center = CGPointMake(20.0f, coordinatesHeight - self.rowSpace *i);
        [self addSubview:label];
    }
    UIBezierPath *x_vLine = [UIBezierPath bezierPath];
    for (int i = 0; i < self.x_title.count; i ++) {
        UILabel *xlabel = [[UILabel alloc] init];
        xlabel.text = self.x_title[i];
        xlabel.font = [UIFont systemFontOfSize:10];
        xlabel.textColor = FMColorWithRGB0X(0x999999);
        xlabel.textAlignment = NSTextAlignmentRight;
        [xlabel sizeToFit];
        CGRect frame = xlabel.frame;
        frame.origin.y = coordinatesHeight + 12.0f;
        frame.origin.x = columnSpace*(i+1) + coordinates_offset_x - frame.size.width + 8.0f;
        xlabel.frame = frame;
        xlabel.transform = CGAffineTransformMakeRotation(-45 * (M_PI / 180.0f));
        [self addSubview:xlabel];

        [x_vLine moveToPoint:CGPointMake(columnSpace*(i+0.5) + coordinates_offset_x + 5, self.rowSpace)];
        [x_vLine addLineToPoint:CGPointMake(columnSpace*(i+0.5) + coordinates_offset_x + 5, coordinatesHeight)];
    }
    CAShapeLayer *x_VLayer = [[CAShapeLayer alloc]init];
    x_VLayer.path = x_vLine.CGPath;
    x_VLayer.fillColor = [UIColor clearColor].CGColor;
    x_VLayer.strokeColor = FMColorWithRGB0X(0xdddddd).CGColor;
    [self.layer addSublayer:x_VLayer];
    
    UIBezierPath *y_vLine = [UIBezierPath bezierPath];
    for (int i = 0; i < self.swithY_value.count; i ++) {
        [y_vLine moveToPoint:CGPointMake(coordinates_offset_x + 5, coordinatesHeight -  i*self.rowSpace)];
        [y_vLine addLineToPoint:CGPointMake(SH_SCREEN_WIDTH, coordinatesHeight -  i*self.rowSpace)];
    }
    CAShapeLayer *y_VLayer = [[CAShapeLayer alloc]init];
    y_VLayer.path = y_vLine.CGPath;
    y_VLayer.fillColor = [UIColor clearColor].CGColor;
    y_VLayer.strokeColor = FMColorWithRGB0X(0xdddddd).CGColor;
    [self.layer addSublayer:y_VLayer];
}

-(void)chartLine
{
    NSArray *arr = self.pointY_value;
    UIBezierPath *line = [UIBezierPath bezierPath];
    UIBezierPath *lineFlagPath = [UIBezierPath bezierPath];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = CGPointMake([self.pointX_value[idx] floatValue], [obj floatValue]);
        if (idx == 0) {
            [line moveToPoint:point];
        }else{
            [line addLineToPoint:point];
        }
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.text = [NSString stringWithFormat:@"%@",[self.y_title objectAtIndex:idx]];
        valueLabel.textColor = FMColorWithRGB0X(0x333333);
        valueLabel.font = [UIFont systemFontOfSize:10];
        [valueLabel sizeToFit];
        [self addSubview:valueLabel];
        valueLabel.center = CGPointMake(columnSpace*idx + columnSpace/2.0 + coordinates_offset_x + 5, point.y - 10);
        UIBezierPath *tmpPath = [UIBezierPath bezierPath];
        [tmpPath addArcWithCenter:point radius:self.lineWith*1.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        [lineFlagPath appendPath:tmpPath];
    }];
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    CAShapeLayer *lineFlageLayer = [[CAShapeLayer alloc]init];
    lineFlageLayer.path = lineFlagPath.CGPath;
    lineFlageLayer.fillColor = FMColorWithRGB0X(0xffa500).CGColor;
    layer.path = line.CGPath;
    layer.lineWidth = self.lineWith;
    layer.lineCap = kCALineCapRound;
    layer.strokeColor = FMColorWithRGB0X(0xffa500).CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.fromValue = @0.0;
    animation.byValue = @2.0;
    animation.toValue = @1.0;
    animation.duration = [self durationTime:self.xRegionCount];
    [animation setKeyPath:@"strokeEnd"];
    [lineFlageLayer addAnimation:animation forKey:@"animati"];
    [layer addAnimation:animation forKey:@"animation"];
    [self.layer addSublayer:layer];
    [self.layer addSublayer:lineFlageLayer];
}

-(void)swichCoordinate
{
    self.pointY_value = [[NSMutableArray alloc] init];
    self.pointX_value = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.y_title.count; i ++) {
        int rank = [[self.y_title objectAtIndex:i] intValue];
        CGFloat tmp = coordinatesHeight - rank * scaleValue;
        [self.pointY_value addObject:@(tmp)];
    }
    for (int i = 0; i < self.x_title.count; i ++) {
        CGFloat tmp = columnSpace*(i+0.5) + coordinates_offset_x + 5;
        [self.pointX_value addObject:@(tmp)];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    NSInteger touchIndex;
    CGFloat x_lenth = point.x;
    CGFloat Y_length = point.y;
    if (Y_length > coordinatesHeight || x_lenth <= coordinates_offset_x) {
    [self remveoXYSelectPoint];
        return;
    }
    x_lenth -= (columnSpace*0.5 + coordinates_offset_x);
    touchIndex = x_lenth / columnSpace;
    if (touchIndex < 0) {
        return;
    }
    [self remveoXYSelectPoint];;
    UIBezierPath *xyLine = [UIBezierPath bezierPath];
    if (touchIndex >= self.x_title.count) {
        return;
    }
    if (self.zcchartDelegate && [self.zcchartDelegate respondsToSelector:@selector(zCChartlineViewSelect:)]) {
        [self.zcchartDelegate zCChartlineViewSelect:touchIndex];
    }
//    UIBezierPath *xLine = [UIBezierPath bezierPath];
//    CGPoint p1 = CGPointMake(coordinates_offset_x, [self.pointY_value[touchIndex] floatValue]);
//    CGPoint p2 = CGPointMake(SH_SCREEN_WIDTH, [self.pointY_value[touchIndex] floatValue]);
////    [xLine moveToPoint:p1];
////    [xLine addLineToPoint:p2];
////    [xyLine appendPath:xLine];
    [xyLine moveToPoint:CGPointMake([self.pointX_value[touchIndex] floatValue], coordinatesHeight)];
    [xyLine addLineToPoint:CGPointMake([self.pointX_value[touchIndex] floatValue], self.rowSpace)];
    xyLayer.path = xyLine.CGPath;
    xyLayer.fillColor = [UIColor clearColor].CGColor;
    xyLayer.strokeColor = FMColorWithRGB0X(0xf04848).CGColor;
    xyLayer.lineWidth = self.showAssistLineWidth;
    [self.layer addSublayer:xyLayer];
    UIBezierPath *tmpPath = [UIBezierPath bezierPath];
    [tmpPath addArcWithCenter:CGPointMake([self.pointX_value[touchIndex] floatValue], [self.pointY_value[touchIndex] floatValue]) radius:3.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    xyPointLayer = [[CAShapeLayer alloc] init];
    xyPointLayer.path = tmpPath.CGPath;
    xyPointLayer.lineWidth = 2.0;
    xyPointLayer.strokeColor = FMColorWithRGB0X(0xf04848).CGColor;
    xyPointLayer.fillColor = FMColorWithRGB0X(0xffffff).CGColor;
    [self.layer addSublayer:xyPointLayer];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    [self remveoXYSelectPoint];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    [self remveoXYSelectPoint];
}

- (void)remveoXYSelectPoint
{
    [xyLayer removeFromSuperlayer];
    [xyPointLayer removeFromSuperlayer];
}

-(CGSize)getLabelWidthWithString:(NSString*)str font:(UIFont*)font maxSize:(CGSize)maxSize{
    
    return [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

- (void)swicthYValue
{
    self.swithY_value = [[NSMutableArray alloc] init];
    maxRank = 0;
    for (NSNumber *rank in self.y_title) {
        if ([rank intValue] > maxRank ) {
            maxRank = [rank intValue];
        }
    }
    int value = ((maxRank/(self.rowCount-1))/5 + 3)*5;
    maxRank = (self.rowCount -1)*value;
    for (int i=0; i<self.rowCount; i++) {
        int row = i*value;
        if (row > 1000) {
            int k = row/1000;
            int m = ceilf((row - k*1000)/100);
            [self.swithY_value addObject:[NSString stringWithFormat:@"%d.%dk",k, m]];
        }else
        {
            [self.swithY_value addObject:[NSString stringWithFormat:@"%d",row]];
        }
    }
}

- (CGFloat)durationTime:(int)region
{
    switch (region) {
        case 20:
                return 1.5;
            break;
        case 30:
            return 2.0;
            break;
        case 50:
            return 2.0;
            break;
        case 100:
            return 2.0;
            break;
        default:
            return 2.0;
            break;
    }
}
@end
