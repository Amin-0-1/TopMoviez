//
//  Connection.swift
//  Movies
//
//  Created by Sulfah on 24/01/2022.
//

import Foundation
import Network

class Connectivity{
    
    static var shared = Connectivity()
    private var path:NWPathMonitor!
    private let queue = DispatchQueue(label: "connection")
    private init(){
        path = NWPathMonitor()

        path.pathUpdateHandler = { path in
            if path.status == .satisfied{
                print("connected")
            }else{
                print("disconnected")
            }
        }
        self.path.start(queue: self.queue)
    }
    
    func isConnected()->Bool{
        return path.currentPath.status == .satisfied
    }
    
    func getConnectionPath()->NWPathMonitor{
        return path
    }
}
