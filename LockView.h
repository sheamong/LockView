//
//  LockView.h
//  LockView
//
//  Created by student on 15-3-15.
//  Copyright (c) 2015年 yxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LockView;
@protocol LockViewDelegate <NSObject>

//自定义一个协议
//协议方法，把当前视图作为参数
- (void)lockViewDidClick:(LockView *)lockView andPwd:(NSString *)pwd;

@end

@interface LockView : UIView

@property (nonatomic, strong)NSMutableArray *buttons;
@property (nonatomic, assign)CGPoint currentPoint;

@property (nonatomic, strong) id <LockViewDelegate> delegate;

@end
