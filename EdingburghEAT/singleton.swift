//
//  singleton.swift
//  EdingburghEAT
//
//  Created by Wayne on 24/07/2017.
//  Copyright © 2017 Wayne. All rights reserved.
//

import Firebase

private class SingletonSetupHelper {
    var restaurants:[Restaurant]?
}

class MySingleton {
    
    static var shared = [Restaurant]()
    //static let shared = MySingleton()
    private static let setup = SingletonSetupHelper()
    
    class func setup(rest:[Restaurant]){
        MySingleton.setup.restaurants = rest
    }
    
    private init() {
        let rest = MySingleton.setup.restaurants
        MySingleton.shared = rest!
        guard rest != nil else {
            fatalError("Error - you must call setup before accessing MySingleton.shared")
        }
        
        //Regular initialisation using param
    }
    
//    private static var sharedNetworkManager: NetworkManager = {
//        let networkManager = NetworkManager(baseURL: API.baseURL)
//        
//        // Configuration
//        // ...
//        
//        return networkManager
}
