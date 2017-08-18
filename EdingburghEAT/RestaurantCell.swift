//
//  RestaurantCell.swift
//  EdingburghEAT
//
//  Created by Wayne on 21/07/2017.
//  Copyright © 2017 Wayne. All rights reserved.
//

import UIKit

class RestaurantCell: BaseCell {
    
    var restaurant: Restaurant? {
        didSet {
            imgSetting()
            labelSetting()
            starsSetting()
            dishSetting()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let cellFrame: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(r: 108, g: 199, b: 183).cgColor
//        view.layer.borderColor = [[UIColor(r: 108, g: 199, b: 183)] CGColor]
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let restImageView = UIImageView()
    let nameLabelView = UILabel()
    let starBar = UIView()
    let dishBar = UIView()
    
    func labelSetting() {
        nameLabelView.text = restaurant?.name
        nameLabelView.textAlignment = NSTextAlignment.left
        nameLabelView.backgroundColor = UIColor.white
        nameLabelView.textColor = UIColor.black
        nameLabelView.font = UIFont.systemFont(ofSize: 16)
    }
    
    func imgSetting(){
        
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
                self.restImageView.image = UIImage(data:data!)
            })
            
        }).resume()
    }
    
    func starsSetting(){
        let stars = restaurant?.stars
        
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
        
        var idx = 0
        for _ in stride(from:0, to: Int(numOfR!), by: 1) {
            let redStar = UIImageView.init(frame: CGRect(x: idx, y: 0, width: 18, height: 18))
            redStar.image = UIImage(named: "redStar")
            idx += 18
            starBar.addSubview(redStar)
        }
        
        if numOfGR == 1 {
            let greyRedStar = UIImageView.init(frame: CGRect(x: idx, y: 0, width: 18, height: 18))
            greyRedStar.image = UIImage(named: "greyRedStar")
            idx += 18
            starBar.addSubview(greyRedStar)
        }
        
        for _ in stride(from:0, to: Int(numOfG!), by: 1) {
            let greyStar = UIImageView.init(frame: CGRect(x: idx, y: 0, width: 18, height: 18))
            greyStar.image = UIImage(named: "greyStar")
            idx += 18
            starBar.addSubview(greyStar)
        }
        
    }
    
    func dishSetting(){
        
        dishBar.backgroundColor = UIColor.white
        restaurant?.returnTopFive()
        let featureDish = restaurant?.sortedDish

        var idx: CGFloat = 0
        var idy: CGFloat = 0
        var numOfdish = 0
        
        let frameWidth: CGFloat = 70
        let frameHeight: CGFloat = 20
        
        // first row with three dishes
        for i in featureDish! {
            numOfdish += 1
            if numOfdish == 4 {
                idy += frameHeight + 5
                idx = 0
            }
            
            let dishframe = UILabel.init(frame: CGRect(x: idx, y: idy, width: frameWidth, height: frameHeight))

            // round the bounds
            dishframe.layer.cornerRadius = 5
            dishframe.layer.masksToBounds = true
            dishframe.layer.borderWidth = 1
            dishframe.layer.borderColor = UIColor(r: 108, g: 199, b: 183).cgColor
            
            dishframe.text = i?.replacingOccurrences(of: "_", with: " ")
            dishframe.textAlignment = NSTextAlignment.center
            dishframe.textColor = UIColor.black
            dishframe.font = UIFont.systemFont(ofSize: 8)
            
            dishBar.addSubview(dishframe)
            
            idx += frameWidth + 5
        }
    }
    
    override func setupViews() {
        addSubview(cellFrame)
        addSubview(restImageView)
        addSubview(nameLabelView)
        addSubview(starBar)
        addSubview(dishBar)
        
        addConstraintWithFormat(format: "H:|-16-[v0]-16-|", views: cellFrame)
        addConstraintWithFormat(format: "V:|-10-[v0]|", views: cellFrame)
        addConstraintWithFormat(format: "H:|-26-[v0(90)]", views: restImageView)
        addConstraintWithFormat(format: "V:|-20-[v0]-10-|", views: restImageView)
        addConstraintWithFormat(format: "H:|-126-[v0]-26-|", views: nameLabelView)
        addConstraintWithFormat(format: "V:|-20-[v0(25)]|", views: nameLabelView)
        addConstraintWithFormat(format: "H:|-126-[v0]-26-|", views: starBar)
        addConstraintWithFormat(format: "V:|-45-[v0(20)]|", views: starBar)
        addConstraintWithFormat(format: "H:|-126-[v0(230)]|", views: dishBar)
        addConstraintWithFormat(format: "V:|-65-[v0(46)]|", views: dishBar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
