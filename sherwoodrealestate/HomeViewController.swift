//
//  ViewController.swift
//  sherwoodrealestate
//
//  Created by Alex Beattie on 5/21/18.
//  Copyright © 2018 Alex Beattie. All rights reserved.
//

import UIKit
import SafariServices

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, SFSafariViewControllerDelegate {
    
    let cellId = "cellId"
    
    var newList:Listing!
    
    var listings: [Listing.listingResults]?
    var token: [Listing.resultsArr]?
    var photos : [Listing.standardFields.PhotoDictionary]?
    var picture = [[String: Any]]()


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UINavigationBar.appearance().tintColor = UIColor.black
        navigationItem.backBarButtonItem = UIBarButtonItem(title:" ", style: .plain, target: nil, action: nil)
        self.tabBarController?.tabBar.isHidden = false

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false


        Listing.standardFields.fetchListing { (listings) -> () in
            self.listings = listings.D.Results
            DispatchQueue.main.async() {
                self.collectionView?.reloadData()
            }
            
        }
        
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "sherwood")
        imageView.image = image
        navigationItem.titleView = imageView


        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(HomeCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        

        collectionView?.contentInset = UIEdgeInsetsMake(-8, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(-8, 0, 0, 0)

        //setupCollectionView()
        //setupMenuBar()
        setupNavBarButtons()


    }

//    override func viewWillDisappear(_ animated: Bool) {
//        self.hidesBottomBarWhenPushed = true
//    }
    func setupNavBarButtons() {
//        let searchImage = UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal)
//        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        
        
        let moreButton = UIBarButtonItem(image: UIImage(named: "nav_more_icon")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))
        moreButton.tintColor = UIColor.black
        navigationItem.rightBarButtonItems = [moreButton]


    }
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.homeController = self
        return launcher
    }()
    @objc func handleMore() {
//        print(123)
        //show menu
        settingsLauncher.showSettings()
    }
    func showControllerForWebsite(setting: Setting) {
        guard let url = URL(string: "http://sherwoodrealestate.com/about-us") else {
            return
        }
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.delegate = self
        self.present(safariViewController, animated: true)
    }
    func showControllerForSetting(_ setting: Setting) {
        let dummySettingsViewController = UIViewController()
        dummySettingsViewController.view.backgroundColor = UIColor.white
//        dummySettingsViewController.navigationItem.title = setting.name.rawValue
        navigationController?.navigationBar.tintColor = UIColor(red: 66, green: 66, blue: 66, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red: 66, green: 66, blue: 66, alpha: 1)
]
//        navigationController?.pushViewController(dummySettingsViewController, animated: true)
    }
    func setupBackBarButton() {
        let barBtn = UIBarButtonItem()
        barBtn.title = " "
        barBtn.tintColor = UIColor.black
        navigationItem.backBarButtonItem = barBtn
    }
    func showControllerForMap(setting: Setting) {
        
        let mapVC = AllListingsMapVC()
       setupBackBarButton()

        navigationController?.pushViewController(mapVC, animated: true)
        
        }
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    func showControllerForSwitchAccount(setting: Setting) {
        setupBackBarButton()
//        print(123)
    }
    func showControllerForHelp(setting: Setting) {

//        let layout = UICollectionViewFlowLayout()
//        setupBackBarButton()
//        let aboutSherwoodVC = AboutSherwoodVC(collectionViewLayout: layout)
        
        
       // navigationController?.pushViewController(aboutSherwoodVC, animated: true)

    
    }
    @objc func handleSearch() {
//        print(123)
    }
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.addConstraintsWithFormat("H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat("V:|[v0(50)]", views: menuBar)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let height = (view.frame.width - 16 - 16) * 9 / 16
        return CGSize(width: view.frame.width, height: height + 16 + 88)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    
    func showListingDetailController(_ listing: Listing.listingResults) {
        let layout = UICollectionViewFlowLayout()
        let listingDetailController = ListingDetailController(collectionViewLayout: layout)
        
        
        listingDetailController.listing = listing
//        let backItem = UIBarButtonItem()
//        backItem.tintColor = UIColor(red: 66, green: 66, blue: 66, alpha: 1)
//        navigationItem.backBarButtonItem = backItem
//        self.hidesBottomBarWhenPushed = true
        self.tabBarController?.tabBar.isHidden = true

        navigationController?.pushViewController(listingDetailController, animated: true)
    }
    // MARK: - Home CollectionViewController
    
    let homeCollectionView:UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
        
    }()
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeCell
        
        cell.listing = listings?[indexPath.item]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = listings?.count {
            return count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
   
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if let listing = listings?[indexPath.item] {
            let barBtn = UIBarButtonItem()
            barBtn.title = ""
            barBtn.tintColor = UIColor.black
            navigationItem.backBarButtonItem = barBtn

            showListingDetailController(listing)
            print(listing.Id)
            
//            let filteredCall = "https://sparkapi.com/v1/my/listings?AuthToken=\(api.authToken)&_expand=Photos\(api.comma)Videos\(api.comma)VirtualTours\(api.comma)OpenHouses\(api.comma)UserInterfaceDisplay&_filter=Not\(api.space)MlsStatus\(api.space)Eq\(api.space)\(api.quote)Sold\(api.quote)&_orderby=-ListPrice&ApiSig=\(api.filteredApiSig)"
            

        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
}

class HomeCell: UICollectionViewCell {
    var listing: Listing.listingResults? {
        didSet {
            
           
            
            if let listingId = listing?.Id {
                print(listingId)
            }
            setupThumbNailImage()
            
//            if let thePhoto = listing?.StandardFields.Photos[0].Uri1024 {
//                imageView.image
//            }
            if let theAddress = listing?.StandardFields.UnparsedFirstLineAddress {
                nameLabel.text = theAddress.uppercased()
            }
            
//            if let listPrice = listing?.StandardFields.ListPrice {
//                let nf = NumberFormatter()
//                nf.numberStyle = .decimal
//                let subTitleCost = "$\(nf.string(from: NSNumber(value:(UInt64(listPrice))))!)"
//                costLabel.text = subTitleCost
//            }
        }
    }
//    var token: Listing.resultsArr? {
//        didSet {
//            var emptyToken:[Listing.resultsArr]!
//            let newToken: String?
//            print(emptyToken.first)
//
////            print(newToken)
//
//        }
//    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Best New Apps"
//        label.text?.uppercased()
        label.font = UIFont(name: "Avenir Heavy", size: 17)
        label.sizeToFit()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let costLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.font = UIFont(name: "Avenir Heavy", size: 16)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bedRoom: UILabel = {
        let label = UILabel()
        label.text = " "
        label.font = UIFont(name: "Avenir Heavy", size: 16)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let bathRoom: UILabel = {
        let label = UILabel()
        label.text = " "
        label.font = UIFont(name: "Avenir Heavy", size: 16)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let squareFeet: UILabel = {
        let label = UILabel()
        label.text = " "
        label.font = UIFont(name: "Avenir Heavy", size: 16)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    
    let imageView: CustomImageView = {
        let iv = CustomImageView()
        iv.image = UIImage(named:"pic")
//        iv.backgroundColor = UIColor.black
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = true
        return iv
    }()




    func setupThumbNailImage() {


        if let thumbnailImageUrl = listing?.StandardFields.Photos[0].Uri1024 {
            imageView.loadImageUsingUrlString(urlString: (thumbnailImageUrl))
        }

    }
    func setupViews() {
//        backgroundColor = UIColor.clear

        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(costLabel)

        addConstraintsWithFormat(format: "H:|-14-[v0]-14-|", views: nameLabel)
        addConstraintsWithFormat(format: "V:[v0]-20-|", views: nameLabel)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: costLabel)
        addConstraintsWithFormat(format: "V:[v0]-4-|", views: costLabel)
        
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: imageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: imageView)


    }
}






let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    var imageUrlString: String?
    func loadImageUsingUrlString(urlString: String) {
        imageUrlString = urlString
        
        let url = URL(string: urlString)
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                let imageToCache = UIImage(data:data!)
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                
            }
            
        }).resume()
    }
}

class GradientView: UIView {
    lazy private var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.clear.cgColor, UIColor(white: 0.0, alpha: 0.75).cgColor]
        layer.locations = [NSNumber(value: 0.0), NSNumber(value: 1.0)]
        return layer
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews() {
    }
}

