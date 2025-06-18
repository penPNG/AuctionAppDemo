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
                print("network on")
                self.isReachable = true
            } else {
                print("network off")
                self.isReachable = false
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
}
