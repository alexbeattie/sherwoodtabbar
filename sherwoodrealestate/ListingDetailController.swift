//
//  ListingDetailController.swift
//  sherwoodrealestate
//
//  Created by Alex Beattie on 5/21/18.
//  Copyright © 2018 Alex Beattie. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MapKit
import CoreLocation
import MessageUI

class ListingDetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout, MKMapViewDelegate, CLLocationManagerDelegate, UIToolbarDelegate, MFMailComposeViewControllerDelegate {
    
    let cellId = "cellId"
    let descriptionId = "descriptionId"
    let headerId = "headerId"
    let titleId = "titleId"
    let mapId = "mapId"
    var player:AVPlayer!
    var playerLayer:AVPlayerLayer!
    var toolbar:UIToolbar!

    var mapView:MKMapView!
    let pin = MKPointAnnotation()
    var region: MKCoordinateRegion!
    let locationManager = CLLocationManager()
    
    var listing: Listing.listingResults? {
        didSet {
            if listing?.StandardFields.Photos != nil {
                return
            }
            if listing?.StandardFields.VirtualTours != nil {
                return
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.hidesBottomBarWhenPushed = false

//        var toolbar: UIToolbar!
//
//        toolbar = UIToolbar(frame: CGRect(x:0, y:self.view.bounds.size.height - 84, width: self.view.bounds.size.width, height: 120.0))
//        toolbar.layer.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height-40.0)
//
//
//        self.view.addSubview(toolbar)
        
        setUpToolBarButtons()
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hidesBottomBarWhenPushed = false
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "sherwood")
        imageView.image = image
        navigationItem.titleView = imageView
        
        collectionView?.register(ListingSlides.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(TitleCell.self, forCellWithReuseIdentifier: titleId)
        collectionView?.register(AppDetailDescriptionCell.self, forCellWithReuseIdentifier: descriptionId)
        collectionView?.register(MapCell.self, forCellWithReuseIdentifier: mapId)
        collectionView?.showsVerticalScrollIndicator = false
        
        collectionView?.backgroundColor = UIColor.white
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
//        setupTabBar()

        setupNavBarButtons()
        
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            
            locationManager.stopUpdatingLocation()
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func setupNavBarButtons() {
        let moreButton = UIBarButtonItem(image: UIImage(named: "nav_more_icon")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleVideo))
        moreButton.tintColor = UIColor.black
//        navigationItem.rightBarButtonItems = [moreButton]

        let movieIcon = UIImage(named: "movie")?.withRenderingMode(.alwaysOriginal)
        let videoButton = UIBarButtonItem(image: movieIcon, style: .plain, target: self, action: #selector(handleVideo))
        navigationItem.rightBarButtonItems = [videoButton, moreButton]
    }
    
    
    @objc func addMe(sender: UIBarButtonItem) {
        let textToShare = (listing?.StandardFields.UnparsedFirstLineAddress)
        guard let site = NSURL(string: (listing?.StandardFields.Photos[0].Uri1024)!) else { return }
        let objectsToShare = [textToShare, site] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = sender as? UIView
        activityVC.popoverPresentationController?.barButtonItem = sender
        self.present(activityVC, animated: true, completion: nil)
    }

    @objc func sendMail(sender: UIBarButtonItem) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()

            let leftIconView = CustomImageView()
            leftIconView.image = UIImage(named: "")

            if let thumbnailImageUrl = listing?.StandardFields.Photos[0].Uri640 {
                leftIconView.loadImageUsingUrlString(urlString: (thumbnailImageUrl))
//                if let fileData = UIImageJPEGRepresentation(leftIconView.image!, 1.0) {
//                    if let fileData = Data(thumbnailImageUrl) {
                //mail.addAttachmentData(fileData as Data, mimeType: "image/jpeg", fileName: "swifts")
//                    mail.addAttachmentData(UIImageJPEGRepresentation(fileData, CGFloat(1.0)), mimeType: "image/jpeg", fileName: "swifts")

//                    mail.addAttachmentData(UIImageJPEGRepresentation(UIImage(named: "emailImage")!, CGFloat(1.0))!, mimeType: "image/jpeg", fileName:  "test.jpeg")

                }
                
            

            let emailBody = "<img src='\(leftIconView.imageUrlString!)'>"
            

            mail.mailComposeDelegate = self
            mail.setToRecipients(["artisanb@me.com"])
            mail.setSubject("[iPhone App Contact] Interested in \(listing!.StandardFields.UnparsedFirstLineAddress)")
            mail.setMessageBody(emailBody, isHTML: true)


            present(mail, animated: true)
        } else {
            // show failure alert
            let alertController = UIAlertController(title: "Sherwood Development Company", message: "Your device cannot send emails. Please configure an email address into Settings -> Mail, Contacts, Calendars.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)

        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    

    
    
    func setUpToolBarButtons() {
        
        UIBarButtonItem.appearance().tintColor = UIColor.red
        toolbar = UIToolbar(frame: CGRect(x:0, y:self.view.bounds.size.height - 64, width: self.view.bounds.size.width, height: 70.0))
        toolbar.layer.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height-40.0)

        let compose = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.compose, target: self, action: #selector(sendMail(sender:)))
        let add = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addMe(sender:)))
        let search = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: nil)
        let organize = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.organize, target: self, action: nil)
        let camera = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.bookmarks, target: self, action: nil)

        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)

        toolbar.items = [add, flexible, compose, flexible, search, flexible, organize, flexible, camera]
