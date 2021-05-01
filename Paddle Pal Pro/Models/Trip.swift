//
//  Trip.swift
//  Paddle Pal Pro
//
//  Created by Warren Zimmerman on 3/4/20.
//  Copyright © 2020 Warren Zimmerman. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

class Trip: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var tripName: String = ""
    @objc dynamic var color : String = ""
    @objc dynamic var date: Date?
    @objc dynamic var totalTime: String?
    
    @objc dynamic var tripUser: String = ""
}


//class TripCoords: Object {
//    @objc dynamic var Id: Int = 0
//    @objc dynamic var TripId: Int = 0
//    @objc dynamic var coordinate: Array<Double> = []
//}
