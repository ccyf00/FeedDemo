//
//  FindController.m
//  FeedStreamDemo1
//
//  Created by caiyongfang on 2020/4/5.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "FindController.h"

@interface FindController ()

@end

@implementation FindController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    
   
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width-20*2, 40)];
    label.text = @"发现...";
    label.center = self.view.center;
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment =NSTextAlignmentCenter;
    [self.view addSubview:label];
           
       //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDetailViewController:)];
    label.userInteractionEnabled = YES;
//    self.tabBarItem.title = @"发现";
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    NSLog(@"%s dealloc",object_getClassName(self));
}
@end
