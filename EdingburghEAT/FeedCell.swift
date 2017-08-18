//
//  FeedCell.swift
//  EdingburghEAT
//
//  Created by Wayne on 21/07/2017.
//  Copyright © 2017 Wayne. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class FeedCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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

    override func setupViews() {
        super.setupViews()
        
        backgroundColor = UIColor.white
        addSubview(collectionView)
        addConstraintWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintWithFormat(format: "V:|[v0]|", views: collectionView)
        
        collectionView.register(MapViewCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:frame.width, height:frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        return cell
    }
}

class MapViewCell: BaseCell, CLLocationManagerDelegate, MKMapViewDelegate  {

    var myMapView = MKMapView()
    let manager = CLLocationManager()
    var AnnotationRest: Restaurant?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupViews()
        setupMapView()
    }
    
    override func setupViews() {
        
        myMapView = MKMapView(frame: self.bounds)
        myMapView.delegate = self
        
        addSubview(myMapView)
        
        addConstraintWithFormat(format: "H:|[v0]|", views: myMapView)
        addConstraintWithFormat(format: "V:|[v0]|", views: myMapView)
        
    }
    
    func setupMapView(){
        
        for rest in SharedVariables.restaurants {
            let annotation = CustomAnnotation()
            annotation.coordinate.latitude = rest.latitude!
            annotation.coordinate.longitude = rest.longitude!
            annotation.title = rest.name
            annotation.rest = rest
            self.myMapView.addAnnotation(annotation)
        }
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        myMapView.translatesAutoresizingMaskIntoConstraints = false // need specified
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations[0]
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let mylocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region = MKCoordinateRegion(center:mylocation, span:span)
        myMapView.setRegion(region, animated: true)
        
        self.myMapView.showsUserLocation = true
    }
    
    @objc(mapView:viewForAnnotation:) func mapView(_ myMapView: MKMapView, viewFor annotation: CustomAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else {
            
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView = myMapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        
        let pin = UIImage(named: "redpin")?.resizeWith(width: 30)
        annotationView!.image = pin
        
        let rest = annotation.rest
        //AnnotationRest = rest
        
        let btn = CustomButton(type: .infoLight)
        btn.addTarget(self, action: #selector(handleDetail(sender:)), for: .touchUpInside)
        btn.rest = rest
        
        annotationView?.rightCalloutAccessoryView = btn
        
        return annotationView
        
    }
    
    func handleDetail(sender: CustomButton){
        if let window = UIApplication.shared.keyWindow {
            let restView = RestView()
            restView.setSize(frame: window.frame)
            restView.showRestDetail(rest: sender.rest!)
            window.addSubview(restView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIImage {
    
    func resizeWith(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    func resizeWith(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
}
