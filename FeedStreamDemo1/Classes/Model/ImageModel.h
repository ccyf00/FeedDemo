//
//  ImageModel.h
//  FeedStreamDemo1
//
//  Created by caiyongfang on 2020/4/7.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageModel : NSObject

@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *imgURL;
@property (nonatomic,assign)CGFloat imgWidth;
@property (nonatomic,assign)CGFloat imgHeight;
@property (nonatomic,strong)NSString* dateStr;
@property (nonatomic,strong)NSString* author;

@end

NS_ASSUME_NONNULL_END
