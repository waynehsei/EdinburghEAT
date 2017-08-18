//
//  RestView.swift
//  EdingburghEAT
//
//  Created by Wayne on 22/07/2017.
//  Copyright © 2017 Wayne. All rights reserved.
//

import UIKit

class RestView: UIView {
    
    var restaurant: Restaurant?
    var liked: Bool = false
    
    func setSize(frame: CGRect){
        let window = frame
        backgroundColor = UIColor.white
        self.frame = CGRect(x: 0, y: window.height, width: window.width, height: window.height)
    }
    
    func showRestDetail(rest:Restaurant){
        
        restaurant = rest
        // setting liked
        if SharedVariables.favRestaurants.contains((restaurant?.id)!) {
            self.liked = true
        }
        
        navbarSetting()
        imgSetting()
        infoBarSetting()
        starsSetting()
        dishSetting()
        favSetting()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        })
        
    }
    
    let backImgView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "backIcon")
        iv.translatesAutoresizingMaskIntoConstraints = false // need specified
        return iv
    }()
    
    let favImgView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "heartIcon")?.withRenderingMode(.alwaysTemplate)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = UIColor(r: 51,g: 104,b: 94)
        return iv
    }()

    
    func favSetting(){
        
        let favButton = UIButton(frame: CGRect(x: frame.width - 50, y: 315, width: 40, height: 40))
        favButton.backgroundColor = UIColor.white
        favButton.setImage(UIImage(named: "heartIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        if self.liked == true {
            favButton.imageView?.tintColor = UIColor(r: 237,g: 27,b: 83)
        }
        else {
            favButton.imageView?.tintColor = UIColor(r: 214,g: 212,b: 213)
        }
        favButton.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
        addSubview(favButton)
    }
    
    func add_remove_keywords(){
        var operand: Int = 1
        if self.liked == false{
            operand = -1
        }
        // append categories to keywords
        for category in (restaurant?.categories)!{
            if SharedVariables.keywords.keys.contains(category) {
                SharedVariables.keywords[category] = SharedVariables.keywords[category]! + operand
                if SharedVariables.keywords[category] == 0 {
                    SharedVariables.keywords.removeValue(forKey: category)
                }
            }
            else{
                SharedVariables.keywords[category] = operand
            }
        }
        // append dishes to keywords
        for dish in (restaurant?.dishes.keys)!{
            if SharedVariables.keywords.keys.contains(dish) {
                SharedVariables.keywords[dish] = SharedVariables.keywords[dish]! + operand
                if SharedVariables.keywords[dish] == 0 {
                    SharedVariables.keywords.removeValue(forKey: dish)
                }
            }
            else{
                SharedVariables.keywords[dish] = operand
            }
        }
        print(SharedVariables.favRestaurants)
        print(SharedVariables.keywords)
    }
    
    func addToFavorite(sender: UIButton) {
        if self.liked == false {
            sender.imageView?.tintColor = UIColor(r: 237,g: 27,b: 83)
            self.liked = true
            SharedVariables.favRestaurants.append((restaurant?.id)!)
            // append categories and dishes to keywords
        }
        else {
            sender.imageView?.tintColor = UIColor(r: 214,g: 212,b: 213)
            self.liked = false
            if let index = SharedVariables.favRestaurants.index(of: (restaurant?.id)!) {
                SharedVariables.favRestaurants.remove(at: index)
            }
        }
        add_remove_keywords()
        print(SharedVariables.favRestaurants)
        print(SharedVariables.keywords)
    }
    
    func infoBarSetting(){
        
        let button = UIButton(frame: CGRect(x: 5, y: 65, width: 30, height: 30))
        button.backgroundColor = UIColor.white
        
        addSubview(button)
        button.addSubview(backImgView)
        
        let width = NSLayoutConstraint(item: backImgView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 28)
        let height = NSLayoutConstraint(item: backImgView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 28)
        
        backImgView.addConstraints([width,height])
        addConstraint(NSLayoutConstraint(item: backImgView, attribute: .centerX, relatedBy: .equal, toItem: button, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: backImgView, attribute: .centerY, relatedBy: .equal, toItem: button, attribute: .centerY, multiplier: 1, constant: 0))

        button.addTarget(self, action: #selector(handleDissmiss), for: .touchUpInside)
        
        let rNameLabel = UILabel.init(frame: CGRect(x: 0, y: 65, width: frame.width, height: 30))
        rNameLabel.text = restaurant?.name
        rNameLabel.textAlignment = NSTextAlignment.center
        rNameLabel.textColor = UIColor.black
        rNameLabel.font = UIFont.systemFont(ofSize: 20)
        
        addSubview(rNameLabel)
    }
    
    func starsSetting(){
        let stars = restaurant?.stars
        let starBar = UIView.init(frame: CGRect(x: 0, y: 300, width: self.frame.width, height: 80))
        
        addSubview(starBar)

        starBar.backgroundColor = UIColor.white
        
        var numOfGR: Float = 0
        let numOfG: Float?
        let numOfR: Float?
        if (stars!*10/5).truncatingRemainder(dividingBy: 2) != 0 {
            // when the number of stars include 0.5
            numOfGR = 1
        }
        
        numOfR = stars! - Float(numOfGR)*0.5
        numOfG = 5.0 - numOfR! - numOfGR
        
        var idx = 10
        for _ in stride(from:0, to: Int(numOfR!), by: 1) {
            let redStar = UIImageView.init(frame: CGRect(x: idx, y: 15, width: 40, height: 40))
            redStar.image = UIImage(named: "redStar")
            idx += 40
            starBar.addSubview(redStar)
        }
        
        if numOfGR == 1 {
            let greyRedStar = UIImageView.init(frame: CGRect(x: idx, y: 15, width: 40, height: 40))
            greyRedStar.image = UIImage(named: "greyRedStar")
            idx += 40
            starBar.addSubview(greyRedStar)
        }
        
        for _ in stride(from:0, to: Int(numOfG!), by: 1) {
            let greyStar = UIImageView.init(frame: CGRect(x: idx, y: 15, width: 40, height: 40))
            greyStar.image = UIImage(named: "greyStar")
            idx += 40
            starBar.addSubview(greyStar)
        }
        
    }
    
    func dishSetting(){
        restaurant?.returnTopFive()
        let featureDish = restaurant?.sortedDish
        
        var idx: CGFloat = 10
        var idy: CGFloat = 380
        var numOfdish = 0
        
        let frameWidth = frame.width/3 - 13
        let frameHeight: CGFloat = 30
        let labelWidth = frameWidth - 5
        let labelHeight = frameHeight - 5
        
        // first row with three dishes
        for i in featureDish! {
            numOfdish += 1
            if numOfdish == 4 {
                idy += frameHeight + 10
                idx = 10
            }
            
            let dishframe = UIView.init(frame: CGRect(x: idx, y: idy, width: frameWidth, height: frameHeight))
            let dishNameLabel = UILabel()
            
            addSubview(dishframe)
            
            dishframe.addSubview(dishNameLabel)
            dishframe.backgroundColor = UIColor(r: 108, g: 199, b: 183)
            
            // round the bounds
            dishframe.layer.cornerRadius = 5
            dishframe.layer.masksToBounds = true
            
            dishNameLabel.text = i?.replacingOccurrences(of: "_", with: " ")
            dishNameLabel.backgroundColor = UIColor.white
            dishNameLabel.translatesAutoresizingMaskIntoConstraints = false
            dishNameLabel.textAlignment = NSTextAlignment.center
            dishNameLabel.textColor = UIColor.black
            dishNameLabel.font = UIFont.systemFont(ofSize: 15)
            dishNameLabel.layer.cornerRadius = 5
            dishNameLabel.layer.masksToBounds = true
            
            let width = NSLayoutConstraint(item: dishNameLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: labelWidth)
            let height = NSLayoutConstraint(item: dishNameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: labelHeight)
            
            dishNameLabel.addConstraints([width,height])
            addConstraint(NSLayoutConstraint(item: dishNameLabel, attribute: .centerX, relatedBy: .equal, toItem: dishframe, attribute: .centerX, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: dishNameLabel, attribute: .centerY, relatedBy: .equal, toItem: dishframe, attribute: .centerY, multiplier: 1, constant: 0))
            
            idx += frameWidth + 10
            
        }
    }
    
    let logoImg: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Logo")
        iv.translatesAutoresizingMaskIntoConstraints = false // need specified
        return iv
    }()
    
    func navbarSetting(){
        let navigationbar = UIView.init(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 60))
        navigationbar.backgroundColor = UIColor(r: 108, g: 199, b: 183)
        
        addSubview(navigationbar)
        navigationbar.addSubview(logoImg)
        
        let width = NSLayoutConstraint(item: logoImg, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50)
        let height = NSLayoutConstraint(item: logoImg, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50)
        
        logoImg.addConstraints([width,height])
        addConstraint(NSLayoutConstraint(item: logoImg, attribute: .centerX, relatedBy: .equal, toItem: navigationbar, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: logoImg, attribute: .centerY, relatedBy: .equal, toItem: navigationbar, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    func imgSetting(){
        
        let restImageView = UIImageView.init(frame: CGRect(x: 0, y: 100, width: frame.width, height: 200))
        
        addSubview(restImageView)
        
        if let data = NSData(contentsOf: (restaurant?.imageURL!)!) {
            restImageView.image = UIImage(data: data as Data)
        }
        
        URLSession.shared.dataTask(with: (restaurant?.imageURL!)!,completionHandler:{(data, response, error) in
            
            // download hit an error so lets return out
            if error != nil {
                print(error as Any)
                return
            }
            
            DispatchQueue.main.async(execute: {
                restImageView.image = UIImage(data:data!)
            })
            
        }).resume()
        
    }
    
    func handleDetail(sender: CustomButton){
        if let window = UIApplication.shared.keyWindow {
            let restView = RestView()
            restView.setSize(frame: window.frame)
            restView.showRestDetail(rest: sender.rest!)
            window.addSubview(restView)
        }
    }
    
    func handleDissmiss(){
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: self.frame.height)
        })
    }
}
