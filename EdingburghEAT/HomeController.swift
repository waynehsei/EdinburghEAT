//
//  ViewController.swift
//  EdingburghEAT
//
//  Created by Wayne on 16/07/2017.
//  Copyright © 2017 Wayne. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let recommendCellId = "recommendCellId"
    let feedCellId = "feedCellId"
    let trendingId = "trendingId"
    let favoriteId = "favoriteId"
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        view.translatesAutoresizingMaskIntoConstraints = false // need specified

        return view
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupCollectionView()
        setupMenuBar()
    }
    
    func handleLogout(){
        do {
            let ref = Database.database().reference().child("users/" + SharedVariables.userId)

            ref.updateChildValues([
                "favRestaurants": SharedVariables.favRestaurants
                ])
            ref.updateChildValues([
                "keywords": SharedVariables.keywords
                ])
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginViewController = LoginViewController()
        self.navigationController!.pushViewController(loginViewController, animated: true)
        loginViewController.navigationItem.setHidesBackButton(true, animated:true);
        SharedVariables.reinitialze()
    }
    
    func setupNavigationBar(){
        self.navigationItem.setHidesBackButton(true, animated:true);
        self.navigationController?.navigationBar.isTranslucent = false
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "  Near By Restaurants"
        titleLabel.textColor = UIColor.white
        //titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textAlignment = NSTextAlignment.left
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.navigationItem.titleView = titleLabel
        
        let logoutButton = UIBarButtonItem(image: UIImage(named: "logoutIcon")?.resizeWith(width: 25)?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))
        
        navigationItem.rightBarButtonItems = [logoutButton]
    }
    
    func setupCollectionView() {
        
        // setup horizontal scroll
        if let flowlayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowlayout.scrollDirection = .horizontal
            flowlayout.minimumLineSpacing = 0
        }
        collectionView?.isPagingEnabled = true
        
        collectionView?.backgroundColor = UIColor.white

        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: feedCellId)
        collectionView?.register(RecommendCell.self, forCellWithReuseIdentifier: recommendCellId)
        collectionView?.register(TrendingCell.self, forCellWithReuseIdentifier: trendingId)
        collectionView?.register(FavoriteCell.self, forCellWithReuseIdentifier: favoriteId)
    }
    
    let titles = ["Near By Restaurants", "Recommend To You", "Trending Dish", "Favorite Restaurants"]
    
    func scrollToMenuIndex(menuIndex: Int){
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath as IndexPath, at: [], animated: false)
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "  \(titles[menuIndex])"
        }
    }
    
    // horizontal bar to react with scroll
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
//    }
    
    // sync the icon and the page
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = NSIndexPath(item: Int(index), section: 0) // track the scroll position and map into the icon
        menuBar.collectionView.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition: [])
        
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "  \(titles[Int(index)])"
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: feedCellId, for: indexPath)
        }
        if indexPath.item == 1 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: recommendCellId, for: indexPath)
        }
        if indexPath.item == 2 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: trendingId, for: indexPath)
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: favoriteId, for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:view.frame.width, height:view.frame.height)
    }
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self  // make cell accessible 
        return mb
    }()
    
    private func setupMenuBar(){
        view.addSubview(menuBar)
        menuBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        menuBar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        menuBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: 80).isActive = true
        menuBar.translatesAutoresizingMaskIntoConstraints = false // need specified
    }
}

extension UIView {
    func addConstraintWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        let constriant = NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary)
        addConstraints(constriant)
    }
}

