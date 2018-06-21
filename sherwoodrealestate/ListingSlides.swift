//
//  ListingSlides.swift
//  sherwoodrealestate
//
//  Created by Alex Beattie on 5/21/18.
//  Copyright © 2018 Alex Beattie. All rights reserved.
//

import UIKit

class ListingSlides: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var listings: [Listing.listingResults]!
    
    var images:[String] = []
//    var images:String?
    var emptyPhotoArray = [String]()

    var listing: Listing.listingResults? {
        didSet {

            for aListing in (listing?.StandardFields.Photos)! {
                    emptyPhotoArray.append(aListing.Uri1024)
                
                    self.images = self.emptyPhotoArray
                

            }

//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
            
        }
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.clear
        return cv
    }()
    
    let cellId = "cellId"
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
       
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        addSubview(collectionView)
        addSubview(dividerLineView)
        
        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        
        addConstraintsWithFormat("H:|-14-[v0]-14-|", views: dividerLineView)
        
        addConstraintsWithFormat("V:|[v0][v1(1)]|", views: collectionView, dividerLineView)
        
        collectionView.register(ListingImageCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = listing?.StandardFields.Photos.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ListingImageCell
        

        let url = self.images[indexPath.row]
        if URL(string: url) != nil {
            cell.imageView.loadImageUsingUrlString(urlString: (url))
        }

        
        
//        if let imageUrl = URL(string: url) {
//            URLSession.shared.dataTask(with: URLRequest(url: imageUrl)) { (data, response, error) in
//                if let data = data {
//                    DispatchQueue.main.async {
//                        cell.imageView.image = UIImage(data: data)
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        cell.imageView.image = nil
//                    }
//                }
//            }.resume()
//        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    class ListingImageCell: BaseCell {
        var listing:Listing.listingResults? {
            didSet {
            }
        }
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupViews()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        var imageView: CustomImageView = {
            let iv = CustomImageView()
            iv.contentMode = .scaleAspectFill
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.layer.masksToBounds = true
            iv.backgroundColor = UIColor.clear
            return iv
        }()
        
        override func setupViews() {
            super.setupViews()
            
            layer.masksToBounds = true
            
            addSubview(imageView)
            addConstraintsWithFormat("H:|[v0]|", views: imageView)
            addConstraintsWithFormat("V:|[v0]|", views: imageView)
        }
        
    }
    
}

//extension String {
//
//    subscript (r: CountableClosedRange<Int>) -> String {
//        get {
//            let startIndex =  self.index(self.startIndex, offsetBy: r.lowerBound)
//            let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
//            return String(self[startIndex...endIndex])
//        }
//    }
//}

