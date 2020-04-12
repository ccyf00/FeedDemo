//
//  FeedLayoutController.h
//  FeedStreamDemo1
//
//  Created by caiyongfang on 2020/4/7.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageModel.h"

typedef ImageModel*(^HeightBlock) (NSIndexPath* indexPath);

NS_ASSUME_NONNULL_BEGIN

@interface FeedLayoutController : UICollectionViewLayout

@property (nonatomic, assign)NSInteger lineNumber;

@property (nonatomic, assign)CGFloat rowSpacing;

@property (nonatomic, assign)CGFloat lineSpacing;

@property (nonatomic, assign)UIEdgeInsets sectionInset;

-(void)computeIndexCellHeightWithWidthBlock:(ImageModel*(^)(NSIndexPath *indexPath))block;

@end

NS_ASSUME_NONNULL_END
