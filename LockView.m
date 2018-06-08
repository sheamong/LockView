//
//  LockView.m
//  LockView
//
//  Created by student on 15-3-15.
//  Copyright (c) 2015年 yxy. All rights reserved.
//

#import "LockView.h"

@implementation LockView


#pragma mark-懒加载
- (NSMutableArray *)buttons {

    if (_buttons == nil) {
        
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

//界面搭建
- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self setup];
    }
    return self;
}

//在界面上创建9个按钮
- (void)setup {

    //1.创建9个按钮
    for (int i = 0; i < 9; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        //2 设置按钮的状态背景
        [btn setImage:[UIImage imageNamed:@"dot_off"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"dot_on"] forState:UIControlStateSelected];
        
        //        //九宫格法计算每个按钮的frame
        CGFloat row = i / 3;
        CGFloat loc = i % 3;
        CGFloat btnW = 64;
        CGFloat btnH = 64;
        CGFloat padding = (self.frame.size.width - 3 * btnW) / 4;
        CGFloat y = (self.frame.size.height - self.frame.size.width)/2.0f;
        CGFloat btnX = padding + (btnW + padding) * loc;
        CGFloat btnY = y+padding + (btnW + padding) * row;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        //3 把按钮添加到视图中
        [self addSubview:btn];
        
        //4 禁止按钮的点击事件
        btn.userInteractionEnabled = NO;
        
        //设置每个按钮的tag
        btn.tag = i;
    }
}

//设置按钮的frame
- (void)layoutSubviews {

    //需要先调用父类的方法
    [super layoutSubviews];
    
//    for (int i = 0; i < self.subviews.count; i++) {
//
//        //取出按钮
//        UIButton *btn = self.subviews[i];
//

//
//    }
}

//监听手指的移动
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {


    CGPoint starPoint = [self getCurrentPoint:touches];
    UIButton *btn = [self getCurrentBtnWithPoint:starPoint];

    if (btn && btn.selected != YES) {
        
        //设置按钮的选中状态
        btn.selected = YES;
        //把按钮添加到数组中
        [self.buttons addObject:btn];
    }

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

    CGPoint movePoint = [self getCurrentPoint:touches];
    UIButton *btn = [self getCurrentBtnWithPoint:movePoint];
    //存储按钮
    //已经连过的按钮，不可再连
    if (btn && btn.selected != YES) {
        
        //设置按钮的选中状态
        btn.selected = YES;
        //把按钮添加到数组中
        [self.buttons addObject:btn];
    }
    
    //记录当前点
    self.currentPoint = movePoint;
    
    //通知view重新绘制
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    //取出用户输入的密码
    //创建一个可变的字符串，用来保存用户密码
    NSMutableString *result = [NSMutableString string];
    for (UIButton *btn in self.buttons) {
        
        [result appendFormat:@"%ld", btn.tag];
    }
    NSLog(@"用户输入的密码为： %@", result);
    
    //通知代理，告知用户输入的密码
    if ([self.delegate respondsToSelector:@selector(lockViewDidClick:andPwd:)]) {
        
        [self.delegate lockViewDidClick:self andPwd:result];
    }
    
    //调用该方法，它就会让数组中的每一个元素都调用setSelected:方法，withObject的参数需要为对象，而不是基本数据类型等。
    [self.buttons makeObjectsPerformSelector:@selector(setSelected:) withObject:nil];
    //清空数组
    [self.buttons removeAllObjects];
    [self setNeedsDisplay];
    
    //清空当前点
    self.currentPoint = CGPointZero;
}

//对功能点进行封装
- (CGPoint)getCurrentPoint:(NSSet *)touches {

    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    return point;
}

- (UIButton *)getCurrentBtnWithPoint:(CGPoint)point {

    for (UIButton *btn in self.subviews) {
        
        if (CGRectContainsPoint(btn.frame, point)) {
            return btn;
        }
    }
    return Nil;
}

//重写drawRect: 方法
- (void)drawRect:(CGRect)rect {

    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //绘图(线段)
    for (int i = 0; i < self.buttons.count; i++) {
        
        UIButton *btn = self.buttons[i];
        if (i == 0) {
            
            //设置起点(注意连接的是中点)
            CGContextMoveToPoint(ctx, btn.center.x, btn.center.y);
        } else {
        
            CGContextAddLineToPoint(ctx, btn.center.x, btn.center.y);
        }
    }
    
    //当所有按钮的中点都连接好之后，再连接手指当前的位置
    //判断数组中是否有按钮，只有有按钮的时候才绘制
    if (self.buttons.count != 0) {
        
        CGContextAddLineToPoint(ctx, self.currentPoint.x, self.currentPoint.y);
    }
    
    
    //渲染
    //设置线条的属性
    
    CGContextSetLineWidth(ctx, 10.0);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {0.5, 0.5, 0.5, 0.8};
    CGColorRef color = CGColorCreate(colorspace, components);
    CGContextSetStrokeColorWithColor(ctx, color);

//    CGContextSetLineJoin(ctx, kCGLineJoinRound);
//    CGContextSetLineCap(ctx, kCGLineCapRound);
//    CGContextSetRGBStrokeColor(ctx, 20/255.0, 107/255.0, 153/255.0, 0);
    CGContextStrokePath(ctx);
}


@end
