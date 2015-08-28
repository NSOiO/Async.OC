//
//  DPKAsync.h
//  AsyncOCExample
//
//  Created by Deepak on 8/28/15.
//  Copyright (c) 2015 deepak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>


#ifndef Async
#define Async ([[DPKAsync alloc] init])
#endif

#ifndef AsyncBlock
#define AsyncBlock DPKAsync*
#endif


@interface DPKAsync : NSObject

- (DPKAsync *(^)(dispatch_block_t block))main;
- (DPKAsync *(^)(dispatch_block_t block))userInteractive;
- (DPKAsync *(^)(dispatch_block_t block))userInitiated;
- (DPKAsync *(^)(dispatch_block_t block))utility;
- (DPKAsync *(^)(dispatch_block_t block))background;
- (DPKAsync *(^)(dispatch_queue_t customQueue, dispatch_block_t block))customQueue;

- (DPKAsync *(^)(CGFloat after))after;

- (void)cancel;
- (void)wait:(CGFloat)seconds;

@end

