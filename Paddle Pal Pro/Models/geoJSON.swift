//
//  geoJSON.swift
//  Paddle Pal Pro
//
//  Created by Warren Zimmerman on 2/6/21.
//  Copyright © 2021 Warren Zimmerman. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

struct FeatureCollection: Codable
{
    let type = "Feature"
    struct Properties: Codable
    {
        let NAME: String
        let TYPE: String
    }
    
    struct Geometry: Codable
    {
        let type: String
        let coordinates: [Coordinate]
    }
    let id: String
}


struct Coordinate: Codable
{
    let coord: [Double]
}
