//
//  AttentionController.m
//  FeedStreamDemo1
//
//  Created by caiyongfang on 2020/4/5.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "AttentionController.h"

#import "UIImageView+WebCache.h"
#import "FeedLayoutController.h"
#import "FeedCollectionCell.h"
#import <ImageIO/ImageIO.h>
#import "AFNetworking.h"
#import "ImageModel.h"
#import <MJRefresh/MJRefresh.h>
#import "NetWorkUtil.h"
#import <SDImageCache.h>



@interface AttentionController ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDataSourcePrefetching>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) FeedLayoutController *feedLayout;
@property (nonatomic, strong) NSMutableDictionary *cellDic;

@end
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
@implementation AttentionController{
    NSMutableArray *modelArray;
    NSInteger page;
}


- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    self.cellDic = [[NSMutableDictionary alloc] init];
    page = 1;
    NSString *urlStr = [NSString stringWithFormat:@"https://gank.io/api/v2/data/category/Girl/type/Girl/page/%ld/count/10", (long)page];
    page++;
    NSMutableArray *array = [self getImagesWithURL:urlStr];
    self->modelArray = [NSMutableArray array];
    NSLog(@"...");
//    for(NSDictionary *dic in array){
//
//        [self addObjectToImgModel:dic];
//    }
    [self setModelDetail:array];
    NSLog(@".....");
    [self createSubView];
    [self drawUI];
    
}

- (NSMutableArray *) getImagesWithURL:(NSString *)urlStr{
    __block NSMutableArray *array = [[NSMutableArray alloc]init];
    NSURL *url = [NSURL URLWithString:urlStr];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@",dict);
        array = [dict[@"data"] mutableCopy];
        dispatch_semaphore_signal(semaphore);
    }]resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return array;
}

-(void) setModelDetail:(NSMutableArray*) array{
    NSLog(@"开始获取图片");
    for(NSDictionary *dic in array){
        ImageModel *imgModel = [[ImageModel alloc]init];
        imgModel.title = dic[@"desc"];
        imgModel.imgURL = dic[@"images"][0];
        imgModel.dateStr = [dic[@"publishedAt"] componentsSeparatedByString:@" "][0];
        imgModel.author = dic[@"author"];
//        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSURLSession *session = [NSURLSession sharedSession];
        NSURL *url = [NSURL URLWithString:imgModel.imgURL];
        __weak __typeof(self) weakSelf = self;
        [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            
            NSURL *finalURL = response.URL;
            CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)finalURL, NULL);
            NSDictionary* imageHeader = (__bridge NSDictionary*) CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
            NSLog(@"%@",imageHeader);
            imgModel.imgHeight = [imageHeader[@"PixelHeight"] floatValue];
            imgModel.imgWidth = [imageHeader[@"PixelWidth"] floatValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf->modelArray addObject:imgModel];
                [strongSelf.collectionView reloadData];
            });
        }]resume];
    }
   
    
}



-(void)loadMore{
  
    NSString *urlStr = [NSString stringWithFormat:@"https://gank.io/api/v2/data/category/Girl/type/Girl/page/%ld/count/10", (long)page];
    page++;
    
    NSMutableArray *array = [self getImagesWithURL:urlStr];
    [self setModelDetail:array];
   
    [self.collectionView layoutSubviews];
    [self.collectionView.mj_footer endRefreshing];
}

-(void)loadData{
    page = 1;
    NSString *urlStr = @"https://gank.io/api/v2/data/category/Girl/type/Girl/page/1/count/10";
    page ++;
    
    NSMutableArray *array = [self getImagesWithURL:urlStr];
   
    [self refresh:array];
}

