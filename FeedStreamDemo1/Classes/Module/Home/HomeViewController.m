//
//  HomeViewController.m
//  FeedStreamDemo1
//
//  Created by caiyongfang on 2020/4/5.
//  Copyright © 2020 bytedance. All rights reserved.
//
#ifndef __OPTIMIZE__
#define NSLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#endif

#import "HomeViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "CityController.h"
#import "AttentionController.h"
#import "FindController.h"

@interface HomeViewController ()<UIScrollViewDelegate>{
    CityController* cityController;
    AttentionController* attentionController;
    FindController* findController;
    UIScrollView* topScrollView;
    UIView* navView;
    UILabel* sliderLabel;
    UIButton* cityButton;
    UIButton* attentionButton;
    UIButton* findButton;
}

@end
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width



@implementation HomeViewController

-(CityController *)city{
    if(cityController == nil){
        cityController = [[CityController alloc]init];
        cityController.navigationController = self.navigationController;
    }
    return cityController;
}

-(AttentionController *)attention{
    if(attentionController==nil){
        attentionController = [[AttentionController alloc]init];
        attentionController.navigationController = self.navigationController;
    }
    return attentionController;
}

-(FindController *)find{
    if(findController==nil){
        findController = [[FindController alloc]init];
        findController.navigationController = self.navigationController;
    }
    return findController;
}

- (void)initUI {
    
    CGFloat viewWidthLeft = SCREEN_WIDTH / 4;
    
    navView = [[UIView alloc]initWithFrame:CGRectMake(viewWidthLeft/2, 0, SCREEN_WIDTH-viewWidthLeft, 40)];
    
    CGFloat buttonWidth = SCREEN_WIDTH-viewWidthLeft;
    
    attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [attentionButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [attentionButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    attentionButton.frame = CGRectMake(0, 0, buttonWidth/3, navView.frame.size.height);
    attentionButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [attentionButton addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [attentionButton setTitle:@"关注" forState:UIControlStateNormal];
    attentionButton.tag = 1;
    attentionButton.selected = YES;
    [navView addSubview:attentionButton];
    
    findButton = [UIButton buttonWithType:UIButtonTypeCustom];
    findButton.frame = CGRectMake(attentionButton.frame.origin.x+attentionButton.frame.size.width, attentionButton.frame.origin.y, buttonWidth/3, navView.frame.size.height);
    [findButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [findButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    findButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [findButton addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [findButton setTitle:@"发现" forState:UIControlStateNormal];
    findButton.tag = 2;
    [navView addSubview:findButton];
    
    
    cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cityButton.frame = CGRectMake(findButton.frame.origin.x+findButton.frame.size.width, findButton.frame.origin.y, buttonWidth/3, navView.frame.size.height);
    [cityButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cityButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    cityButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [cityButton addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [cityButton setTitle:@"同城" forState:UIControlStateNormal];
    cityButton.tag = 3;
    [navView addSubview:cityButton];
    
    sliderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40-2, buttonWidth/3, 4)];
    sliderLabel.backgroundColor = [UIColor redColor];
    [navView addSubview:sliderLabel];
    
    self.navigationItem.titleView = navView;
    
}

- (void)viewDidLoad {
    //
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    [self initUI];
    
    [self setMainSrollView];
    //设置默认
    [self sliderWithTag:_currentIndex+1];
    
    
}

-(void)setMainSrollView{
    topScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    topScrollView.delegate = self;
    topScrollView.backgroundColor = [UIColor whiteColor];
    topScrollView.pagingEnabled = YES;
    topScrollView.showsHorizontalScrollIndicator = NO;
    topScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:topScrollView];
    
    NSArray *views = @[self.attention.view,self.find.view,self.city.view];
    for (NSInteger i = 0; i<views.count; i++) {
        //把三个vc的view依次贴到mainScrollView上面
        UIView *pageView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, topScrollView.frame.size.width, topScrollView.frame.size.height-100)];
        [pageView addSubview:views[i]];
        [topScrollView addSubview:pageView];
    }
    topScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*(views.count), 0);
    //滚动到_currentIndex对应的tab
    [topScrollView setContentOffset:CGPointMake((topScrollView.frame.size.width)*_currentIndex, 0) animated:YES];
}

-(UIButton *)buttonWithTag:(NSInteger )tag{
    if (tag==1) {
        return attentionButton;
    }else if (tag==2){
        return findButton;
    }else if (tag==3){
        return cityButton;
    }else{
        return nil;
    }
}

-(void)sliderAction:(UIButton *)sender{
    if (self.currentIndex==sender.tag) {
        return;
    }
    [self sliderAnimationWithTag:sender.tag];
    
    [UIView animateWithDuration:0.3 animations:^{
        self->topScrollView.contentOffset = CGPointMake(SCREEN_WIDTH*(sender.tag-1), 0);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)sliderAnimationWithTag:(NSInteger)tag{
    self.currentIndex = tag;
    cityButton.selected = NO;
    attentionButton.selected = NO;
    findButton.selected = NO;
    UIButton *sender = [self buttonWithTag:tag];
    sender.selected = YES;
    //动画
    [UIView animateWithDuration:0.3 animations:^{
        self->sliderLabel.frame = CGRectMake(sender.frame.origin.x, self->sliderLabel.frame.origin.y, self->sliderLabel.frame.size.width, self->sliderLabel.frame.size.height);
        
    } completion:^(BOOL finished) {
    }];
}
-(void)sliderWithTag:(NSInteger)tag{
    self.currentIndex = tag;
    cityButton.selected = NO;
    findButton.selected = NO;
    attentionButton.selected = NO;
    UIButton *sender = [self buttonWithTag:tag];
    sender.selected = YES;
    //动画
    sliderLabel.frame = CGRectMake(sender.frame.origin.x, sliderLabel.frame.origin.y, sliderLabel.frame.size.width, sliderLabel.frame.size.height);
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //实时计算当前位置,实现和titleView上的按钮的联动
    CGFloat contentOffSetX = scrollView.contentOffset.x;
    CGFloat X = contentOffSetX * (3*SCREEN_WIDTH/4)/SCREEN_WIDTH/3;
    CGRect frame = sliderLabel.frame;
    frame.origin.x = X;
    sliderLabel.frame = frame;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat contentOffSetX = scrollView.contentOffset.x;
    int index_ = contentOffSetX/SCREEN_WIDTH;
    [self sliderWithTag:index_+1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    NSLog(@"%s dealloc",object_getClassName(self));
}



@end
