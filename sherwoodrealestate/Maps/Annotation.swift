//
//  Annotation.swift
//  sherwoodrealestate
//
//  Created by Alex Beattie on 5/21/18.
//  Copyright © 2018 Alex Beattie. All rights reserved.
//

import MapKit
import Contacts

class ListingAnno: NSObject, MKAnnotation {
   
    var anno: Listing.listingResults?

    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?


    init(title:String, coordinate: CLLocationCoordinate2D, subTitle: String) {
        self.title = title
        self.coordinate = coordinate
        self.subtitle = subTitle
        super.init()
    }
}



