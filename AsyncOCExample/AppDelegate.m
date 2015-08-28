//
//  AppDelegate.m
//  AsyncOCExample
//
//  Created by Deepak on 8/28/15.
//  Copyright (c) 2015 deepak. All rights reserved.
//

#import "AppDelegate.h"
#import "DPKAsync.h"

static NSString* qd(qos_class_t qt);

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /*
    // Async syntactic sugar
    Async.background(^{
        NSLog(@"A: This is run on the background");
    }).main(^{
        NSLog(@"B: This is run on the , after the previous block");
    });
    */
    
    // Regular GCD
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSLog(@"A: This is run on the background");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"B: This is run on the , after the previous block");
        });
    });
    */
    /*
    // chaining with Async
    __block NSInteger cnt = 0;
    Async.main(^{
        NSLog(@"Tis is run on the %@ (expeted %@) count:%zd (expected 1)",qd(qos_class_self()),qd(qos_class_main()),++cnt);
        // Prints: "This is run on the Main (expected Main) count: 1 (expected 1)"
    }).userInteractive(^{
        NSLog(@"Tis is run on the %@ (expeted %@) count:%zd (expected 2)",qd(qos_class_self()),qd(QOS_CLASS_USER_INTERACTIVE),++cnt);
        // Prints: "This is run on the Main (expected Main) count: 2 (expected 2)"
    }).userInitiated(^{
        NSLog(@"Tis is run on the %@ (expeted %@) count:%zd (expected 3)",qd(qos_class_self()),qd(QOS_CLASS_USER_INITIATED),++cnt);
        // Prints: "This is run on the Main (expected Main) count: 3 (expected 3)"
    }).utility(^{
        NSLog(@"Tis is run on the %@ (expeted %@) count:%zd (expected 4)",qd(qos_class_self()),qd(QOS_CLASS_UTILITY),++cnt);
        // Prints: "This is run on the Main (expected Main) count: 4 (expected 4)"
    }).background(^{
        NSLog(@"Tis is run on the %@ (expeted %@) count:%zd (expected 5)",qd(qos_class_self()),qd(QOS_CLASS_BACKGROUND),++cnt);
        // Prints: "This is run on the Main (expected Main) count: 5 (expected 5)"
    });
     */
    
    /*
    // Keep reference for block for later chaining
    AsyncBlock backgroundBlock = Async.background(^{
        NSLog(@"This is run on the %@ (expeted %@) ",qd(qos_class_self()),qd(QOS_CLASS_BACKGROUND));
    });
    // Run other code here...
    backgroundBlock.main(^{
         NSLog(@"Tis is run on the %@ (expeted %@)",qd(qos_class_self()),qd(qos_class_main()));
    });
    */
    
    /*
    // Custom queues
    dispatch_queue_t customQueue = dispatch_queue_create("CustomeQueueLabel", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t otherCustomQueue = dispatch_queue_create("otherCustomQueueLabel", DISPATCH_QUEUE_CONCURRENT);
    Async.customQueue(customQueue,^{
        NSLog(@"Custome queue");
    }).customQueue(otherCustomQueue,^{
        NSLog(@"Other custom queue");
    });
    */
    
    /*
    // After
    CGFloat seconds = .5;
    NSLog(@"---------------");
    Async.after(seconds).main(^{
        NSLog(@"Is called after 0.5 seconds");
    }).after(.4).background(^{
        NSLog(@"At least 0.4 seconds after previous block, and 0.5 after Async code is called");
    });
     */
    
    /*
    // Cancel blocks not yet dispatched
    AsyncBlock block1 = Async.background(^{
       // Heavy work
        for (NSUInteger i=0; i < 1000; i++) {
            NSLog(@"A %zd",i);
        }
    });
    AsyncBlock block2 = block1.background(^{
        NSLog(@"B - shouldn't be reached, since cancelled");
    });
    Async.main(^{
        [block1 cancel];
        [block2 cancel];
    });
     */

    return YES;
}

@end



NSString* qd(qos_class_t qt)
{
    if (qt == qos_class_main()) return @"Main";
    
    switch (qt) {
        case QOS_CLASS_USER_INTERACTIVE:
            return  @"User Interactive";
            
        case QOS_CLASS_USER_INITIATED:
            return @"User Initiater";
            
        case QOS_CLASS_DEFAULT:
            return @"Default";
            
        case QOS_CLASS_UTILITY:
            return @"Utility";
            
        case QOS_CLASS_BACKGROUND:
            return @"BackGround";
            
        case QOS_CLASS_UNSPECIFIED:
            return @"Unspecified";
        default:
            return @"Unknown";
            break;
    }
    
    return @"Unknown";
}
