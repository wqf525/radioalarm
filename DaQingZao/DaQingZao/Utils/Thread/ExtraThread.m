//
//  ExtraThread.m
//  CiweiProtect
//
//  Created by 吴启飞 on 14/12/23.
//  Copyright (c) 2014年 吴启飞. All rights reserved.
//
#import "ExtraThread.h"

@interface ExtraThread ()
{
    dispatch_queue_t _foreQueue;
    dispatch_queue_t _backQueue;
}
AS_SINGLETON(ExtraThread)
@end

@implementation ExtraThread
DEF_SINGLETON(ExtraThread)

- (id)init
{
    self = [super init];
    if ( self ){
        _foreQueue = dispatch_get_main_queue();
        _backQueue = dispatch_queue_create( "com.WQF.TaskQueue", nil );
    }
    
    return self;
}

+ (dispatch_queue_t)foreQueue{
    return [[ExtraThread sharedInstance] foreQueue];
}

- (dispatch_queue_t)foreQueue{
    return _foreQueue;
}

+ (dispatch_queue_t)backQueue{
    return [[ExtraThread sharedInstance] backQueue];
}

- (dispatch_queue_t)backQueue{
    return _backQueue;
}

+ (void)enqueueForeground:(dispatch_block_t)block{
    return [[ExtraThread sharedInstance] enqueueForeground:block];
}

- (void)enqueueForeground:(dispatch_block_t)block{
    dispatch_async( _foreQueue, block );
}

+ (void)enqueueBackground:(dispatch_block_t)block{
    return [[ExtraThread sharedInstance] enqueueBackground:block];
}

- (void)enqueueBackground:(dispatch_block_t)block{
    dispatch_async( _backQueue, block );
}

+ (void)enqueueForegroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block{
    [[ExtraThread sharedInstance] enqueueForegroundWithDelay:ms block:block];
}

- (void)enqueueForegroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, ms * USEC_PER_SEC);
    dispatch_after( time, _foreQueue, block );
}

+ (void)enqueueBackgroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block{
    [[ExtraThread sharedInstance] enqueueBackgroundWithDelay:ms block:block];
}

- (void)enqueueBackgroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, ms * USEC_PER_SEC);
    dispatch_after( time, _backQueue, block );
}
@end
