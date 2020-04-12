//
//  MainTabBarController.m
//  FeedStreamDemo1
//
//  Created by caiyongfang on 2020/4/5.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    HomeViewController* home = [[HomeViewController alloc]init];
    [self setTabBarItem:home.tabBarItem
                  title:@"首页"
              titleSize:13.0
          titleFontName:@"HeiTi SC"
          selectedImage:@"i_tab_home_selected"
     selectedTitleColor:[UIColor redColor]
            normalImage:@"i_tab_home_normal"
       normalTitleColor:[UIColor grayColor]];
    home.currentIndex = 0;
    MessageViewController* mess = [[MessageViewController alloc]init];
    [self setTabBarItem:mess.tabBarItem
                 title:@"消息"
             titleSize:13.0
         titleFontName:@"HeiTi SC"
         selectedImage:@"i_tab_home_selected"
    selectedTitleColor:[UIColor redColor]
           normalImage:@"i_tab_home_normal"
      normalTitleColor:[UIColor grayColor]];
    UINavigationController *homeNV =[[UINavigationController alloc] initWithRootViewController:home];
    homeNV.navigationBar.translucent = NO;
    homeNV.title = @"首页";
    UINavigationController *messNV =[[UINavigationController alloc] initWithRootViewController:mess];
    messNV.title = @"消息";
    NSArray* tabArr = @[homeNV,messNV];
    [self setViewControllers:tabArr];
   
   
    // Do any additional setup after loading the view.
}

- (void)setTabBarItem:(UITabBarItem *)tabbarItem
                title:(NSString *)title
            titleSize:(CGFloat)size
        titleFontName:(NSString *)fontName
        selectedImage:(NSString *)selectedImage
   selectedTitleColor:(UIColor *)selectColor
          normalImage:(NSString *)unselectedImage
     normalTitleColor:(UIColor *)unselectColor
{
    
    //设置图片
    tabbarItem = [tabbarItem initWithTitle:title image:[[UIImage imageNamed:unselectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    // S未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:unselectColor,NSFontAttributeName:[UIFont fontWithName:fontName size:size]} forState:UIControlStateNormal];
    
    // 选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor,NSFontAttributeName:[UIFont fontWithName:fontName size:size]} forState:UIControlStateSelected];
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
@end
