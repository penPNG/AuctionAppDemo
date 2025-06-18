//
//  NetworkMonitor.swift
//  AuctionAppDemo
//
//  Created by student on 6/17/25.
//

import Foundation
import Network

class NetworkMonitor {
    private var monitor: NWPathMonitor!
    var isReachable: Bool = false
    
    
    
    init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                #if DEBUG
                print("network on")
                #endif
                self.isReachable = true
            } else {
                #if DEBUG
                print("network off")
                #endif
                self.isReachable = false
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
}
