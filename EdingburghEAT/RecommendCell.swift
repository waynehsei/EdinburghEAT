//
//  RecommendCell.swift
//  EdingburghEAT
//
//  Created by Wayne on 22/07/2017.
//  Copyright © 2017 Wayne. All rights reserved.
//

import UIKit

class RecommendCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var restaurants = [Restaurant]()
    let recommed = HandleRecommend()
    let refreshControl = UIRefreshControl()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        // get the data into the cell in advance otherwise the collectionView func wont work
        cv.dataSource = self // can access the cell by lazy var
        cv.delegate = self
        return cv
    }()
    
    let cellId = "cellId"
    let blankCellId = "blankCellId"
    
    override func setupViews() {
        
        super.setupViews()

        recommed.setup()
        restaurants = recommed.topFive
        
        setupView()
    }
    
    func didPullToRefresh() {
        let newRecommed = HandleRecommend()
        newRecommed.setup()
        restaurants = newRecommed.topFive
        self.collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func setupView(){
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        self.collectionView.addSubview(refreshControl)
        
        backgroundColor = UIColor.white
        addSubview(collectionView)
        addConstraintWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintWithFormat(format: "V:|[v0]|", views: collectionView)
        
        collectionView.register(RestaurantCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(BaseCell.self, forCellWithReuseIdentifier: blankCellId)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:frame.width, height: frame.height/CGFloat(restaurants.count))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurants.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RestaurantCell
        let blankCell = collectionView.dequeueReusableCell(withReuseIdentifier: blankCellId, for: indexPath) as! BaseCell
        
        if indexPath.item == restaurants.count {
            return blankCell
        }
            cell.restaurant = restaurants[indexPath.item]
        
        return cell
    }
}

import CoreLocation

class RestaurantCell: BaseCell {
    
    var restaurant: Restaurant? {
        didSet {
            imgSetting()
            labelSetting()
            starsSetting()
            dishSetting()
            distanceSetting()
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
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let restImageView = UIImageView()
    let nameLabelView = UILabel()
    var starBar = UIView()
    var dishBar = UIView()
    var distanceView = UIView()
    
    func distanceSetting(){
        distanceView = UIView()
        setupDistance()
        
        let currLocation = CLLocation(latitude: SharedVariables.currlatitude, longitude: SharedVariables.currlongtitude)
        let location = CLLocation(latitude: (restaurant?.latitude!)!, longitude: (restaurant?.longitude!)!)
        let distanceInMeters = currLocation.distance(from: location)
        
        DispatchQueue.main.async(execute: {
            let distanceLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 36, height: 18))
            distanceLabel.text = String(Double(round(distanceInMeters/100)/10)) + "km"
            distanceLabel.textAlignment = NSTextAlignment.center
            distanceLabel.textColor = UIColor.black
            distanceLabel.font = UIFont.systemFont(ofSize: 12)
            self.distanceView.addSubview(distanceLabel)
        })
    }
    
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
        
        starBar = UIView()
        setupStarBar()
        starBar.backgroundColor = UIColor.white
        
        DispatchQueue.main.async(execute: {
            
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
                self.starBar.addSubview(redStar)
            }
            
            if numOfGR == 1 {
                let greyRedStar = UIImageView.init(frame: CGRect(x: idx, y: 0, width: 18, height: 18))
                greyRedStar.image = UIImage(named: "greyRedStar")
                idx += 18
                self.starBar.addSubview(greyRedStar)
            }
            
            for _ in stride(from:0, to: Int(numOfG!), by: 1) {
                let greyStar = UIImageView.init(frame: CGRect(x: idx, y: 0, width: 18, height: 18))
                greyStar.image = UIImage(named: "greyStar")
                idx += 18
                self.starBar.addSubview(greyStar)
            }
            
        })
        
    }
    
    func dishSetting(){
        
        dishBar = UIView()
        setupDishBar()
        dishBar.backgroundColor = UIColor.white
        
        restaurant?.returnTopFive()
        let featureDish = restaurant?.sortedDish
        
        DispatchQueue.main.async(execute: {
            
            var idx: CGFloat = 0
            var idy: CGFloat = 0
            var remained: CGFloat = 235
            
            let frameHeight: CGFloat = 20
            
            // first row with three dishes
            for i in featureDish! {
                
                let frameWidth: CGFloat
                
                let size = CGSize(width: 1000, height: frameHeight)
                let dishName = i?.replacingOccurrences(of: "_", with: " ")
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimatedRect = NSString(string: dishName!).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13)], context: nil)
                frameWidth = estimatedRect.size.width
                
                if estimatedRect.size.width > remained {
                    // row 2
                    if idy == frameHeight + 5{
                        break
                    }
                    idy += frameHeight + 5
                    idx = 0
                    remained = 235
                }
                
                let dishframe = UILabel.init(frame: CGRect(x: idx, y: idy, width: frameWidth, height: frameHeight))
                
                // round the bounds
                dishframe.layer.cornerRadius = 5
                dishframe.layer.masksToBounds = true
                dishframe.layer.borderWidth = 1
                dishframe.layer.borderColor = UIColor(r: 108, g: 199, b: 183).cgColor
                
                dishframe.textAlignment = NSTextAlignment.center
                dishframe.textColor = UIColor.black
                dishframe.text = dishName
                dishframe.font = UIFont.systemFont(ofSize: 11)
                
                self.dishBar.addSubview(dishframe)
                
                idx += frameWidth + 5
                remained -= (frameWidth + 5)
            }
        })
    }
    
    func setupDistance(){
        addSubview(distanceView)
        addConstraintWithFormat(format: "H:|-320-[v0(36)]", views: distanceView)
        addConstraintWithFormat(format: "V:|-40-[v0(18)]", views: distanceView)
    }
    
    func setupStarBar(){
        addSubview(starBar)
        addConstraintWithFormat(format: "H:|-120-[v0]-26-|", views: starBar)
        addConstraintWithFormat(format: "V:|-40-[v0(20)]", views: starBar)
    }
    
    func setupDishBar(){
        addSubview(dishBar)
        addConstraintWithFormat(format: "H:|-120-[v0(235)]", views: dishBar)
        addConstraintWithFormat(format: "V:|-60-[v0(46)]", views: dishBar)
    }
    
    override func setupViews() {
        
        addSubview(cellFrame)
        addSubview(restImageView)
        addSubview(nameLabelView)
        
        setupStarBar()
        setupDishBar()
        setupDistance()
        
        addConstraintWithFormat(format: "H:|-10-[v0]-10-|", views: cellFrame)
        addConstraintWithFormat(format: "V:|-5-[v0]-5-|", views: cellFrame)
        addConstraintWithFormat(format: "H:|-20-[v0(90)]", views: restImageView)
        addConstraintWithFormat(format: "V:|-15-[v0]-15-|", views: restImageView)
        addConstraintWithFormat(format: "H:|-120-[v0]-26-|", views: nameLabelView)
        addConstraintWithFormat(format: "V:|-15-[v0(25)]", views: nameLabelView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
