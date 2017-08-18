//
//  ViewController.swift
//  EdingburghEAT
//
//  Created by Wayne on 28/07/2017.
//  Copyright © 2017 Wayne. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    let ref = Database.database().reference(fromURL: "https://edinburgheat.firebaseio.com/")
    let storageRef = Storage.storage().reference(forURL: "gs://edinburgheat.appspot.com/")
    
    let LogoView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Logo")
        iv.translatesAutoresizingMaskIntoConstraints = false // need specified
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 108, g: 199, b: 183)
        view.addSubview(LogoView)
        setupLogoView()
        
        fetchRestaurant()
        fetchDish()
        
        perform(#selector(ViewController.toLoginPage), with: self, afterDelay: 20)
    }
    
    func setupLogoView(){
        LogoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        LogoView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        LogoView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        LogoView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func toLoginPage(){
        let loginViewController = LoginViewController()
        self.navigationController!.pushViewController(loginViewController, animated: false)
    }
    
    func fetchRestaurant(){
        
        ref.child("restaurants").observe(.childAdded, with: {(DataSnapshot) in
            
            var restDict = DataSnapshot.value as! [String:AnyObject]
            let rest = Restaurant(id: DataSnapshot.key, name: restDict["name"] as? String, stars: restDict["stars"] as? Float)
            rest.setCorr(latitude: restDict["coordinates"]?[1] as! Double, longitude: restDict["coordinates"]?[0] as! Double)
            if let dishes = restDict["dishes"] as! [String:Int]? {
                for dish in dishes.keys{
                    rest.adddish(dish: dish, count: dishes[dish]!)
                }
            }
            if let categories = restDict["categories"] as! [String]? {
                for category in categories {
                    rest.addCat(category: category)
                }
            }
            
            // fetch photo to rest objs
            let photoRef = self.storageRef.child(rest.id! + ".jpg");
            photoRef.downloadURL { (URL, error) -> Void in
                if (error != nil) {
                } else {
                    rest.imageURL = URL
                    print("mapping " + rest.name!)
                }
            }
            
            SharedVariables.restaurants.append(rest)
            SharedVariables.rid2rest[rest.id!] = rest
        })
    }
    
    func fetchDish(){
        ref.child("dishes").observe(.childAdded, with: {(DataSnapshot) in
            
            var dishDict = DataSnapshot.value as! [String:AnyObject]
            let dish = Dish(name: dishDict["name"] as? String, views: dishDict["views"] as? Int)
            // fetch photo to rest objs
            let photoRef = self.storageRef.child((dishDict["name"] as! String?)! + ".jpg");
            photoRef.downloadURL { (URL, error) -> Void in
                if (error != nil) {
                } else {
                    dish.imageURL = URL
                }
            }
            SharedVariables.dishes[dish] = dishDict["views"] as? Int
            let views = dishDict["views"] as! Int
            SharedVariables.totalViews += views
        })
    }

}
