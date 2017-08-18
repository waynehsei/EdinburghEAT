//
//  Extension.swift
//  EdingburghEAT
//
//  Created by Wayne on 22/07/2017.
//  Copyright © 2017 Wayne. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

extension String {
    var length: Int {
        return self.characters.count
    }
}

extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}

struct SharedVariables {
    static var restaurants = [Restaurant]()
    static var rid2rest = [String:Restaurant]()
    static var dishes = [Dish:Int]()
    static var totalViews: Int = 0
    static var currlatitude: Double = 55.950672
    static var currlongtitude: Double = -3.19011
    static var userId: String = ""
    static var favRestaurants = [String]()
    static var keywords = [String:Int]()
    static func reinitialze(){
        dishes = [Dish:Int]()
        totalViews = 0
        currlatitude = 55.93802
        currlongtitude = -3.18139
        userId = ""
        favRestaurants = [String]()
        keywords = [String:Int]()
    }
}