-(void) refresh:(NSMutableArray *)array{
    NSLog(@"开始获取图片");
    [modelArray removeAllObjects];
    dispatch_group_t group = dispatch_group_create();
    
    for(NSDictionary *dic in array){
        ImageModel *imgModel = [[ImageModel alloc]init];
        imgModel.title = dic[@"desc"];
        imgModel.imgURL = dic[@"images"][0];
        imgModel.dateStr = [dic[@"publishedAt"] componentsSeparatedByString:@" "][0];
        imgModel.author = dic[@"author"];
        //        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSURLSession *session = [NSURLSession sharedSession];
        NSURL *url = [NSURL URLWithString:imgModel.imgURL];
        __weak __typeof(self) weakSelf = self;
        
        dispatch_group_enter(group);
        
        [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            
            NSURL *finalURL = response.URL;
            CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)finalURL, NULL);
            NSDictionary* imageHeader = (__bridge NSDictionary*) CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
            NSLog(@"%@",imageHeader);
            imgModel.imgHeight = [imageHeader[@"PixelHeight"] floatValue];
            imgModel.imgWidth = [imageHeader[@"PixelWidth"] floatValue];
            [strongSelf->modelArray addObject:imgModel];

            dispatch_group_leave(group);
        }]resume];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];

    });
    
}

-(void)addObjectToImgModel:(NSDictionary *)dic{
    
    ImageModel *imgModel = [[ImageModel alloc]init];
    imgModel.title = dic[@"desc"];
    imgModel.imgURL = dic[@"images"][0];
    imgModel.dateStr = [dic[@"publishedAt"] componentsSeparatedByString:@" "][0];
    imgModel.author = dic[@"author"];
    
    NSURL *finalURL = [NetWorkUtil getRedirectURL:imgModel.imgURL];
    imgModel.imgURL=finalURL.absoluteString;
    
    NSDictionary* imageHeader = [NetWorkUtil getImageHeaderWithURL:finalURL];
   
    imgModel.imgHeight = [imageHeader[@"PixelHeight"] floatValue];
    imgModel.imgWidth = [imageHeader[@"PixelWidth"] floatValue];
    [self->modelArray addObject:imgModel];
}



-(void)createSubView{
    self.feedLayout = [[FeedLayoutController alloc]init];
    self.feedLayout.lineNumber = 2;
    self.feedLayout.rowSpacing = 5;
    self.feedLayout.lineSpacing = 5;
    self.feedLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-160) collectionViewLayout:self.feedLayout];
    [self.collectionView registerClass:[FeedCollectionCell class] forCellWithReuseIdentifier:@"feedCollectionCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.prefetchDataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self computeIndexCellHeight];

}

-(void)drawUI{
    
    
    //下拉刷新
    MJRefreshHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.collectionView.mj_header = header;
    
    //上拉加载更多
    MJRefreshFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    self.collectionView.mj_footer = footer;
    
    
}

-(void) computeIndexCellHeight{
    NSLog(@"开始计算高度");
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        [self.feedLayout computeIndexCellHeightWithWidthBlock:^ImageModel*(NSIndexPath * indexPath) {
            ImageModel *model = self->modelArray[indexPath.row];
//            CGFloat oldWidth = model.imgWidth;
//            CGFloat oldHeight = model.imgHeight;
//            CGFloat newWidth = width;
//            CGFloat newHeight = oldHeight*newWidth/oldWidth;
            return model;
        }];
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            NSLog(@"高度计算完成");
        });
    });
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return modelArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    for (NSIndexPath *index in indexPaths) {
        ImageModel *model = modelArray[index.row];
        UIImageView* imageView = [[UIImageView alloc]init];
        NSString *name = [NSString stringWithFormat:@"%@.png",model.imgURL];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.imgURL] placeholderImage:[UIImage imageNamed:name]];
        
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 每次先从字典中根据IndexPath取出唯一标识符
       NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
       // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
       if (identifier == nil) {
           identifier = [NSString stringWithFormat:@"%@%@", @"feedCollectionCell", [NSString stringWithFormat:@"%@", indexPath]];
           [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
           // 注册Cell
           [self.collectionView registerClass:[FeedCollectionCell class]  forCellWithReuseIdentifier:identifier];
       }
       
       FeedCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    
    // 复用cell，dequeueReusableCellWithReuseIdentifier 获得一个重用的cell，若无cell，系统创建一个cell
//    FeedCollectionCell *cell = (FeedCollectionCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"feedCollectionCell" forIndexPath:indexPath];
    
    cell.model = modelArray[indexPath.row];

    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了第%ld个item",indexPath.row);
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
