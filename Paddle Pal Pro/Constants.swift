//
//  Constants.swift
//  Paddle Pal Pro
//
//  Created by Warren Zimmerman on 3/4/20.
//  Copyright © 2020 Warren Zimmerman. All rights reserved.
//

struct K {
    static let appName = "Paddle Pal"
    static let cellIdentifier = "TripItemCell"
    static let cellNibName = "TripNibCell"
    static let registerSegue = "TripsViewRegisterSegue"
    static let loginSegue = "TripsViewLoginSegue"
    static let registerToLoginSegue = "RegisterToLoginSegue"
    static let tripDetailSegue = "TripDetailViewSegue"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "trips"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
