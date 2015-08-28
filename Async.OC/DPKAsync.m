//
//  DPKAsync.m
//  AsyncOCExample
//
//  Created by Deepak on 8/28/15.
//  Copyright (c) 2015 deepak. All rights reserved.
//

#import "DPKAsync.h"

@interface DPKGCD : NSObject
+ (dispatch_queue_t)mainQueue;
+ (dispatch_queue_t)userInteractiveQueue;
+ (dispatch_queue_t)userInitiatedQueue;
+ (dispatch_queue_t)utilityQueue;
+ (dispatch_queue_t)backgroundQueue;
@end

@interface DPKAsync ()
@property (nonatomic, strong) dispatch_block_t block;
@property (nonatomic, assign) CGFloat afterSecondes;
@end

@interface DPKAsyncChain :  DPKAsync
@end

#pragma mark -

@implementation DPKAsync

- (instancetype)initWithBlock:(dispatch_block_t)block
{
    self = [super init];
    if (self) {
        _block = block;
        _afterSecondes = 0.0;
    }
    return self;
}

#pragma mark - Public Method

#define GenerateAsyncMethod(name) \
- (DPKAsync *(^)(dispatch_block_t block))name \
{ \
    return ^DPKAsync* (dispatch_block_t block){ \
        return [self async:block inQueue:[DPKGCD name##Queue] after:self.afterSecondes]; \
    }; \
}
#define GenerateCustomQueueAsyncMethod(name) \
- (DPKAsync *(^)(dispatch_queue_t name, dispatch_block_t block))name \
{ \
    return ^DPKAsync* (dispatch_queue_t name, dispatch_block_t block) { \
        return [self async:block inQueue:name after:self.afterSecondes]; \
    }; \
}
GenerateAsyncMethod(main)
GenerateAsyncMethod(userInteractive)
GenerateAsyncMethod(userInitiated)
GenerateAsyncMethod(utility)
GenerateAsyncMethod(background)
GenerateCustomQueueAsyncMethod(customQueue)

- (DPKAsync * (^)(CGFloat after))after {
    return ^DPKAsync* (CGFloat after) {
        self.afterSecondes = after;
        return self;
    };
}

- (void)cancel
{
    dispatch_block_cancel(self.block);
}

- (void)wait:(CGFloat)seconds
{
    if (seconds != 0.0) {
        int64_t nanoSeconds = (int64_t)(seconds * NSEC_PER_SEC);
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, nanoSeconds);
        dispatch_block_wait(self.block, time);
    } else {
        dispatch_block_wait(self.block, DISPATCH_TIME_FOREVER);
    }
}

#pragma mark - Private Method

- (dispatch_time_t)timeFromNowAfterSeconds:(CGFloat)seconds {
    int64_t nanoSeceonds = (int64_t)(seconds * NSEC_PER_SEC);
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, nanoSeceonds);
    return time;
}

- (DPKAsync *)async:(dispatch_block_t) block inQueue:(dispatch_queue_t)queue after:(CGFloat)seconds
{
    dispatch_block_t cancellableBlock = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, block);
    dispatch_time_t time = [self timeFromNowAfterSeconds:seconds];
    
    !cancellableBlock ?: dispatch_after(time, queue, cancellableBlock);
    
    return [[DPKAsyncChain alloc] initWithBlock:cancellableBlock];
}

@end

@implementation DPKAsyncChain

#pragma mark - Override Method

- (DPKAsync *)async:(dispatch_block_t) chainingBlock inQueue:(dispatch_queue_t)queue after:(CGFloat)seconds {
    dispatch_block_t cancellableChainingBlock = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, chainingBlock);
    
    dispatch_block_t chainingWrapperBlock = ^{
        dispatch_time_t time = [self timeFromNowAfterSeconds:seconds];
        dispatch_after(time, queue, cancellableChainingBlock);
    };
    dispatch_block_t cancellableChainingWrapperBlock = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, chainingWrapperBlock);
    
    dispatch_block_notify(self.block, queue, cancellableChainingWrapperBlock);
    
    return [[DPKAsyncChain alloc] initWithBlock:cancellableChainingBlock];
}

@end

@implementation DPKGCD

+ (dispatch_queue_t)mainQueue
{
    return dispatch_get_main_queue();
    // Don't ever use dispatch_get_global_queue(qos_class_main(), 0) re https://gist.github.com/duemunk/34babc7ca8150ff81844
}

+ (dispatch_queue_t)userInteractiveQueue
{
    return dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0);
}

+ (dispatch_queue_t)userInitiatedQueue
{
    return dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
}


+ (dispatch_queue_t)utilityQueue
{
    return dispatch_get_global_queue(QOS_CLASS_UTILITY, 0);
}

+ (dispatch_queue_t)backgroundQueue
{
    return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0);
}

@end