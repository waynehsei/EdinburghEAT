//
//  Restaurant.swift
//  EdingburghEAT
//
//  Created by Wayne on 17/07/2017.
//  Copyright © 2017 Wayne. All rights reserved.
//

import UIKit

class Restaurant: NSObject {
    
    var id: String?
    var name: String?
    var stars: Float?
    var latitude: Double?
    var longitude: Double?
    var dishes = [String:Int]()
    var categories = [String]()
//    var sortedDish = [(key:String, value:Int)]()
    var sortedDish = [String?]()
    var imageURL: URL?
    
    init(id:String?, name: String?, stars: Float?) {
        self.id = id
        self.name = name
        self.stars = stars
        super.init()
    }
    
    func setCorr(latitude:Double, longitude:Double){
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func adddish(dish:String?, count:Int){
        self.dishes.updateValue(count, forKey: dish!)
    }
    
    func addCat(category:String?){
        self.categories.append(category!)
    }
    
    func returnTopFive(){
        self.sortedDish = []
        var data = [(key:String, value:Int)]()
        var n = 6
        if dishes.count < 5 {
            n = dishes.count
        }
        let byValue = {
            (elem1:(key: String, val: Int), elem2:(key: String, val: Int))->Bool in
            if elem1.val > elem2.val {
                return true
            } else {
                return false
            }
        }
        data = Array(self.dishes.sorted(by: byValue).prefix(n))
        for i in data {
            self.sortedDish.append(i.key)
        }
    }
}
