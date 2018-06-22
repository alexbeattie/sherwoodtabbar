//
//  AllListingsMapVC.swift
//  sherwoodrealestate
//
//  Created by Alex Beattie on 5/21/18.
//  Copyright © 2018 Alex Beattie. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class AllListingsMapVC: UIViewController, MKMapViewDelegate {
    
    var anno:Listing.standardFields!
    var locationManager = CLLocationManager()
    var listingAnnos:[ListingAnno] = [ListingAnno]()
    
    var mapView = MKMapView()
    var listing:Listing!
    
    var homeController:HomeViewController?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UINavigationBar.appearance().tintColor = UIColor.black
        navigationItem.backBarButtonItem = UIBarButtonItem(title:" ", style: .plain, target: nil, action: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        UINavigationBar.appearance().tintColor = UIColor(red: 66, green: 66, blue: 66, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.black

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "sherwood")
        imageView.image = image
        navigationItem.titleView = imageView
        
        self.view = mapView
        mapView.delegate = self
        let myCoordinate = CLLocationCoordinate2D(latitude:34.127980999999998 , longitude:-118.86794999999999 )
        let region = MKCoordinateRegionMakeWithDistance(myCoordinate,2000, 2000)
        
        mapView.setRegion(region, animated: true)

//        let annotation:ListingAnno
        
        
//        annotation.title = "test"


        navigationController?.navigationBar.tintColor = UIColor(red: 66, green: 66, blue: 66, alpha: 1)

//        var lat = anno.Latitude
//        var long = anno.Longitude
//        print(lat,long)
//        print(homeController?.listings)

        fetchListings()
//        print(Listing.listingResults.self)
        
    }
    
    let ldvc:ListingDetailController? = nil
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view:MKPinAnnotationView
        let identifier = "Pin"
        
        if annotation is MKUserLocation{
            return nil//use the blue dot
        }
        if annotation !== mapView.userLocation {
            //try to reuse the view
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation =  annotation
                view = dequeuedView
            } else {
                //finish
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.pinTintColor = MKPinAnnotationView.purplePinColor()
                view.canShowCallout = true
                view.animatesDrop = true
                view.pinTintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)

                view.calloutOffset = CGPoint(x: -5, y: 5)
                let leftButton = UIButton(type: .infoLight)
                let rightButton = UIButton(type: .detailDisclosure)
                leftButton.tag = 0
                rightButton.tag = 1
                view.leftCalloutAccessoryView = leftButton
                view.rightCalloutAccessoryView = rightButton
                

            }
            let leftIconView = CustomImageView()
            leftIconView.contentMode = .scaleAspectFill
            
            if let thumbnailImageUrl = ldvc?.listing?.StandardFields.Photos[0].Uri1600 {
                leftIconView.loadImageUsingUrlString(urlString: (thumbnailImageUrl))
                print(thumbnailImageUrl)
            }
            
            let newBounds = CGRect(x:0.0, y:0.0, width:54.0, height:54.0)
            leftIconView.bounds = newBounds
            view.leftCalloutAccessoryView = leftIconView

            return view
        }
        return nil
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            
            
            let placemark = MKPlacemark(coordinate: view.annotation!.coordinate, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = view.annotation!.title!
            let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
            
            
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
    
    
    func fetchListings() {
        
        Listing.standardFields.fetchListing { (listing) in
            for anno in listing.D.Results {
                
                let title = anno.StandardFields.UnparsedAddress
                let lat = anno.StandardFields.Latitude
                let lon = anno.StandardFields.Longitude
                let subTitle = anno.StandardFields.ListOfficeName
                let coordinate = CLLocationCoordinate2DMake(lat!, lon!)
                
                var thePoint = MKPointAnnotation()
                thePoint = MKPointAnnotation()
                thePoint.coordinate = coordinate
                thePoint.title = title
                thePoint.subtitle = subTitle
                self.mapView.addAnnotation(thePoint)


            }
        }
    }
}



