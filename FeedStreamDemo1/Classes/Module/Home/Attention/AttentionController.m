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
#import <SDImageCache.h>



@interface AttentionController ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDataSourcePrefetching>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) FeedLayoutController *feedLayout;
@property (nonatomic, strong) NSMutableDictionary *cellDic;

@end

#define IMAGE_API(page) [NSString stringWithFormat:@"https://gank.io/api/v2/data/category/Girl/type/Girl/page/%ld/count/10", (long)page];
@implementation AttentionController{
    NSMutableArray *modelArray;
    NSInteger page;
}


- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    page = 1;
    _cellDic = [[NSMutableDictionary alloc] init];
    NSString *urlStr = IMAGE_API(page);
    page++;
    self->modelArray = [NSMutableArray array];
    [self createSubView];
    [self drawUI];

    [self getImageDetailWithURL:urlStr];
//    NSMutableArray *array = [self getImagesWithURL:urlStr];
//
//    [self setModelDetail:array];
    
}

//- (NSMutableArray *) getImagesWithURL:(NSString *)urlStr{
//    __block NSMutableArray *array = [[NSMutableArray alloc]init];
//    NSURL *url = [NSURL URLWithString:urlStr];
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//    NSURLSession *session = [NSURLSession sharedSession];
//    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//        NSLog(@"%@",dict);
//        array = [dict[@"data"] mutableCopy];
//        dispatch_semaphore_signal(semaphore);
//    }]resume];
//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    return array;
//}

- (void) getImageDetailWithURL:(NSString *)urlStr{
    __block NSMutableArray *array = [[NSMutableArray alloc]init];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            array = [dict[@"data"] mutableCopy];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                for(NSDictionary *dic in array){
                    ImageModel *imgModel = [[ImageModel alloc]init];
                    imgModel.title = dic[@"desc"];
                    imgModel.imageURL = dic[@"images"][0];
                    imgModel.dateStr = [dic[@"publishedAt"] componentsSeparatedByString:@" "][0];
                    imgModel.author = dic[@"author"];
                    [[[SDWebImageManager sharedManager] imageCache] queryImageForKey:imgModel.imageURL options:SDWebImageQueryMemoryDataSync | SDWebImageQueryDiskDataSync | SDWebImageFromCacheOnly context:nil completion:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
                        if (image) {
                            imgModel.imageHeight = image.size.height;
                            imgModel.imageWidth = image.size.width;
                        } else {
                            imgModel.imageHeight = 1000;
                            imgModel.imageWidth = 500;
                        }
                    }];

                    [self->modelArray addObject:imgModel];
                }
                [self.collectionView reloadData];
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView.mj_header endRefreshing];

            });
        }
        
        }]resume];

}

- (void)loadMore{
    NSString *urlStr = IMAGE_API(page);
    page++;
    [self getImageDetailWithURL:urlStr];
    [self.collectionView.mj_footer endRefreshing];
}

- (void)loadData{
    page = 1;
    NSString *urlStr = IMAGE_API(page);
    page ++;
    [modelArray removeAllObjects];

    [self getImageDetailWithURL:urlStr];
    
}


- (void)createSubView{
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

- (void)drawUI{
    
    //下拉刷新
    MJRefreshHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.collectionView.mj_header = header;
    
    //上拉加载更多
    MJRefreshFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    self.collectionView.mj_footer = footer;
    
}

- (void) computeIndexCellHeight{
    [self.feedLayout computeIndexCellHeightWithWidthBlock:^ImageModel*(NSIndexPath * indexPath) {
        if ([self->modelArray count] > indexPath.row) {
            ImageModel *model = self->modelArray[indexPath.row];
            return model;
        }
        return nil;
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return modelArray.count;
}

//- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
//    for (NSIndexPath *index in indexPaths) {
//        ImageModel *model = modelArray[index.row];
//        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:model.imageURL] options:SDWebImageHighPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
//
//        }];
//    }
//
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//     每次先从字典中根据IndexPath取出唯一标识符
//    NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
//    // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
//    if (identifier == nil) {
//        identifier = [NSString stringWithFormat:@"%@%@", @"feedCollectionCell", [NSString stringWithFormat:@"%@", indexPath]];
//        [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
//        // 注册Cell
//        [self.collectionView registerClass:[FeedCollectionCell class]  forCellWithReuseIdentifier:identifier];
//    }
//
//    FeedCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//
    // 复用cell，dequeueReusableCellWithReuseIdentifier 获得一个重用的cell，若无cell，系统创建一个cell
    FeedCollectionCell *cell = (FeedCollectionCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"feedCollectionCell" forIndexPath:indexPath];
    
    ImageModel *model = modelArray[indexPath.row];
    cell.model = model;

    NSLog(@"cell");
    __weak  __typeof(self) weakSelf = self;;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:cell.model.imageURL] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (cacheType != SDImageCacheTypeNone) {

            model.imageHeight = image.size.height;
            model.imageWidth = image.size.width;
        
        }
        
        
        if (indexPath.row != [self.collectionView indexPathForCell:cell].row) {
            return;
        }
        
        if (cacheType == SDImageCacheTypeNone) {
            NSArray<NSIndexPath *> *array = [strongSelf.collectionView indexPathsForVisibleItems];
            for (NSIndexPath *pindexPath in array) {
                if (indexPath.row == pindexPath.row) {
                    [strongSelf.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                }
            }
        }
    }];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了第%ld个item",indexPath.row);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


@end
