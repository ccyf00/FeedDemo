//
//  FeedCollectionCell.h
//  FeedStreamDemo1
//
//  Created by caiyongfang on 2020/4/7.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ImageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FeedCollectionCell : UICollectionViewCell

@property(nonatomic,strong)ImageModel *model;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *subView;
@property (nonatomic, strong) UILabel *author;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

NS_ASSUME_NONNULL_END
