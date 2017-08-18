//
//  FavoriteRests.swift
//  EdingburghEAT
//
//  Created by Wayne on 30/07/2017.
//  Copyright © 2017 Wayne. All rights reserved.
//

import UIKit

class FavoriteCell: RecommendCell {
    
    override func setupViews() {
        
        var restlist = [Restaurant]()
        
        super.setupViews()

        for rid in SharedVariables.favRestaurants {
            restlist.append(SharedVariables.rid2rest[rid]!)
        }
        super.restaurants = restlist
        super.setupView()
    }
    
    override func didPullToRefresh() {
        var restlist = [Restaurant]()
        for rid in SharedVariables.favRestaurants {
            restlist.append(SharedVariables.rid2rest[rid]!)
        }
        super.restaurants = restlist
        super.collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:frame.width, height: frame.height/5)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if restaurants.count < 5{
            return 5
        }
        
        return restaurants.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RestaurantCell
        let blankCell = collectionView.dequeueReusableCell(withReuseIdentifier: blankCellId, for: indexPath) as! BaseCell
        
        if restaurants.count < 5{
            if indexPath.item >= restaurants.count {
                return blankCell
            }
            cell.restaurant = restaurants[indexPath.item]
            return cell
        }
        
        if indexPath.item == restaurants.count {
            return blankCell
        }
        cell.restaurant = restaurants[indexPath.item]
        
        return cell
    }
}