//        self.toolbar.items. = UITabBarItemPositioning.automatic
        self.view.addSubview(toolbar)
        
//        camera.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -26, right: 0)
//        add.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -26, right: 0)
//        search.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -26, right: 0)
//        organize.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -26, right: 0)
//        compose.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -26, right: 0)

        guard let items = toolbar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)

        }
    }
    @objc func handleVideo(url:NSURL) {
        guard let vidUrl = listing?.StandardFields.VirtualTours[0].Uri else { return }
            print(vidUrl)
        let url = URL(string:vidUrl)
        let player = AVPlayer(url: url!)

        let playerController = AVPlayerViewController()

        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: titleId, for: indexPath) as! TitleCell
            cell.listing = listing
            return cell
        }
        if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptionId, for: indexPath) as! AppDetailDescriptionCell
            cell.textView.attributedText = descriptionAttributedText()
            return cell
        }
        if indexPath.item == 3 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mapId, for: indexPath) as! MapCell
            cell.mapView.mapType = .standard
            cell.mapView.delegate = self
            if let lat = listing?.StandardFields.Latitude, let lng = listing?.StandardFields.Longitude {

                let location = CLLocationCoordinate2DMake(lat, lng)
                let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, 27500.0, 27500.0)
                cell.mapView.setRegion(coordinateRegion, animated: true)
                cell.mapView.centerCoordinate = location
                let pin = MKPointAnnotation()
                
                
                pin.coordinate = location
                pin.title = listing?.StandardFields.UnparsedFirstLineAddress
                if let listPrice = listing?.StandardFields.ListPrice {
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .decimal
                    
                    let subtitle = "$\(numberFormatter.string(from: NSNumber(value:(UInt64(listPrice))))!)"
                    pin.subtitle = subtitle
                }
                
                cell.mapView.addAnnotation(pin)
//                cell.mapView.selectAnnotation(pin, animated: true)

                
            }
            return cell
            
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ListingSlides
        cell.listing = listing
        return cell
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
   
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annoView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Default")
        annoView.pinTintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
//        annoView.animatesDrop = true
        annoView.canShowCallout = true
        let swiftColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
