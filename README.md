# Async.OC
Rewrite [Async](https://github.com/duemunk/Async) by Objective-C

**Async** sugar looks like this:
```obj-c
Async.background(^{
    NSLog(@"A: This is run on the background");
}).main(^{
    NSLog(@"B: This is run on the , after the previous block");
});
```

Instead of the familiar syntax for GCD:
```swift
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    NSLog(@"A: This is run on the background");

    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"B: This is run on the , after the previous block");
    });
});
```
