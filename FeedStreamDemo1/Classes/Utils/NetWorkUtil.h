//
//  NetWorkUtil.h
//  FeedStreamDemo1
//
//  Created by caiyongfang on 2020/4/9.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetWorkUtil : NSObject

+(NSURL *)getRedirectURL:(NSString *)urlStr;
+(NSDictionary*)getImageHeaderWithURL:(NSURL *)url;
+(NSMutableArray*)getDataFromURL:(NSString *)urlStr;
@end

NS_ASSUME_NONNULL_END
