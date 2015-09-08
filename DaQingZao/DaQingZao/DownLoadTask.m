//
//  DownLoadTask.m
//  DaQingZao
//
//  Created by 吴启飞 on 15/4/7.
//  Copyright (c) 2015年 吴启飞. All rights reserved.
//

#import "DownLoadTask.h"
#import <AFNetworking/AFNetworking.h>

@interface DownLoadTask ()
{
    NSURLRequest *_request;
    AFHTTPRequestOperation *_afOperation;
}
@end
@implementation DownLoadTask

-(id)initWithUrl:(NSString *)url
{
    if(!url)
        return nil;
    self = [super init];
    if(!self)
        return nil;
    
    __weak DownLoadTask *weakSelf = self;
    _url =url;
    _request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    _afOperation = [[AFHTTPRequestOperation alloc]initWithRequest:_request];
    [_afOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        weakSelf.downLoadProgross = (double)totalBytesRead/totalBytesExpectedToRead;
//        NSLog(@"-----progress %d",weakSelf.downLoadProgross);
        weakSelf.bytesProgress = [NSString stringWithFormat:@"%@/%@", [weakSelf formatByteCount:totalBytesRead], [weakSelf formatByteCount:totalBytesExpectedToRead]];
    }];
    [_afOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        weakSelf.bytesTotal = [weakSelf formatByteCount:operation.response.expectedContentLength];
        weakSelf.isCompleted = YES;
        weakSelf.downLoadProgross = 1;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        weakSelf.error = error.localizedDescription;
        weakSelf.isCompleted = YES;
    }];
    return self;
}

- (void)start
{
    [_afOperation start];
}

- (void)stop
{
    [_afOperation cancel];
}

- (NSString*)formatByteCount:(long long)size
{
    return [NSByteCountFormatter stringFromByteCount:size countStyle:NSByteCountFormatterCountStyleFile];
}


@end
