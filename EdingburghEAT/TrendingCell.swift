//
//  TrendingCell.swift
//  EdingburghEAT
//
//  Created by Wayne on 24/07/2017.
//  Copyright © 2017 Wayne. All rights reserved.
//

import UIKit


class TrendingCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let sortedDish: [Dish?] = {
        var sd = [Dish?]()
        var data = [(key:Dish, value:Int)]()
        let byValue = {
            (elem1:(key: Dish, val: Int), elem2:(key: Dish, val: Int))->Bool in
            if elem1.val > elem2.val {
                return true
            } else {
                return false
            }
        }
        data = Array(SharedVariables.dishes.sorted(by: byValue).prefix(5))
        for i in data {
            sd.append(i.key)
        }
        return sd
    }()
    
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
        
        backgroundColor = UIColor.blue
        addSubview(collectionView)
        addConstraintWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintWithFormat(format: "V:|[v0]|", views: collectionView)
        
        collectionView.register(DishCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(BaseCell.self, forCellWithReuseIdentifier: blankCellId)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:frame.width, height: frame.height/CGFloat(sortedDish.count))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedDish.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DishCell
        let blankCell = collectionView.dequeueReusableCell(withReuseIdentifier: blankCellId, for: indexPath) as! BaseCell
        
        if indexPath.item == 5 {
            return blankCell
        }

        cell.dish = sortedDish[indexPath.item]
        
        return cell
    }
    
}

class DishCell: BaseCell {
    
    var dish: Dish? {
        didSet {
            imgSetting()
            labelSetting()
            popularityLabelSetting()
            popularitySetting()
            
//            starsSetting()
//            dishSetting()
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
    
    let dishImageView = UIImageView()
    let nameLabelView = UILabel()
    let popularityLabel = UILabel()
    let starBar = UIView()
    let dishBar = UIView()
    let backgroundBar: UIView = {
        let view = UIView(frame: CGRect(x: 120, y: 85, width: 200, height: 20))
        view.backgroundColor = UIColor(r: 211,g: 211,b: 211)
        return view
    }()
    
    func popularitySetting() {
        let popularity = CGFloat((dish?.views)!)/CGFloat(SharedVariables.totalViews).rounded()
        let length = (log10(popularity*100) + 0.5) * 70
        let valueBar = UIView.init(frame: CGRect(x: 0, y: 0, width: length, height: 20))
        valueBar.backgroundColor = UIColor(r: 242,g: 139,b: 32)
        
        backgroundBar.addSubview(valueBar)
    }
    
    func popularityLabelSetting() {
        popularityLabel.text = "Popularity"
        popularityLabel.textAlignment = NSTextAlignment.left
        popularityLabel.textColor = UIColor.gray
        popularityLabel.font = UIFont.systemFont(ofSize: 12)
    }
    
    func labelSetting() {
        nameLabelView.text = dish?.name?.replacingOccurrences(of: "_", with: " ").uppercased()
        nameLabelView.textAlignment = NSTextAlignment.left
        nameLabelView.textColor = UIColor.black
        nameLabelView.font = UIFont.systemFont(ofSize: 18)
    }
    
    func imgSetting(){
        
        if let data = NSData(contentsOf: (dish?.imageURL!)!) {
            dishImageView.image = UIImage(data: data as Data)
        }
        
        URLSession.shared.dataTask(with: (dish?.imageURL!)!,completionHandler:{(data, response, error) in
            
            // download hit an error so lets return out
            if error != nil {
                print(error as Any)
                return
            }
            
            DispatchQueue.main.async(execute: {
                self.dishImageView.image = UIImage(data:data!)
            })
            
        }).resume()
    }
    
    override func setupViews() {
        addSubview(cellFrame)
        addSubview(dishImageView)
        addSubview(nameLabelView)
        addSubview(popularityLabel)
        addSubview(backgroundBar)
        
        addConstraintWithFormat(format: "H:|-10-[v0]-10-|", views: cellFrame)
        addConstraintWithFormat(format: "V:|-5-[v0]-5-|", views: cellFrame)
        addConstraintWithFormat(format: "H:|-20-[v0(90)]", views: dishImageView)
        addConstraintWithFormat(format: "V:|-15-[v0]-15-|", views: dishImageView)
        addConstraintWithFormat(format: "H:|-120-[v0]-26-|", views: nameLabelView)
        addConstraintWithFormat(format: "V:|-15-[v0(18)]", views: nameLabelView)
        addConstraintWithFormat(format: "H:|-120-[v0]-26-|", views: popularityLabel)
        addConstraintWithFormat(format: "V:[v0(20)]-35-|", views: popularityLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
