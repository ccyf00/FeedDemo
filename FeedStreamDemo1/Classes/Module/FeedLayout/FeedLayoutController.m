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

//@property (nonatomic, assign)NSInteger loadCount;
//
//@property (nonatomic, assign)CGFloat preHeight;


@end

@implementation FeedLayoutController

-(instancetype)init{
    self = [super init];
    if(self){
        self.lineNumber = 2;
        self.rowSpacing = 10.0f;
        self.lineSpacing = 10.0f;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _dicOfHeight = 0;
        _array = [NSMutableArray array];
        _notFull = -1;
        //        _loadCount = 0;
    }
    return self;
}

-(void)prepareLayout{
    [super prepareLayout];
    //    _loadCount++;
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    _dicOfHeight = self.sectionInset.top;
    _notFull = -1;
    [_array removeAllObjects];
    for (NSInteger i=0; i<count;i++){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [_array addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
}


-(CGSize)collectionViewContentSize{
   
    CGFloat height =_dicOfHeight + _sectionInset.bottom;
    //    if(_loadCount == 1){
    //        _preHeight = height;
    //    }else if (_loadCount >= 2) {
    //        height -= _preHeight;
    //    }
    return CGSizeMake(self.collectionView.bounds.size.width, height);
}


-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return _array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //通过indexPath创建一个item属性attr
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //计算item宽
    CGFloat itemW;
    CGFloat itemH;
    //计算item高
    ImageModel *model = [[ImageModel alloc]init];
    if (self.block != nil) {
        model = self.block(indexPath);
    } else {
        NSLog(@"Please implement computeIndexCellHeightWithWidthBlock Method");
    }
    CGRect frame;
    if (model.imgWidth>= 1200) {
        itemW = self.collectionView.bounds.size.width - (self.sectionInset.left + self.sectionInset.right);
        frame.origin = CGPointMake(self.sectionInset.left,_dicOfHeight);
         itemH = model.imgHeight*(itemW/model.imgWidth);
        _dicOfHeight += itemH + self.rowSpacing;
    }else{
        itemW = (self.collectionView.bounds.size.width - (self.sectionInset.left + self.sectionInset.right) - (self.lineNumber - 1) * self.lineSpacing) / self.lineNumber;
        itemH = model.imgHeight*(itemW/model.imgWidth);
        if(_notFull!=-1){
            UICollectionViewLayoutAttributes *attr = [_array objectAtIndex:_notFull];
            itemH = attr.frame.size.height;
            frame.origin = CGPointMake(self.sectionInset.left+itemW+self.lineSpacing,attr.frame.origin.y);
            _notFull = -1;
        }else{
            _notFull = indexPath.row;
       
            frame.origin = CGPointMake(self.sectionInset.left,_dicOfHeight);
            _dicOfHeight += itemH + self.rowSpacing;
        }
    }
   
    
    //计算item的frame
    
    frame.size = CGSizeMake(itemW, itemH);
    
    attr.frame = frame;
    return attr;
}

-(void)computeIndexCellHeightWithWidthBlock:(ImageModel* (^)(NSIndexPath * _Nonnull))block{
    if(self.block!=block){
        self.block = block;
    }
}

@end
