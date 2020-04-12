//
//  MessageViewController.m
//  FeedStreamDemo1
//
//  Created by caiyongfang on 2020/4/5.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "MessageViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
//    UIButton *helloBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
//    helloBtn.backgroundColor = [UIColor redColor];
//    [helloBtn setTitle:@"hello world" forState:UIControlStateNormal];
//    [helloBtn addTarget:self action:@selector(showToast) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:helloBtn];
}
- (void)showToast{
    // 打开新ViewController
//    BlogDetailViewController *blogDetail = [[BlogDetailViewController alloc] init];
//    blogDetail.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:blogDetail animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
