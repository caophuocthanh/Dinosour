//
//  Thread.swift
//  Storage
//
//  Created by Cao Phuoc Thanh on 3/23/21.
//  Copyright © 2021 Cao Phuoc Thanh. All rights reserved.
//

import UIKit

internal class ReleasepoolThread: Foundation.Thread {

    var runLoop: RunLoop?
    var mainBlock: (() -> Void)?

    convenience init(name: String) {
        self.init()
        self.name = name
    }

    override public func main() {
        runLoop = RunLoop.current
        guard let runLoop = runLoop else { return }

        mainBlock?()
        mainBlock = nil

        while !isCancelled {
            autoreleasepool { runLoop.run() }
        }

        CFRunLoopStop(runLoop.getCFRunLoop())
    }

    public func runLoopPerformBlock(_ block: @escaping () -> Void) {

        if runLoop == nil {
            let semaphore = DispatchSemaphore(value: 0)
            mainBlock = { semaphore.signal() }
            start()
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        }

        precondition(runLoop != nil, "Cannot add operation to thread before it is started")
        CFRunLoopPerformBlock(runLoop!.getCFRunLoop(), CFRunLoopMode.commonModes.rawValue, block)
        CFRunLoopWakeUp(runLoop!.getCFRunLoop())
    }


}
