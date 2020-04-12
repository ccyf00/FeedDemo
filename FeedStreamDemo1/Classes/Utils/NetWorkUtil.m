//
//  NetWorkUtil.m
//  FeedStreamDemo1
//
//  Created by caiyongfang on 2020/4/9.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "NetWorkUtil.h"
#import <ImageIO/ImageIO.h>
#import "AFNetworking.h"

@implementation NetWorkUtil

+(NSURL *)getRedirectURL:(NSString *)urlStr{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURL * url = [NSURL URLWithString: urlStr];
    __block NSURL *finalURL = [[NSURL alloc]init];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        finalURL = response.URL;
        dispatch_semaphore_signal(semaphore);
    }]resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
//    NSURL *finalURL = response.URL;
    return finalURL;
}

+(NSDictionary*)getImageHeaderWithURL:(NSURL *)url{
    CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    return (__bridge NSDictionary*) CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
}

+(NSMutableArray*)getDataFromURL:(NSString *)urlStr{
    __block NSMutableArray *array = [[NSMutableArray alloc]init];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
      

    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@",dict);
        array = [dict[@"data"] mutableCopy];
        dispatch_semaphore_signal(semaphore);
         NSLog(@"********");
    }]resume];
   dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"****");
    return array;
}

@end