//        annoView.centerOffset = CGPoint(x: 150, y: 150)
        annoView.pinTintColor = swiftColor
        
        // Add a RIGHT CALLOUT Accessory
        let rightButton = UIButton(type: UIButtonType.detailDisclosure)
        rightButton.frame = CGRect(x:0, y:0, width:32, height:32)
        rightButton.layer.cornerRadius = rightButton.bounds.size.width/2
        rightButton.clipsToBounds = true
        rightButton.tintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        
        annoView.rightCalloutAccessoryView = rightButton
        
        //Add a LEFT IMAGE VIEW
        let leftIconView = CustomImageView()
        leftIconView.contentMode = .scaleAspectFill
        
        if let thumbnailImageUrl = listing?.StandardFields.Photos[0].Uri800 {
            leftIconView.loadImageUsingUrlString(urlString: (thumbnailImageUrl))
        }
        
        let newBounds = CGRect(x:0.0, y:0.0, width:54.0, height:54.0)
        leftIconView.bounds = newBounds
        annoView.leftCalloutAccessoryView = leftIconView
        
        return annoView
    }
    
    func goOutToGetMap() {
        
        
        let lat = listing?.StandardFields.Latitude
        let lng = listing?.StandardFields.Longitude
        let location = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
        
        let placemark = MKPlacemark(coordinate: location, addressDictionary: nil)
        
        let item = MKMapItem(placemark: placemark)
        item.name = listing?.StandardFields.UnparsedFirstLineAddress
        item.openInMaps (launchOptions: [MKLaunchOptionsMapTypeKey: 2,
                                         MKLaunchOptionsMapCenterKey:NSValue(mkCoordinate: placemark.coordinate),
                                         MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving])
        
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
        let alertController = UIAlertController(title: nil, message: "Driving directions", preferredStyle: .actionSheet)
        let OKAction = UIAlertAction(title: "Get Directions", style: .default) { (action) in
            self.goOutToGetMap()
        }
        alertController.addAction(OKAction)
        
        present(alertController, animated: true) { }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        alertController.addAction(cancelAction)
    }
    
    fileprivate func descriptionAttributedText() -> NSAttributedString {
        
        
        let attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)])
        
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        
        let range = NSMakeRange(0, attributedText.string.count)
        attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: range)
        
        if let desc = listing?.StandardFields.PublicRemarks {
            attributedText.append(NSAttributedString(string: desc, attributes: [NSAttributedStringKey.font: UIFont(name: "Avenir Light", size: 16)!, NSAttributedStringKey.foregroundColor: UIColor.darkGray]))
        }
        
        return attributedText
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 1 {
            
            //            let dummySize = CGSize(width: view.frame.width - 8 - 8, height: 1000)
            //            let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
            //            let rect = descriptionAttributedText().boundingRect(with: dummySize, options: options, context: nil)
            
            return CGSize(width: view.frame.width, height: 30)
        }
        if indexPath.item == 2 {
            let dummySize = CGSize(width: view.frame.width - 8 - 8, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
            let rect = descriptionAttributedText().boundingRect(with: dummySize, options: options, context: nil)
            
            return CGSize(width: view.frame.width, height: rect.height + 50)
        }
        if indexPath.item == 3 {
            
            
            return CGSize(width: view.frame.width, height: 300)
            
        }
        return CGSize(width: view.frame.width, height: 300)
    }
    
    
    
}


class TitleCell: BaseCell {
    var listing: Listing.listingResults? {
        didSet {
            
            if let theAddress = listing?.StandardFields.UnparsedFirstLineAddress {
                
                nameLabel.text = theAddress.uppercased()
            }
            
            if let listPrice = listing?.StandardFields.ListPrice{
                let nf = NumberFormatter()
                nf.numberStyle = .decimal
                let subTitleCost = "$\(nf.string(from: NSNumber(value:(UInt64(listPrice))))!)"
                costLabel.text = subTitleCost
            }
        }
    }
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "TEST"
        label.font = UIFont(name: "Avenir Heavy", size: 17)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    let costLabel: UILabel = {
        let label = UILabel()
        label.text = "400"
        label.font =  UIFont(name: "Avenir Heavy", size: 16)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    let viewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    override func setupViews() {
        
        
        addSubview(viewContainer)
        addSubview(nameLabel)
        addSubview(costLabel)
        
        addConstraintsWithFormat("H:|[v0]|", views: viewContainer)
        addConstraintsWithFormat("V:|[v0(40)]|", views: viewContainer)
        
        addConstraintsWithFormat("H:|[v0]|", views: nameLabel)
        addConstraintsWithFormat("V:|[v0]-8-|", views: nameLabel)
        
        addConstraintsWithFormat("H:|[v0]|", views: costLabel)
        addConstraintsWithFormat("V:|-22-[v0]", views: costLabel)
        
    }
}
class AppDetailDescriptionCell: BaseCell {
    
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont(name: "Avenir Light", size: 16)

        tv.text = "SAMPLE DESCRIPTION"
        tv.isEditable = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(textView)
        addSubview(dividerLineView)
        
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: textView)
        addConstraintsWithFormat("H:|-14-[v0]-14-|", views: dividerLineView)
        
        addConstraintsWithFormat("V:|-4-[v0]-4-[v1(1)]|", views: textView, dividerLineView)
    }
}



class MapCell: BaseCell, MKMapViewDelegate  {
    
    var mapView = MKMapView()
    
    var listing: Listing? {
        didSet {
            //            if let lat = listing?.geo?.lat, let lng = listing?.geo?.lng {
            //
            //                let location = CLLocationCoordinate2DMake(lat, lng)
            //                let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, 27500.0, 27500.0)
            //                mapView.setRegion(coordinateRegion, animated: false)
            //
            //                let pin = MKPointAnnotation()
            //
            //                pin.coordinate = location
            //                mapView.addAnnotation(pin)
            //
            //            }
        }
    }
    
    override func setupViews() {
        
        addSubview(mapView)
        addConstraintsWithFormat("H:|[v0]|", views: mapView)
        addConstraintsWithFormat("V:|[v0]|", views: mapView)
    }
}













extension UIView {
    
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}

//class BaseCell: UICollectionViewCell {
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func setupViews() {
//
//    }
//}
//
