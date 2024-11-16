//
//  LXIOSCoreNetworkLayer.swift
//  LXIOSCore
//
//  Created by Artak Gevorgyan on 25.06.23.
//

import Foundation

class LXIOSCoreNetworkLayer {
    
    static let shared = LXIOSCoreNetworkLayer()

    var hostName: String = ""
    var version: String = ""
    
    func initWith(hostName: String, version: String) {
        self.hostName = hostName
        self.version = version
    }

}
