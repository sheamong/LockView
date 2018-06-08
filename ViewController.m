//
//  ViewController.m
//  LockView
//
//  Created by student on 15-3-15.
//  Copyright (c) 2015年 yxy. All rights reserved.
//

#import "ViewController.h"
#import "LockView.h"

@interface ViewController ()<LockViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    LockView *lockView = [[LockView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    lockView.backgroundColor = [UIColor whiteColor];
    lockView.delegate = self;
    [self.view addSubview:lockView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)lockViewDidClick:(LockView *)lockView andPwd:(NSString *)pwd {

    NSLog(@"密码= %@",pwd);
}

@end
