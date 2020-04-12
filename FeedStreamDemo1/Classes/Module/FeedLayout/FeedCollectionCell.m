//
//  FeedCollectionCell.m
//  FeedStreamDemo1
//
//  Created by caiyongfang on 2020/4/7.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "FeedCollectionCell.h"
#import "UIImageView+WebCache.h"
#import <SDWebImage/SDWebImage.h>

@interface FeedCollectionCell ()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *subView;
@property (nonatomic, strong) UILabel *author;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end
@implementation FeedCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self createSubVIew];
    }
    return self;
}

//-(void)prepareForReuse{
//    [super prepareForReuse];
//}


-(void)createSubVIew{
    _imageView = [[UIImageView alloc]init];
  
    [self addSubview:_imageView];
    _label =[[UILabel alloc]init];
    
    _label.font = [UIFont systemFontOfSize:14];
    _label.textColor = [UIColor blackColor];
    _label.textAlignment = NSTextAlignmentLeft;
    _label.numberOfLines = 0;
    [self addSubview:_label];
    
    _subView = [[UIView alloc]init];

    _avatarImageView  = [[UIImageView alloc]init];
   
    [_subView addSubview:_avatarImageView];
    
    _author =[[UILabel alloc]init];
  
    _author.font = [UIFont systemFontOfSize:14];
    _author.textColor = [UIColor blackColor];
    _author.textAlignment = NSTextAlignmentLeft;
    [_subView addSubview:_author];
    
    _timeLabel =[[UILabel alloc]init];
    _timeLabel.tag=50;
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.textColor = [UIColor blackColor];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [_subView addSubview:_timeLabel];
   
    [self addSubview:_subView];
    
}

-(void)setModel:(ImageModel *)model{
   
    _model = model;
    
    _label.backgroundColor = [UIColor whiteColor];
    _label.text = model.title;
    CGSize labelSize = [_label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_label.font, NSFontAttributeName,nil]];
    
    _imageView.frame = CGRectMake(self.bounds.origin.x,self.bounds.origin.y,
                            self.bounds.size.width,self.bounds.size.height-labelSize.height-45);
    NSString *name = [NSString stringWithFormat:@"%@.png",model.imgURL];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_model.imgURL] placeholderImage:[UIImage imageNamed:name]];
    
    
    _label.frame = CGRectMake(0, self.frame.size.height-labelSize.height-40, self.frame.size.width, labelSize.height);
    _subView.frame = CGRectMake(0,self.frame.size.height-40, self.frame.size.width, 40);
    _avatarImageView.frame = CGRectMake(0,0,40,40);
    _avatarImageView.layer.cornerRadius = 40/2;
    _avatarImageView.layer.masksToBounds = YES;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:_model.imgURL] placeholderImage:[UIImage imageNamed:name]];
    _timeLabel.text = model.dateStr;
    _timeLabel.frame = CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, 40);
    
    _author.text = model.author;
    _author.frame = CGRectMake(40, 0, self.frame.size.width/2-40, 40);
   
    
}

@end
