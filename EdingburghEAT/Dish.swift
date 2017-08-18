//
//  Dish.swift
//  EdingburghEAT
//
//  Created by Wayne on 24/07/2017.
//  Copyright © 2017 Wayne. All rights reserved.
//

import UIKit

class Dish: NSObject {
    
    let name: String?
    let views: Int?
    var imageURL: URL?
    
    init(name:String?, views:Int?) {
        self.name = name
        self.views = views
        super.init()
    }
    
    func returnTopFive(){
        
    }
}
