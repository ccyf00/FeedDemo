//
//  FeedLayoutController.m
//  FeedStreamDemo1
//
//  Created by caiyongfang on 2020/4/7.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "FeedLayoutController.h"

@interface FeedLayoutController ()

@property (nonatomic, assign)CGFloat dicOfHeight;

@property (nonatomic, assign)NSInteger notFull;

@property (nonatomic, strong)NSMutableArray *array;

@property (nonatomic, copy)HeightBlock block;

//@property (nonatomic, assign)CGPDFInteger count;

@end

@implementation FeedLayoutController

-(instancetype)init{
    self = [super init];
    if(self){
        _lineNumber = 2;
        _rowSpacing = 10.0f;
        _lineSpacing = 10.0f;
        _sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _dicOfHeight = 0;
        _array = [NSMutableArray array];
        _notFull = -1;
//        _count = 0;
    }
    return self;
}

-(void) prepareLayout{
    [super prepareLayout];
//    if (_count == 0) {
//        self.dicOfHeight = self.sectionInset.top;
//    }
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_count inSection:0];
//    [self.array addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
//    _count ++;
//    _loadCount++;
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    self.dicOfHeight = self.sectionInset.top;
    if (isnan(self.dicOfHeight)) {
        self.dicOfHeight = 0;
    }
    self.notFull = -1;
    [self.array removeAllObjects];
    for (NSInteger i=0; i<count;i++){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [self.array addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
}


-(CGSize) collectionViewContentSize{
   
    CGFloat height =_dicOfHeight + _sectionInset.bottom;
    NSLog(@"collectionViewContentHeight %f", height);
    if( isnan(height) ) {
        height = 0;
    }
    return CGSizeMake(self.collectionView.bounds.size.width, height);
}


-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return _array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //通过indexPath创建一个item属性attr
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //计算item宽
    CGFloat itemWidth;
    CGFloat itemHight;
    //计算item高
    ImageModel *model = [[ImageModel alloc]init];
    if (self.block != nil) {
        model = self.block(indexPath);
    } else {
        NSLog(@"Please implement computeIndexCellHeightWithWidthBlock Method");
        //assert
    }
    CGRect frame;
    if (model.imageWidth>= 1000) {
        itemWidth = self.collectionView.bounds.size.width - (self.sectionInset.left + self.sectionInset.right);
        frame.origin = CGPointMake(self.sectionInset.left,_dicOfHeight);
        itemHight = model.imageHeight*(itemWidth/model.imageWidth);
        self.dicOfHeight += itemHight + self.rowSpacing;
    }else{
        itemWidth = (self.collectionView.bounds.size.width - (self.sectionInset.left + self.sectionInset.right) - (self.lineNumber - 1) * self.lineSpacing) / self.lineNumber;
        itemHight = model.imageHeight*(itemWidth/model.imageWidth);
        if(self.notFull!=-1){
            UICollectionViewLayoutAttributes *attr = [self.array objectAtIndex:_notFull];
            itemHight = attr.frame.size.height;
            frame.origin = CGPointMake(self.sectionInset.left+itemWidth+self.lineSpacing,attr.frame.origin.y);
            self.notFull = -1;
        }else{
            self.notFull = indexPath.row;
       
            frame.origin = CGPointMake(self.sectionInset.left,self.dicOfHeight);
            self.dicOfHeight += itemHight + self.rowSpacing;
        }
    }
    if (isnan(self.dicOfHeight)) {
        self.dicOfHeight = 0;
    }
   
    
    //计算item的frame
    
    frame.size = CGSizeMake(itemWidth, itemHight);
    NSLog(@"layoutAttributesForItemAtIndexPath");

    attr.frame = frame;
    return attr;
}

-(void)computeIndexCellHeightWithWidthBlock:(ImageModel* (^)(NSIndexPath * _Nonnull))block{
    if(self.block!=block){
        self.block = block;
    }
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{

//    CGFloat oldWidth = self.collectionView.bounds.size.width;
//    return oldWidth != newBounds.size.width;
    
    return YES;
}

@end
