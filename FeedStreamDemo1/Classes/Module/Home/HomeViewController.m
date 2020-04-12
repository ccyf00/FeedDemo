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
    CityController* city;
    AttentionController* attention;
    FindController* find;
    UIScrollView* topScrollView;
    UIView* navView;
    UILabel* sliderLabel;
    UIButton* cityBtn;
    UIButton* attentionBtn;
    UIButton* findBtn;
}

@end
#define kScreenWidth [UIScreen mainScreen].bounds.size.width



@implementation HomeViewController

-(CityController *)city{
    if(city == nil){
        city = [[CityController alloc]init];
        city.navigationController = self.navigationController;
    }
    return city;
}

-(AttentionController *)attention{
    if(attention==nil){
        attention = [[AttentionController alloc]init];
        attention.navigationController = self.navigationController;
    }
    return attention;
}

-(FindController *)find{
    if(find==nil){
        find = [[FindController alloc]init];
        find.navigationController = self.navigationController;
    }
    return find;
}

- (void)initUI {
    
    CGFloat viewWidthLeft = kScreenWidth / 4;
    
    navView = [[UIView alloc]initWithFrame:CGRectMake(viewWidthLeft/2, 0, kScreenWidth-viewWidthLeft, 40)];
    
    CGFloat buttonWidth = kScreenWidth-viewWidthLeft;
    
    attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [attentionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [attentionBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    attentionBtn.frame = CGRectMake(0, 0, buttonWidth/3, navView.frame.size.height);
    attentionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [attentionBtn addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
    attentionBtn.tag = 1;
    attentionBtn.selected = YES;
    [navView addSubview:attentionBtn];
    
    findBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    findBtn.frame = CGRectMake(attentionBtn.frame.origin.x+attentionBtn.frame.size.width, attentionBtn.frame.origin.y, buttonWidth/3, navView.frame.size.height);
    [findBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [findBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    findBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [findBtn addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [findBtn setTitle:@"发现" forState:UIControlStateNormal];
    findBtn.tag = 2;
    [navView addSubview:findBtn];
    
    
    cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cityBtn.frame = CGRectMake(findBtn.frame.origin.x+findBtn.frame.size.width, findBtn.frame.origin.y, buttonWidth/3, navView.frame.size.height);
    [cityBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    cityBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [cityBtn addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [cityBtn setTitle:@"同城" forState:UIControlStateNormal];
    cityBtn.tag = 3;
    [navView addSubview:cityBtn];
    
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
    topScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.frame.size.height)];
    topScrollView.delegate = self;
    topScrollView.backgroundColor = [UIColor whiteColor];
    topScrollView.pagingEnabled = YES;
    topScrollView.showsHorizontalScrollIndicator = NO;
    topScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:topScrollView];
    
    NSArray *views = @[self.attention.view,self.find.view,self.city.view];
    for (NSInteger i = 0; i<views.count; i++) {
        //把三个vc的view依次贴到mainScrollView上面
        UIView *pageView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth*i, 0, topScrollView.frame.size.width, topScrollView.frame.size.height-100)];
        [pageView addSubview:views[i]];
        [topScrollView addSubview:pageView];
    }
    topScrollView.contentSize = CGSizeMake(kScreenWidth*(views.count), 0);
    //滚动到_currentIndex对应的tab
    [topScrollView setContentOffset:CGPointMake((topScrollView.frame.size.width)*_currentIndex, 0) animated:YES];
}

-(UIButton *)buttonWithTag:(NSInteger )tag{
    if (tag==1) {
        return attentionBtn;
    }else if (tag==2){
        return findBtn;
    }else if (tag==3){
        return cityBtn;
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
        self->topScrollView.contentOffset = CGPointMake(kScreenWidth*(sender.tag-1), 0);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)sliderAnimationWithTag:(NSInteger)tag{
    self.currentIndex = tag;
    cityBtn.selected = NO;
    attentionBtn.selected = NO;
    findBtn.selected = NO;
    UIButton *sender = [self buttonWithTag:tag];
    sender.selected = YES;
    //动画
    [UIView animateWithDuration:0.3 animations:^{
        self->sliderLabel.frame = CGRectMake(sender.frame.origin.x, self->sliderLabel.frame.origin.y, self->sliderLabel.frame.size.width, self->sliderLabel.frame.size.height);
        
    } completion:^(BOOL finished) {
        //        self->cityBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        //        self->attentionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        //        self->findBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        //        sender.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    }];
}
-(void)sliderWithTag:(NSInteger)tag{
    self.currentIndex = tag;
    cityBtn.selected = NO;
    findBtn.selected = NO;
    attentionBtn.selected = NO;
    UIButton *sender = [self buttonWithTag:tag];
    sender.selected = YES;
    //动画
    sliderLabel.frame = CGRectMake(sender.frame.origin.x, sliderLabel.frame.origin.y, sliderLabel.frame.size.width, sliderLabel.frame.size.height);
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //实时计算当前位置,实现和titleView上的按钮的联动
    CGFloat contentOffSetX = scrollView.contentOffset.x;
    CGFloat X = contentOffSetX * (3*kScreenWidth/4)/kScreenWidth/3;
    CGRect frame = sliderLabel.frame;
    frame.origin.x = X;
    sliderLabel.frame = frame;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat contentOffSetX = scrollView.contentOffset.x;
    int index_ = contentOffSetX/kScreenWidth;
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
