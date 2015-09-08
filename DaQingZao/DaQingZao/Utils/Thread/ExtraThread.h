//
//  ExtraThread.h
//  CiweiProtect
//
//  Created by 吴启飞 on 14/12/23.
//  Copyright (c) 2014年 吴启飞. All rights reserved.
//

#define FOREGROUND_BEGIN		[ExtraThread enqueueForeground:^{
#define FOREGROUND_BEGIN_(x)	[ExtraThread enqueueForegroundWithDelay:(dispatch_time_t)x block:^{
#define FOREGROUND_COMMIT		}];

#define BACKGROUND_BEGIN		[ExtraThread enqueueBackground:^{
#define BACKGROUND_BEGIN_(x)	[ExtraThread enqueueBackgroundWithDelay:(dispatch_time_t)x block:^{
#define BACKGROUND_COMMIT		}];

#import <Foundation/Foundation.h>
//#import "Header.h"

@interface ExtraThread : NSObject
+ (dispatch_queue_t)foreQueue;
+ (dispatch_queue_t)backQueue;

+ (void)enqueueForeground:(dispatch_block_t)block;
+ (void)enqueueBackground:(dispatch_block_t)block;
+ (void)enqueueForegroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block;
+ (void)enqueueBackgroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block;
@end
