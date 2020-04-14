//
//  ImageModel.m
//  FeedStreamDemo1
//
//  Created by caiyongfang on 2020/4/7.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "ImageModel.h"

@implementation ImageModel

- (BOOL)isEqual:(ImageModel *)object {
    if (object && [object isKindOfClass:[ImageModel class]]) {
        return [_title isEqualToString:object.title] && [_author isEqualToString:object.author];
    }
    return NO;
}

- (NSUInteger)hash {
    return [_title hash] ^ [_author hash];
}
@end
